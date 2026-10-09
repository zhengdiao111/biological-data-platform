-- ============================================================
-- HUB: EXPERIMENT
-- ============================================================

CREATE TABLE vault.hub_experiment (

    experiment_hk TEXT PRIMARY KEY,

    experiment_bk TEXT NOT NULL UNIQUE,

    load_dts TIMESTAMPTZ NOT NULL,

    record_source TEXT NOT NULL
);


-- ============================================================
-- HUB: CONSTRUCT
-- ============================================================

CREATE TABLE vault.hub_construct (

    construct_hk TEXT PRIMARY KEY,

    construct_bk TEXT NOT NULL UNIQUE,

    load_dts TIMESTAMPTZ NOT NULL,

    record_source TEXT NOT NULL
);


-- ============================================================
-- HUB: PERTURBATION
-- ============================================================

CREATE TABLE vault.hub_perturbation (

    perturbation_hk TEXT PRIMARY KEY,

    perturbation_bk TEXT NOT NULL UNIQUE,

    load_dts TIMESTAMPTZ NOT NULL,

    record_source TEXT NOT NULL
);

-- ============================================================
-- LINK: EXPERIMENT ↔ CONSTRUCT
-- ============================================================

CREATE TABLE vault.link_experiment_construct (

    experiment_construct_hk TEXT PRIMARY KEY,

    experiment_hk TEXT NOT NULL,

    construct_hk TEXT NOT NULL,

    load_dts TIMESTAMPTZ NOT NULL,

    record_source TEXT NOT NULL,

    FOREIGN KEY (experiment_hk)
        REFERENCES vault.hub_experiment(experiment_hk),

    FOREIGN KEY (construct_hk)
        REFERENCES vault.hub_construct(construct_hk)
);


-- ============================================================
-- LINK: EXPERIMENT ↔ PERTURBATION
-- ============================================================

CREATE TABLE vault.link_experiment_perturbation (

    experiment_perturbation_hk TEXT PRIMARY KEY,

    experiment_hk TEXT NOT NULL,

    perturbation_hk TEXT NOT NULL,

    load_dts TIMESTAMPTZ NOT NULL,

    record_source TEXT NOT NULL,

    FOREIGN KEY (experiment_hk)
        REFERENCES vault.hub_experiment(experiment_hk),

    FOREIGN KEY (perturbation_hk)
        REFERENCES vault.hub_perturbation(perturbation_hk)
);

-- ============================================================
-- SATELLITE: EXPERIMENT DETAILS
-- ============================================================

CREATE TABLE vault.sat_experiment_details (

    experiment_hk TEXT NOT NULL,

    load_dts TIMESTAMPTZ NOT NULL,

    record_source TEXT NOT NULL,

    hashdiff TEXT NOT NULL,

    experiment_date TEXT,

    researcher TEXT,

    PRIMARY KEY (
        experiment_hk,
        load_dts
    ),

    FOREIGN KEY (experiment_hk)
        REFERENCES vault.hub_experiment(experiment_hk)
);

-- ============================================================
-- SATELLITE: CONSTRUCT DETAILS
-- ============================================================

CREATE TABLE vault.sat_construct_details (

    construct_hk TEXT NOT NULL,

    load_dts TIMESTAMPTZ NOT NULL,

    record_source TEXT NOT NULL,

    hashdiff TEXT NOT NULL,

    promoter TEXT,

    activation_domain TEXT,

    binding_site_count TEXT,

    PRIMARY KEY (
        construct_hk,
        load_dts
    ),

    FOREIGN KEY (construct_hk)
        REFERENCES vault.hub_construct(construct_hk)
);

-- ============================================================
-- LINK SATELLITE:
-- EXPERIMENT ↔ PERTURBATION DETAILS
-- ============================================================

CREATE TABLE vault.sat_experiment_perturbation_details (

    experiment_perturbation_hk TEXT NOT NULL,

    load_dts TIMESTAMPTZ NOT NULL,

    record_source TEXT NOT NULL,

    hashdiff TEXT NOT NULL,

    dose TEXT,

    dose_unit TEXT,

    PRIMARY KEY (
        experiment_perturbation_hk,
        load_dts
    ),

    FOREIGN KEY (experiment_perturbation_hk)
        REFERENCES vault.link_experiment_perturbation(
            experiment_perturbation_hk
        )
);