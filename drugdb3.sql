DROP DATABASE drugsdb;
CREATE DATABASE drugsdb;
USE drugsdb;


CREATE TABLE centers (
	Location		VARCHAR(50)		NOT NULL PRIMARY KEY,
	email_list		BLOB)
DEFAULT CHARACTER SET utf8;

CREATE TABLE drugs (
	Dname		VARCHAR(50)		NOT NULL PRIMARY KEY)
DEFAULT CHARACTER SET utf8;

CREATE TABLE  drugs_per_locs (
	Ctr_loc		VARCHAR(50)		NOT NULL,
	Dname		VARCHAR(50)		NOT NULL,
	Par_lvl		INT				DEFAULT 30,
	Flag		CHAR(5)			DEFAULT FALSE,
	Count		INT				DEFAULT NULL,
	PRIMARY KEY (Ctr_loc, Dname),
	FOREIGN KEY (Ctr_loc) REFERENCES centers (Location)
		ON DELETE CASCADE	ON UPDATE CASCADE,
	FOREIGN KEY (Dname) REFERENCES drugs (Dname)
		ON DELETE CASCADE	ON UPDATE CASCADE)
DEFAULT CHARACTER SET utf8;

CREATE TABLE date_counts (
	Ctr_loc		VARCHAR(50)		NOT NULL,
	Dname		VARCHAR(50)		NOT NULL,
	Time_stamp	TIMESTAMP		NOT NULL,
	Count		INT				DEFAULT NULL,
	PRIMARY KEY(Ctr_loc, Dname, Time_stamp),
	FOREIGN KEY (Ctr_loc) REFERENCES centers (Location)
		ON DELETE CASCADE	ON UPDATE CASCADE,
	FOREIGN KEY (Dname) REFERENCES drugs (Dname)
		ON DELETE CASCADE	ON UPDATE CASCADE)
DEFAULT CHARACTER SET utf8;

CREATE TABLE alt_names (
	Dname		VARCHAR(50)		NOT NULL,
	Other_name	VARCHAR(50)		NOT NULl,
	PRIMARY KEY(Dname, Other_name),
	FOREIGN KEY (Dname) REFERENCES drugs (Dname)
		ON DELETE CASCADE	ON UPDATE CASCADE)
DEFAULT CHARACTER SET utf8;

CREATE TABLE updates (
	Ctr_loc			VARCHAR(50)		NOT NULL,
	U_date			TIMESTAMP		NOT NULL,
	Spreadsheet		VARCHAR(20)		NOT NULL,
	PRIMARY KEY(Ctr_loc, U_date, Spreadsheet),
	FOREIGN KEY (Ctr_loc) REFERENCES centers (Location)
		ON DELETE CASCADE	ON UPDATE CASCADE)
DEFAULT CHARACTER SET utf8;

CREATE TABLE typos (
	Wrong_name		VARCHAR(60)		NOT NULL,
	Ctr_loc			VARCHAR(50)		NOT NULL,
	Change			INT,
	PRIMARY KEY(Ctr_loc, Wrong_name),
	FOREIGN KEY (Ctr_loc) REFERENCES centers (Location)
		ON DELETE CASCADE	ON UPDATE CASCADE)
DEFAULT CHARACTER SET utf8;

INSERT INTO drugs SET 
	Dname = 'Chateal';

INSERT INTO drugs SET 
	Dname = 'Cyclen';

INSERT INTO drugs SET 
	Dname = 'Cyclessa';

INSERT INTO drugs SET 
	Dname = 'Desogen';

INSERT INTO drugs SET 
	Dname = 'Microgestin';

INSERT INTO drugs SET 
	Dname = 'Micronor';

INSERT INTO drugs SET 
	Dname = 'Ortho Evra Patch';

INSERT INTO drugs SET 
	Dname = 'Tricyclen';

INSERT INTO alt_names SET
	Dname = 'Chateal',
	Other_name = 'Totals For CHATEAL (17)';

INSERT INTO alt_names SET
	Dname = 'Cyclen',
	Other_name = 'Totals For CYCLEN (8)';
	
INSERT INTO alt_names SET
	Dname = 'Cyclessa',
	Other_name = 'Totals For CYCLESSA (9)';
	
INSERT INTO alt_names SET
	Dname = 'Desogen',
	Other_name = 'Totals For DESOGEN (20)';
	
INSERT INTO alt_names SET
	Dname = 'Microgestin',
	Other_name = 'Totals For MICROGESTIN 1.5/30 (17)';
		
INSERT INTO alt_names SET
	Dname = 'Microgestin',
	Other_name = 'Totals For MICROGESTIN 1/20 (27)';
	
INSERT INTO alt_names SET
	Dname = 'Micronor',
	Other_name = 'Totals For MICRONOR (18)';
	
INSERT INTO alt_names SET
	Dname = 'Ortho Evra Patch',
	Other_name = 'Totals For ORTHO EVRA PATCH (8)';
	
INSERT INTO alt_names SET
	Dname = 'Tricyclen',
	Other_name = 'Totals For TRICYCLEN (13)';
	
INSERT INTO alt_names SET
	Dname = 'Tricyclen',
	Other_name = 'Totals For TRICYCLEN LO (20)';

INSERT INTO centers SET
	Location = 'Sarasota';

INSERT INTO drugs SET 
	Dname = 'Asprin';

INSERT INTO drugs_per_locs SET
	Ctr_loc = 'Sarasota',
	Dname = 'Asprin';

INSERT INTO date_counts SET
	Ctr_loc = 'Sarasota',
	Dname = 'Asprin',
	Time_stamp = '2014-02-25 03:14:07',
	Count = 1;
	
INSERT INTO date_counts SET
	Ctr_loc = 'Sarasota',
	Dname = 'Asprin',
	Time_stamp = '2014-01-25 03:14:07',
	Count = 2;

INSERT INTO date_counts SET
	Ctr_loc = 'Sarasota',
	Dname = 'Asprin',
	Time_stamp = '2013-12-25 03:14:07',
	Count = 3;

