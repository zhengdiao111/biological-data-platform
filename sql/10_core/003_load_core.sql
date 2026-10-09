BEGIN;


-- ============================================================
-- 1. PROJECT
-- ============================================================

INSERT INTO core.project (
    project_name
)
VALUES (
    'Synthetic Transcription Study'
)

ON CONFLICT (project_name)
DO NOTHING;


-- ============================================================
-- 2. PROMOTER
-- ============================================================

INSERT INTO core.promoter (
    promoter_name
)

SELECT DISTINCT
    TRIM(promoter)

FROM raw.construct_registry

WHERE promoter IS NOT NULL
  AND TRIM(promoter) <> ''

ON CONFLICT (promoter_name)
DO NOTHING;


-- ============================================================
-- 3. CONSTRUCT
-- ============================================================

INSERT INTO core.construct (
    construct_code,
    promoter_id,
    activation_domain,
    binding_site_count
)

SELECT
    TRIM(r.construct_code),

    p.promoter_id,

    NULLIF(
        TRIM(r.activation_domain),
        ''
    ),

    CASE
        WHEN NULLIF(
            TRIM(r.binding_site_count),
            ''
        ) IS NULL
        THEN NULL

        ELSE
            TRIM(r.binding_site_count)::INTEGER
    END

FROM raw.construct_registry r

JOIN core.promoter p
    ON p.promoter_name = TRIM(r.promoter)

ON CONFLICT (construct_code)

DO UPDATE SET
    promoter_id =
        EXCLUDED.promoter_id,

    activation_domain =
        EXCLUDED.activation_domain,

    binding_site_count =
        EXCLUDED.binding_site_count;


-- ============================================================
-- 4. EXPERIMENT
-- ============================================================

INSERT INTO core.experiment (
    experiment_code,
    project_id,
    experiment_date,
    operator_name,
    instrument
)

SELECT
    TRIM(r.experiment_code),

    p.project_id,

    NULLIF(
        TRIM(r.experiment_date),
        ''
    )::DATE,

    NULLIF(
        TRIM(r.researcher),
        ''
    ),

    NULL

FROM raw.lims_experiment r

CROSS JOIN core.project p

WHERE p.project_name =
    'Synthetic Transcription Study'

ON CONFLICT (experiment_code)

DO UPDATE SET
    experiment_date =
        EXCLUDED.experiment_date,

    operator_name =
        EXCLUDED.operator_name;


-- ============================================================
-- 5. PERTURBATION
-- ============================================================

INSERT INTO core.perturbation (
    perturbation_name,
    perturbation_type
)

SELECT DISTINCT
    TRIM(perturbation),

    CASE
        WHEN LOWER(TRIM(perturbation)) = 'control'
            THEN 'control'

        ELSE 'chemical'
    END

FROM raw.lims_experiment

WHERE perturbation IS NOT NULL
  AND TRIM(perturbation) <> ''

ON CONFLICT (perturbation_name)

DO UPDATE SET
    perturbation_type =
        EXCLUDED.perturbation_type;


-- ============================================================
-- 6. EXPERIMENT ↔ PERTURBATION
--
-- Canonical unit = uM
-- ============================================================

INSERT INTO core.experiment_perturbation (
    experiment_id,
    perturbation_id,
    dose_value,
    dose_unit,
    duration_hours
)

SELECT
    e.experiment_id,

    p.perturbation_id,

    CASE LOWER(TRIM(r.dose_unit))

        WHEN 'nm'
            THEN TRIM(r.dose)::DOUBLE PRECISION / 1000.0

        WHEN 'um'
            THEN TRIM(r.dose)::DOUBLE PRECISION

        WHEN 'µm'
            THEN TRIM(r.dose)::DOUBLE PRECISION

        WHEN 'μm'
            THEN TRIM(r.dose)::DOUBLE PRECISION

        WHEN 'mm'
            THEN TRIM(r.dose)::DOUBLE PRECISION * 1000.0

        ELSE NULL

    END AS dose_value,

    'uM' AS dose_unit,

    NULL AS duration_hours

FROM raw.lims_experiment r

JOIN core.experiment e
    ON e.experiment_code =
       TRIM(r.experiment_code)

JOIN core.perturbation p
    ON p.perturbation_name =
       TRIM(r.perturbation)

ON CONFLICT (
    experiment_id,
    perturbation_id
)

DO UPDATE SET
    dose_value =
        EXCLUDED.dose_value,

    dose_unit =
        EXCLUDED.dose_unit;


-- ============================================================
-- 7. CELL
-- ============================================================

INSERT INTO core.cell (
    experiment_id,
    source_cell_id,
    field_of_view
)

SELECT DISTINCT
    e.experiment_id,

    TRIM(r.cell_id),

    NULL::INTEGER

FROM raw.instrument_measurement r

JOIN core.experiment e
    ON e.experiment_code =
       TRIM(r.experiment_code)

ON CONFLICT (
    experiment_id,
    source_cell_id
)

DO NOTHING;


-- ============================================================
-- 8. MEASUREMENT
-- ============================================================

INSERT INTO core.measurement (
    cell_id,
    time_seconds,
    signal_intensity
)

SELECT
    c.cell_id,

    TRIM(r.time_seconds)::DOUBLE PRECISION,

    TRIM(r.intensity)::DOUBLE PRECISION

FROM raw.instrument_measurement r

JOIN core.experiment e
    ON e.experiment_code =
       TRIM(r.experiment_code)

JOIN core.cell c
    ON c.experiment_id =
       e.experiment_id

   AND c.source_cell_id =
       TRIM(r.cell_id)

ON CONFLICT (
    cell_id,
    time_seconds
)

DO UPDATE SET
    signal_intensity =
        EXCLUDED.signal_intensity;


COMMIT;