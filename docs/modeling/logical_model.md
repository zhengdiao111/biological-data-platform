PROJECT
--------------------
project_id PK
project_name


PROMOTER
--------------------
promoter_id PK
promoter_name
sequence


CONSTRUCT
--------------------
construct_id PK
construct_code
promoter_id FK
activation_domain
binding_site_count


EXPERIMENT
--------------------
experiment_id PK
experiment_code
project_id FK
experiment_date
operator
instrument


PERTURBATION
--------------------
perturbation_id PK
perturbation_name
perturbation_type


EXPERIMENT_PERTURBATION
--------------------
experiment_id FK
perturbation_id FK
dose_value
dose_unit
duration_hours


CELL
--------------------
cell_id PK
experiment_id FK
source_cell_id
field_of_view


MEASUREMENT
--------------------
measurement_id PK
cell_id FK
time_seconds
signal_intensity