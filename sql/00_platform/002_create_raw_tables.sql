CREATE TABLE raw.lims_experiment (

    experiment_code TEXT,

    experiment_date TEXT,

    researcher TEXT,

    construct_code TEXT,

    perturbation TEXT,

    dose TEXT,

    dose_unit TEXT,

    source_file TEXT,

    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE raw.construct_registry (

    construct_code TEXT,

    promoter TEXT,

    activation_domain TEXT,

    binding_site_count TEXT,

    source_file TEXT,

    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE raw.instrument_measurement (

    experiment_code TEXT,

    cell_id TEXT,

    time_seconds TEXT,

    intensity TEXT,

    source_file TEXT,

    loaded_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);