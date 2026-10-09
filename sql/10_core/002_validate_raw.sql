-- ============================================================
-- RAW DATA VALIDATION
-- ============================================================


-- ------------------------------------------------------------
-- 1. Row counts
-- ------------------------------------------------------------

SELECT
    'lims_experiment' AS source_table,
    COUNT(*) AS row_count
FROM raw.lims_experiment

UNION ALL

SELECT
    'construct_registry',
    COUNT(*)
FROM raw.construct_registry

UNION ALL

SELECT
    'instrument_measurement',
    COUNT(*)
FROM raw.instrument_measurement;


-- ------------------------------------------------------------
-- 2. Missing required identifiers
-- ------------------------------------------------------------

SELECT *
FROM raw.lims_experiment
WHERE experiment_code IS NULL
   OR TRIM(experiment_code) = '';


SELECT *
FROM raw.construct_registry
WHERE construct_code IS NULL
   OR TRIM(construct_code) = '';


SELECT *
FROM raw.instrument_measurement
WHERE experiment_code IS NULL
   OR TRIM(experiment_code) = ''
   OR cell_id IS NULL
   OR TRIM(cell_id) = '';


-- ------------------------------------------------------------
-- 3. Duplicate construct identifiers
-- ------------------------------------------------------------

SELECT
    construct_code,
    COUNT(*) AS duplicate_count
FROM raw.construct_registry
GROUP BY construct_code
HAVING COUNT(*) > 1;


-- ------------------------------------------------------------
-- 4. Duplicate measurements at the intended grain
--
-- Grain:
-- one measurement per experiment + cell + time point
-- ------------------------------------------------------------

SELECT
    experiment_code,
    cell_id,
    time_seconds,
    COUNT(*) AS duplicate_count
FROM raw.instrument_measurement
GROUP BY
    experiment_code,
    cell_id,
    time_seconds
HAVING COUNT(*) > 1;


-- ------------------------------------------------------------
-- 5. LIMS construct codes missing from construct registry
-- ------------------------------------------------------------

SELECT DISTINCT
    l.construct_code
FROM raw.lims_experiment l

LEFT JOIN raw.construct_registry c
    ON TRIM(l.construct_code)
       = TRIM(c.construct_code)

WHERE c.construct_code IS NULL;


-- ------------------------------------------------------------
-- 6. Instrument experiments missing from LIMS
-- ------------------------------------------------------------

SELECT DISTINCT
    m.experiment_code
FROM raw.instrument_measurement m

LEFT JOIN raw.lims_experiment l
    ON TRIM(m.experiment_code)
       = TRIM(l.experiment_code)

WHERE l.experiment_code IS NULL;