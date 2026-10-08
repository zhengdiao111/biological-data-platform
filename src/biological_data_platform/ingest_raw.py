from argparse import ArgumentParser
from pathlib import Path

import pandas as pd
from sqlalchemy import text

from .database import engine


PROJECT_ROOT = Path(__file__).resolve().parents[2]


SOURCES = {
    "lims": {
        "path": PROJECT_ROOT / "data" / "raw" / "lims" / "experiments.csv",
        "schema": "raw",
        "table": "lims_experiment",
        "expected_columns": [
            "experiment_code",
            "experiment_date",
            "researcher",
            "construct_code",
            "perturbation",
            "dose",
            "dose_unit",
        ],
    },
    "registry": {
        "path": PROJECT_ROOT
        / "data"
        / "raw"
        / "registry"
        / "constructs.csv",
        "schema": "raw",
        "table": "construct_registry",
        "expected_columns": [
            "construct_code",
            "promoter",
            "activation_domain",
            "binding_site_count",
        ],
    },
    "instrument": {
        "path": PROJECT_ROOT
        / "data"
        / "raw"
        / "instrument"
        / "measurements.csv",
        "schema": "raw",
        "table": "instrument_measurement",
        "expected_columns": [
            "experiment_code",
            "cell_id",
            "time_seconds",
            "intensity",
        ],
    },
}


def read_source(source_name: str, config: dict) -> pd.DataFrame:
    path = config["path"]

    if not path.exists():
        raise FileNotFoundError(
            f"Source file does not exist: {path}"
        )

    # Read everything as text because this is the RAW layer.
    dataframe = pd.read_csv(
        path,
        dtype=str,
    )

    expected = config["expected_columns"]
    actual = dataframe.columns.tolist()

    if actual != expected:
        raise ValueError(
            f"{source_name} schema mismatch.\n"
            f"Expected: {expected}\n"
            f"Actual:   {actual}"
        )

    # Preserve where each row came from.
    dataframe["source_file"] = path.name

    return dataframe


def table_row_count(
    connection,
    schema: str,
    table: str,
) -> int:
    query = text(
        f"SELECT COUNT(*) FROM {schema}.{table}"
    )

    return connection.execute(query).scalar_one()


def reset_raw_tables(connection) -> None:
    print("Resetting RAW tables...")

    connection.execute(
        text(
            """
            TRUNCATE TABLE
                raw.lims_experiment,
                raw.construct_registry,
                raw.instrument_measurement;
            """
        )
    )


def ingest_source(
    connection,
    source_name: str,
    config: dict,
) -> None:
    schema = config["schema"]
    table = config["table"]

    existing_rows = table_row_count(
        connection,
        schema,
        table,
    )

    if existing_rows > 0:
        raise RuntimeError(
            f"{schema}.{table} already contains "
            f"{existing_rows} rows.\n"
            "Use --reset if you want to reload the "
            "development dataset."
        )

    dataframe = read_source(
        source_name,
        config,
    )

    dataframe.to_sql(
        name=table,
        schema=schema,
        con=connection,
        if_exists="append",
        index=False,
        method="multi",
    )

    print(
        f"Loaded {len(dataframe):>4} rows "
        f"into {schema}.{table}"
    )


def main(reset: bool = False) -> None:
    with engine.begin() as connection:

        if reset:
            reset_raw_tables(connection)

        for source_name, config in SOURCES.items():
            ingest_source(
                connection,
                source_name,
                config,
            )

    print()
    print("RAW ingestion complete.")


if __name__ == "__main__":
    parser = ArgumentParser()

    parser.add_argument(
        "--reset",
        action="store_true",
        help="Clear RAW tables before loading.",
    )

    args = parser.parse_args()

    main(reset=args.reset)