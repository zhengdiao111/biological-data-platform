from sqlalchemy import create_engine, text

from .config import DATABASE_URL


engine = create_engine(DATABASE_URL)


def test_connection() -> None:
    with engine.connect() as connection:
        database_name = connection.execute(
            text("SELECT current_database();")
        ).scalar_one()

        print(f"Connected to database: {database_name}")


if __name__ == "__main__":
    test_connection()