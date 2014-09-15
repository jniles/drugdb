-- schema.sql

-- This file is meant to construct an SQLite3 database

-- Naive schema designed to get data processing
-- up and running quickly.  Prone to evolution.

CREATE TABLE drug (
  cpt_code      INTEGER PRIMARY KEY,
  name          TEXT NOT NULL,
  bar_code      INTEGER NOT NULL
);

CREATE TABLE manager (
  id              INTEGER PRIMARY KEY,
  name            TEXT NOT NULL,
  email           TEXT NOT NULL
);

CREATE TABLE health_center (
  id              INTEGER PRIMARY KEY,
  name            TEXT NOT NULL,
  manager_id      INTEGER NOT NULL,
  FOREIGN KEY(manager_id) REFERENCES manager(id)
);

CREATE TABLE purchase (
  id                  INTEGER PRIMARY KEY,
  health_center_id    TEXT NOT NULL,
  drug_name           TEXT NOT NULL,
  cpt_code            INTEGER NOT NULL,
  count               INTEGER NOT NULL,
  date                TEXT NOT NULL,
  FOREIGN KEY(cpt_code) REFERENCES drug(cpt_code),
  FOREIGN KEY(health_center_id) REFERENCES health_center(id)
);

CREATE TABLE sale (
  id                  INTEGER PRIMARY KEY,
  health_center_id    TEXT NOT NULL,
  drug_name           TEXT NOT NULL,
  cpt_code            INTEGER NOT NULL,
  count               INTEGER NOT NULL,
  date                TEXT NOT NULL,
  FOREIGN KEY(cpt_code) REFERENCES drug(cpt_code),
  FOREIGN KEY(health_center_id) REFERENCES health_center(id)
);

CREATE TABLE stock (
  id                  INTEGER PRIMARY KEY,
  health_center_id    TEXT NOT NULL,
  drug_name           TEXT NOT NULL,
  cpt_code            INTEGER NOT NULL,
  count               INTEGER NOT NULL,
  date                TEXT NOT NULL,
  FOREIGN KEY(cpt_code) REFERENCES drug(cpt_code),
  FOREIGN KEY(health_center_id) REFERENCES health_center(id)
);
