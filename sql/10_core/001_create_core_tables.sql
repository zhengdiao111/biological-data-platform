CREATE TABLE core.project (

    project_id BIGSERIAL PRIMARY KEY,

    project_name TEXT NOT NULL UNIQUE
);


CREATE TABLE core.promoter (

    promoter_id BIGSERIAL PRIMARY KEY,

    promoter_name TEXT NOT NULL UNIQUE,

    sequence TEXT
);


CREATE TABLE core.construct (

    construct_id BIGSERIAL PRIMARY KEY,

    construct_code TEXT NOT NULL UNIQUE,

    promoter_id BIGINT NOT NULL,

    activation_domain TEXT,

    binding_site_count INTEGER,

    CONSTRAINT fk_construct_promoter
        FOREIGN KEY (promoter_id)
        REFERENCES core.promoter(promoter_id)
);


CREATE TABLE core.experiment (

    experiment_id BIGSERIAL PRIMARY KEY,

    experiment_code TEXT NOT NULL UNIQUE,

    project_id BIGINT NOT NULL,

    experiment_date DATE,

    operator_name TEXT,

    instrument TEXT,

    CONSTRAINT fk_experiment_project
        FOREIGN KEY (project_id)
        REFERENCES core.project(project_id)
);


CREATE TABLE core.perturbation (

    perturbation_id BIGSERIAL PRIMARY KEY,

    perturbation_name TEXT NOT NULL UNIQUE,

    perturbation_type TEXT
);


CREATE TABLE core.experiment_perturbation (

    experiment_id BIGINT NOT NULL,

    perturbation_id BIGINT NOT NULL,

    dose_value DOUBLE PRECISION,

    dose_unit TEXT,

    duration_hours DOUBLE PRECISION,

    PRIMARY KEY (
        experiment_id,
        perturbation_id
    ),

    FOREIGN KEY (experiment_id)
        REFERENCES core.experiment(experiment_id),

    FOREIGN KEY (perturbation_id)
        REFERENCES core.perturbation(perturbation_id)
);


CREATE TABLE core.cell (

    cell_id BIGSERIAL PRIMARY KEY,

    experiment_id BIGINT NOT NULL,

    source_cell_id TEXT NOT NULL,

    field_of_view INTEGER,

    FOREIGN KEY (experiment_id)
        REFERENCES core.experiment(experiment_id),

    UNIQUE (
        experiment_id,
        source_cell_id
    )
);


CREATE TABLE core.measurement (

    measurement_id BIGSERIAL PRIMARY KEY,

    cell_id BIGINT NOT NULL,

    time_seconds DOUBLE PRECISION NOT NULL,

    signal_intensity DOUBLE PRECISION,

    FOREIGN KEY (cell_id)
        REFERENCES core.cell(cell_id),

    UNIQUE (
        cell_id,
        time_seconds
    )
);