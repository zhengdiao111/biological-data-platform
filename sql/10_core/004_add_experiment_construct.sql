ALTER TABLE core.experiment

ADD COLUMN construct_id BIGINT;


ALTER TABLE core.experiment

ADD CONSTRAINT fk_experiment_construct

FOREIGN KEY (construct_id)

REFERENCES core.construct(construct_id);