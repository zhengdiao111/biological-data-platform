BEGIN;


-- ============================================================
-- HUB EXPERIMENT
-- ============================================================

INSERT INTO vault.hub_experiment (
    experiment_hk,
    experiment_bk,
    load_dts,
    record_source
)

SELECT DISTINCT
    experiment_hk,
    experiment_bk,
    load_dts,
    record_source

FROM stage.stg_lims_experiment

ON CONFLICT (experiment_hk)
DO NOTHING;

INSERT INTO vault.hub_construct (
    construct_hk,
    construct_bk,
    load_dts,
    record_source
)

SELECT DISTINCT
    construct_hk,
    construct_bk,
    load_dts,
    record_source

FROM stage.stg_construct_registry

ON CONFLICT (construct_hk)
DO NOTHING;

INSERT INTO vault.hub_perturbation (
    perturbation_hk,
    perturbation_bk,
    load_dts,
    record_source
)

SELECT DISTINCT
    perturbation_hk,
    perturbation_bk,
    load_dts,
    record_source

FROM stage.stg_lims_experiment

ON CONFLICT (perturbation_hk)
DO NOTHING;


-- ============================================================
-- LINK EXPERIMENT ↔ CONSTRUCT
-- ============================================================

INSERT INTO vault.link_experiment_construct (
    experiment_construct_hk,
    experiment_hk,
    construct_hk,
    load_dts,
    record_source
)

SELECT DISTINCT
    experiment_construct_hk,
    experiment_hk,
    construct_hk,
    load_dts,
    record_source

FROM stage.stg_lims_experiment

ON CONFLICT (experiment_construct_hk)
DO NOTHING;


-- ============================================================
-- LINK EXPERIMENT ↔ PERTURBATION
-- ============================================================

INSERT INTO vault.link_experiment_perturbation (
    experiment_perturbation_hk,
    experiment_hk,
    perturbation_hk,
    load_dts,
    record_source
)

SELECT DISTINCT
    experiment_perturbation_hk,
    experiment_hk,
    perturbation_hk,
    load_dts,
    record_source

FROM stage.stg_lims_experiment

ON CONFLICT (experiment_perturbation_hk)
DO NOTHING;



-- ============================================================
-- SAT EXPERIMENT DETAILS
-- ============================================================

INSERT INTO vault.sat_experiment_details (
    experiment_hk,
    load_dts,
    record_source,
    hashdiff,
    experiment_date,
    researcher
)

SELECT
    s.experiment_hk,
    s.load_dts,
    s.record_source,
    s.experiment_hashdiff,
    s.experiment_date,
    s.researcher

FROM stage.stg_lims_experiment s

WHERE NOT EXISTS (

    SELECT 1

    FROM vault.sat_experiment_details existing

    WHERE existing.experiment_hk =
          s.experiment_hk

      AND existing.hashdiff =
          s.experiment_hashdiff
);

-- ============================================================
-- SAT CONSTRUCT DETAILS
-- ============================================================

INSERT INTO vault.sat_construct_details (
    construct_hk,
    load_dts,
    record_source,
    hashdiff,
    promoter,
    activation_domain,
    binding_site_count
)

SELECT
    s.construct_hk,
    s.load_dts,
    s.record_source,
    s.construct_hashdiff,
    s.promoter,
    s.activation_domain,
    s.binding_site_count

FROM stage.stg_construct_registry s

WHERE NOT EXISTS (

    SELECT 1

    FROM vault.sat_construct_details existing

    WHERE existing.construct_hk =
          s.construct_hk

      AND existing.hashdiff =
          s.construct_hashdiff
);

-- ============================================================
-- SAT EXPERIMENT ↔ PERTURBATION DETAILS
-- ============================================================

INSERT INTO vault.sat_experiment_perturbation_details (
    experiment_perturbation_hk,
    load_dts,
    record_source,
    hashdiff,
    dose,
    dose_unit
)

SELECT
    s.experiment_perturbation_hk,
    s.load_dts,
    s.record_source,
    s.experiment_perturbation_hashdiff,
    s.dose,
    s.dose_unit

FROM stage.stg_lims_experiment s

WHERE NOT EXISTS (

    SELECT 1

    FROM vault.sat_experiment_perturbation_details existing

    WHERE existing.experiment_perturbation_hk =
          s.experiment_perturbation_hk

      AND existing.hashdiff =
          s.experiment_perturbation_hashdiff
);

COMMIT;