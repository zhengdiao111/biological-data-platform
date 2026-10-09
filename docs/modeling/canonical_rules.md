# Canonical Data Rules

## Identifiers

Experiment identifiers use the LIMS experiment code.

Example:

EXP-001

Construct identifiers use the construct registry code.

Example:

C001


## Dates

Raw source dates are stored as text.

CORE experiment dates use PostgreSQL DATE.


## Perturbation Dose

All perturbation doses are standardized to micromolar (uM).

Examples:

100 nM → 0.1 uM

0.1 uM → 0.1 uM

5 uM → 5 uM


## Measurements

Time is represented in seconds.

Signal intensity is represented as a numeric value.


## Cell Identity

Cell identifiers are unique only within an experiment.

Therefore the canonical identity is:

experiment_id + source_cell_id


## Measurement Grain

One CORE measurement represents:

one cell
at one time point.