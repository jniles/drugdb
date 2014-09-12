-- Latest Drug Database (09/11/14) from Calvin

DROP DATABASE drugdb;
CREATE DATABASE drugdb;
USE drugdb;

CREATE TABLE CENTER (
  Location      VARCHAR(50)   NOT NULL PRIMARY KEY,
  email_list    BLOB)
DEFAULT CHARACTER SET utf8;

CREATE TABLE DRUG (
  Dname   VARCHAR(50)   NOT NULL PRIMARY KEY)
DEFAULT CHARACTER SET utf8;

CREATE TABLE DRUG_PER_LOC (
  Ctr_loc   VARCHAR(50)   NOT NULL,
  Dname   VARCHAR(50)   NOT NULL,
  Par_lvl   INT       DEFAULT 30,
  Flag    CHAR(5)     DEFAULT FALSE,
  PRIMARY KEY (Ctr_loc, Dname),
  FOREIGN KEY (Ctr_loc) REFERENCES CENTER (Location)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Dname) REFERENCES DRUG (Dname)
    ON DELETE CASCADE ON UPDATE CASCADE)
DEFAULT CHARACTER SET utf8;

CREATE TABLE DATE_COUNT (
  Ctr_loc VARCHAR(50)     NOT NULL,
  Dname   VARCHAR(50)   NOT NULL,
  Time_stamp  TIMESTAMP   NOT NULL,
  Count   CHAR(32)    DEFAULT NULL,
  PRIMARY KEY(Ctr_loc, Dname, Time_stamp),
  FOREIGN KEY (Ctr_loc) REFERENCES CENTER (Location)
    ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Dname) REFERENCES DRUG (Dname)
    ON DELETE CASCADE ON UPDATE CASCADE)
DEFAULT CHARACTER SET utf8;

INSERT INTO CENTER SET
  Location = 'Sarasota';

INSERT INTO DRUG SET 
  Dname = 'Asprin';

INSERT INTO DRUG_PER_LOC SET
  Ctr_loc = 'Sarasota',
  Dname = 'Asprin';

INSERT INTO DATE_COUNT SET
  Ctr_loc = 'Sarasota',
  Dname = 'Asprin',
  Time_stamp = '2014-02-25 03:14:07',
  Count = 1;
  
INSERT INTO DATE_COUNT SET
  Ctr_loc = 'Sarasota',
  Dname = 'Asprin',
  Time_stamp = '2014-01-25 03:14:07',
  Count = 2;

INSERT INTO DATE_COUNT SET
  Ctr_loc = 'Sarasota',
  Dname = 'Asprin',
  Time_stamp = '2013-12-25 03:14:07',
  Count = 3;
