DROP DATABASE drugdb;
CREATE DATABASE drugdb;
USE drugdb;


CREATE TABLE CENTER (
	Location		VARCHAR(50)		NOT NULL PRIMARY KEY,
	email_list		BLOB)
DEFAULT CHARACTER SET utf8;

CREATE TABLE DRUG (
	Dname		VARCHAR(50)		NOT NULL PRIMARY KEY)
DEFAULT CHARACTER SET utf8;

CREATE TABLE  DRUG_PER_LOC (
	Ctr_loc		VARCHAR(50)		NOT NULL,
	Dname		VARCHAR(50)		NOT NULL,
	Par_lvl		INT				DEFAULT 30,
	Flag		CHAR(5)			DEFAULT FALSE,
	Count		INT				DEFAULT NULL,
	PRIMARY KEY (Ctr_loc, Dname),
	FOREIGN KEY (Ctr_loc) REFERENCES CENTER (Location)
		ON DELETE CASCADE	ON UPDATE CASCADE,
	FOREIGN KEY (Dname) REFERENCES DRUG (Dname)
		ON DELETE CASCADE	ON UPDATE CASCADE)
DEFAULT CHARACTER SET utf8;

CREATE TABLE DATE_COUNT (
	Ctr_loc		VARCHAR(50)		NOT NULL,
	Dname		VARCHAR(50)		NOT NULL,
	Time_stamp	TIMESTAMP		NOT NULL,
	Count		INT				DEFAULT NULL,
	PRIMARY KEY(Ctr_loc, Dname, Time_stamp),
	FOREIGN KEY (Ctr_loc) REFERENCES CENTER (Location)
		ON DELETE CASCADE	ON UPDATE CASCADE,
	FOREIGN KEY (Dname) REFERENCES DRUG (Dname)
		ON DELETE CASCADE	ON UPDATE CASCADE)
DEFAULT CHARACTER SET utf8;

CREATE TABLE ALT_NAME (
	Dname		VARCHAR(50)		NOT NULL,
	Other_name	VARCHAR(50)		NOT NULl,
	PRIMARY KEY(Dname, Other_name),
	FOREIGN KEY (Dname) REFERENCES DRUG (Dname)
		ON DELETE CASCADE	ON UPDATE CASCADE)
DEFAULT CHARACTER SET utf8;

INSERT INTO DRUG SET 
	Dname = 'Chateal';

INSERT INTO DRUG SET 
	Dname = 'Cyclen';

INSERT INTO DRUG SET 
	Dname = 'Cyclessa';

INSERT INTO DRUG SET 
	Dname = 'Desogen';

INSERT INTO DRUG SET 
	Dname = 'Microgestin';

INSERT INTO DRUG SET 
	Dname = 'Micronor';

INSERT INTO DRUG SET 
	Dname = 'Ortho Evra Patch';

INSERT INTO DRUG SET 
	Dname = 'Tricyclen';

INSERT INTO ALT_NAME SET
	Dname = 'Chateal',
	Other_name = 'Totals For CHATEAL (17)';

INSERT INTO ALT_NAME SET
	Dname = 'Cyclen',
	Other_name = 'Totals For CYCLEN (8)';
	
INSERT INTO ALT_NAME SET
	Dname = 'Cyclessa',
	Other_name = 'Totals For CYCLESSA (9)';
	
INSERT INTO ALT_NAME SET
	Dname = 'Desogen',
	Other_name = 'Totals For DESOGEN (20)';
	
INSERT INTO ALT_NAME SET
	Dname = 'Microgestin',
	Other_name = 'Totals For MICROGESTIN 1.5/30 (17)';
		
INSERT INTO ALT_NAME SET
	Dname = 'Microgestin',
	Other_name = 'Totals For MICROGESTIN 1/20 (27)';
	
INSERT INTO ALT_NAME SET
	Dname = 'Micronor',
	Other_name = 'Totals For MICRONOR (18)';
	
INSERT INTO ALT_NAME SET
	Dname = 'Ortho Evra Patch',
	Other_name = 'Totals For ORTHO EVRA PATCH (8)';
	
INSERT INTO ALT_NAME SET
	Dname = 'Tricyclen',
	Other_name = 'Totals For TRICYCLEN (13)';
	
INSERT INTO ALT_NAME SET
	Dname = 'Tricyclen',
	Other_name = 'Totals For TRICYCLEN LO (20)';

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

