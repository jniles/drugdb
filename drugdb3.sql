CREATE TABLE centers (
 Location VARCHAR(50) NOT NULL PRIMARY KEY,
 email_list BLOB
 );

CREATE TABLE drugs (
 Dname VARCHAR(50) NOT NULL PRIMARY KEY
 );

CREATE TABLE  drugs_per_locs (
 Ctr_loc VARCHAR(50) NOT NULL,
 Dname VARCHAR(50) NOT NULL,
 Par_lvl INT  DEFAULT 30,
 Flag CHAR(5)  DEFAULT FALSE,
 Count INT  DEFAULT NULL,
 PRIMARY KEY (Ctr_loc, Dname),
 FOREIGN KEY (Ctr_loc) REFERENCES centers (Location)
 ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (Dname) REFERENCES drugs (Dname)
 ON DELETE CASCADE ON UPDATE CASCADE)
;

CREATE TABLE data_points (
 Ctr_loc VARCHAR(50) NOT NULL,
 Dname VARCHAR(50) NOT NULL,
 Time_stamp TIMESTAMP NOT NULL,
 Count INT  DEFAULT NULL,
 PRIMARY KEY(Ctr_loc, Dname, Time_stamp),
 FOREIGN KEY (Ctr_loc) REFERENCES centers (Location)
 ON DELETE CASCADE ON UPDATE CASCADE,
 FOREIGN KEY (Dname) REFERENCES drugs (Dname)
 ON DELETE CASCADE ON UPDATE CASCADE)
;

CREATE TABLE alt_names (
 Dname VARCHAR(50) NOT NULL,
 Other_name VARCHAR(50) NOT NULl,
 PRIMARY KEY(Dname, Other_name),
 FOREIGN KEY (Dname) REFERENCES drugs (Dname)
 ON DELETE CASCADE ON UPDATE CASCADE)
;

CREATE TABLE updates (
 Ctr_loc  VARCHAR(50) NOT NULL,
 U_date  TIMESTAMP NOT NULL,
 Spreadsheet VARCHAR(20) NOT NULL,
 PRIMARY KEY(Ctr_loc, U_date, Spreadsheet),
 FOREIGN KEY (Ctr_loc) REFERENCES centers (Location)
 ON DELETE CASCADE ON UPDATE CASCADE)
;

CREATE TABLE typos (
 Wrong_name VARCHAR(60) NOT NULL,
 Ctr_loc  VARCHAR(50) NOT NULL,
 Change  INT,
 PRIMARY KEY(Ctr_loc, Wrong_name),
 FOREIGN KEY (Ctr_loc) REFERENCES centers (Location)
 ON DELETE CASCADE ON UPDATE CASCADE)
;

INSERT INTO drugs (Dname) VALUES ('Chateal');

INSERT INTO drugs (Dname) VALUES ('Cyclen');

INSERT INTO drugs (Dname) VALUES ('Cyclessa');

INSERT INTO drugs (Dname) VALUES ('Desogen');

INSERT INTO drugs (Dname) VALUES ('Microgestin');

INSERT INTO drugs (Dname) VALUES ('Micronor');

INSERT INTO drugs (Dname) VALUES ('Ortho Evra Patch');

INSERT INTO drugs (Dname) VALUES ('Tricyclen');

INSERT INTO alt_names (Dname, Other_name) VALUES ('Chateal', 'Totals For CHATEAL (17)');

INSERT INTO alt_names (Dname, Other_name) VALUES ('Cyclen', 'Totals For CYCLEN (8)');

INSERT INTO alt_names (Dname, Other_name) VALUES ('Cyclessa','Totals For CYCLESSA (9)');

INSERT INTO alt_names (Dname, Other_name) VALUES ('Desogen', 'Totals For DESOGEN (20)');

INSERT INTO alt_names (Dname, Other_name) VALUES ('Microgestin', 'Totals For MICROGESTIN 1.5/30 (17)');

INSERT INTO alt_names (Dname, Other_name) VALUES ('Microgestin', 'Totals For MICROGESTIN 1/20 (27)');

INSERT INTO alt_names (Dname, Other_name) VALUES ('Micronor','Totals For MICRONOR (18)');

INSERT INTO alt_names (Dname, Other_name) VALUES ('Ortho Evra Patch', 'Totals For ORTHO EVRA PATCH (8)');

INSERT INTO alt_names (Dname, Other_name) VALUES ('Tricyclen', 'Totals For TRICYCLEN (13)');

INSERT INTO alt_names (Dname, Other_name) VALUES ('Tricyclen','Totals For TRICYCLEN LO (20)');

INSERT INTO centers (Location) VALUES ('Sarasota');

INSERT INTO drugs (Dname) VALUES ('Asprin');

INSERT INTO drugs_per_locs (Ctr_loc, Dname) VALUES ('Sarasota', 'Asprin');

INSERT INTO data_points (Ctr_loc, Dname, Time_stamp, Count) VALUES ('Sarasota', 'Asprin', '2014-02-25 03:14:07', 1);

INSERT INTO data_points (Ctr_loc, Dname, Time_stamp, Count) VALUES ('Sarasota', 'Asprin', '2014-01-25 03:14:07', 2);

INSERT INTO data_points (Ctr_loc, Dname, Time_stamp, Count) VALUES ('Sarasota', 'Asprin', '2013-12-25 03:14:07', 3);
