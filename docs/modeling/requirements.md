# Research Data Platform Requirements

## Business / Scientific Problem

A research organization performs experiments involving
biological constructs, perturbations, cells, imaging instruments,
and quantitative measurements.

Data currently originates from multiple systems and uses
inconsistent identifiers and representations.

The goal is to create a reusable scientific data platform that:

1. preserves source provenance;
2. provides consistent scientific entities;
3. supports historical tracking;
4. produces analytics-ready data products;
5. supports downstream machine learning and AI.

## Source Systems

### LIMS

Contains:
- experiment identifiers
- researcher
- experiment date
- treatment information
- sample identifiers

### Construct Registry

Contains:
- construct identifiers
- promoter
- activation domain
- binding-site count
- sequence metadata

### Imaging Instrument

Contains:
- acquisition run
- cell identifier
- time point
- signal intensity
- instrument metadata

## Core Scientific Entities

- Experiment
- Construct
- Promoter
- Perturbation
- Cell
- Measurement

## Analytical Questions

1. Which constructs produce the strongest responses?
2. How do perturbations affect cellular behavior?
3. How does response change over time?
4. Can every result be traced to its original source?
5. Which experiments generated a particular analytical result?

## Grain

Experiment:
One row represents one experimental execution.

Cell:
One row represents one tracked biological cell within
one experiment.

Measurement:
One row represents one quantitative observation for
one cell at one time point.