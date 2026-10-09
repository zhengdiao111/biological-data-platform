-- ============================================================
-- LIMS STAGING VIEW
-- ============================================================

CREATE OR REPLACE VIEW stage.stg_lims_experiment AS

SELECT

    -- ------------------------------
    -- Standardized business keys
    -- ------------------------------

    UPPER(TRIM(experiment_code))
        AS experiment_bk,

    UPPER(TRIM(construct_code))
        AS construct_bk,

    UPPER(TRIM(perturbation))
        AS perturbation_bk,


    -- ------------------------------
    -- Hub hash keys
    -- ------------------------------

    ENCODE(
        DIGEST(
            UPPER(TRIM(experiment_code)),
            'sha256'
        ),
        'hex'
    ) AS experiment_hk,


    ENCODE(
        DIGEST(
            UPPER(TRIM(construct_code)),
            'sha256'
        ),
        'hex'
    ) AS construct_hk,


    ENCODE(
        DIGEST(
            UPPER(TRIM(perturbation)),
            'sha256'
        ),
        'hex'
    ) AS perturbation_hk,


    -- ------------------------------
    -- Link hash keys
    -- ------------------------------

    ENCODE(
        DIGEST(
            CONCAT_WS(
                '||',
                UPPER(TRIM(experiment_code)),
                UPPER(TRIM(construct_code))
            ),
            'sha256'
        ),
        'hex'
    ) AS experiment_construct_hk,


    ENCODE(
        DIGEST(
            CONCAT_WS(
                '||',
                UPPER(TRIM(experiment_code)),
                UPPER(TRIM(perturbation))
            ),
            'sha256'
        ),
        'hex'
    ) AS experiment_perturbation_hk,


    -- ------------------------------
    -- Descriptive attributes
    -- ------------------------------

    experiment_date,

    researcher,

    dose,

    dose_unit,


    -- ------------------------------
    -- Hash differences
    -- ------------------------------

    ENCODE(
        DIGEST(
            CONCAT_WS(
                '||',
                COALESCE(TRIM(experiment_date), ''),
                COALESCE(TRIM(researcher), '')
            ),
            'sha256'
        ),
        'hex'
    ) AS experiment_hashdiff,


    ENCODE(
        DIGEST(
            CONCAT_WS(
                '||',
                COALESCE(TRIM(dose), ''),
                COALESCE(TRIM(dose_unit), '')
            ),
            'sha256'
        ),
        'hex'
    ) AS experiment_perturbation_hashdiff,


    -- ------------------------------
    -- Technical metadata
    -- ------------------------------

    loaded_at AS load_dts,

    CONCAT(
        'LIMS:',
        source_file
    ) AS record_source


FROM raw.lims_experiment;


-- ============================================================
-- CONSTRUCT REGISTRY STAGING VIEW
-- ============================================================

CREATE OR REPLACE VIEW stage.stg_construct_registry AS

SELECT

    UPPER(TRIM(construct_code))
        AS construct_bk,


    ENCODE(
        DIGEST(
            UPPER(TRIM(construct_code)),
            'sha256'
        ),
        'hex'
    ) AS construct_hk,


    promoter,

    activation_domain,

    binding_site_count,


    ENCODE(
        DIGEST(
            CONCAT_WS(
                '||',
                COALESCE(TRIM(promoter), ''),
                COALESCE(TRIM(activation_domain), ''),
                COALESCE(TRIM(binding_site_count), '')
            ),
            'sha256'
        ),
        'hex'
    ) AS construct_hashdiff,


    loaded_at AS load_dts,

    CONCAT(
        'CONSTRUCT_REGISTRY:',
        source_file
    ) AS record_source


FROM raw.construct_registry;