-- data.sql

-- This file is meant to populate an SQLite3 database

-- Some initial data to populate schema.sql.

INSERT INTO manager VALUES
  (null, 'Karen Smith', 'karen.smith@example.com'),
  (null, 'Jack Johnson', 'jack@example.org'),
  (null, 'Phillip Waverly', 'waverly@example.net');


INSERT INTO health_center VALUES
  (null, 'SRQ', 1),
  (null, 'TPA', 2),
  (null, 'FTM', 1);


INSERT INTO drug VALUES
  (1, 'Mifeprex', 100),
  (2, 'Plan B', 100),
  (3, 'Chateal', 100),
  (4, 'DMPA', 100),
  (5, 'Nuvaring', 100),
  (6, 'Azithromycin', 100);
