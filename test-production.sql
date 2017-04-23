-- Create tables specified in E/R diagram
CREATE TABLE Tent
(id INTEGER PRIMARY KEY NOT NULL,
 name VARCHAR(30) NOT NULL,
 color varchar(5) NOT NULL);

-- Use NULLS approach for ISA relationship

CREATE TABLE Member
(id INTEGER PRIMARY KEY NOT NULL,
 name VARCHAR(30) NOT NULL,
 hours_Logged REAL NOT NULL,
 games_Attended INTEGER NOT NULL,
 permissions BOOLEAN);

CREATE TABLE Member_In_Tent
(tentID INTEGER NOT NULL REFERENCES Tent(id),
 memberID INTEGER NOT NULL REFERENCES Member(id),
 PRIMARY KEY (tentID, memberID));

CREATE TABLE Availability
(memberID INTEGER NOT NULL REFERENCES Member(id),
 startTime VARCHAR(30) NOT NULL,
 endTime VARCHAR(30) NOT NULL,
 shift BOOLEAN,
 PRIMARY KEY (memberID, startTime, endTime));

CREATE TABLE AttendanceGames
(name VARCHAR(30) NOT NULL PRIMARY KEY,
 date VARCHAR(30) NOT NULL,
 time VARCHAR(30) NOT NULL);

CREATE TABLE Member_Attends_Games
(memberID INTEGER NOT NULL REFERENCES Member(id),
gameName VARCHAR(30) NOT NULL REFERENCES AttendanceGames(name),
PRIMARY KEY (memberID, gameName));

-- DYNAMIC QUERIES

-- Trigger that updates tables if Member is deleted
CREATE FUNCTION TF_delete_Member_ref() RETURNS TRIGGER AS $$
 BEGIN
 	DELETE FROM Member_In_Tent WHERE OLD.id = memberID;
 	DELETE FROM Availability WHERE OLD.id = memberID;
 	DELETE FROM Member_Attends_Games WHERE OLD.id = memberID;
 	RETURN OLD;
 END;
 $$ LANGUAGE plpgsql;

CREATE TRIGGER TG_delete_Member
 BEFORE DELETE
 ON Member
 FOR EACH ROW
 EXECUTE PROCEDURE TF_delete_Member_ref();

-- TRIGGERS

-- Trigger for updating Member hours logged after
-- update or insert on Availability

CREATE FUNCTION TF_update_hoursLogged_ref() RETURNS TRIGGER AS
$BODY$
 DECLARE
    startR REAL := substring(NEW.startTime from 12 for 2)::REAL + substring(NEW.startTime from 15 for 2)::REAL/60 + substring(NEW.startTime from 18 for 2)::REAL/3600;
    endR REAL := substring(NEW.endTime from 12 for 2)::REAL + substring(NEW.endTime from 15 for 2)::REAL/60 + substring(NEW.endTime from 18 for 2)::REAL/3600;
    diffR REAL := endR - startR;
 BEGIN
 	IF NEW.shift = 't' THEN
		UPDATE Member
		SET hours_logged = hours_logged + diffR
		WHERE NEW.memberID = id;
	END IF;
	RETURN NEW;
 END;
$BODY$ LANGUAGE plpgsql;

CREATE TRIGGER TG_update_hoursLogged
AFTER UPDATE
ON Availability
FOR EACH ROW
EXECUTE PROCEDURE TF_update_hoursLogged_ref();

-- Trigger for updating number of games attended for each member
-- after update or insert on number of games attended.
CREATE FUNCTION TF_update_gamesAttended_ref() RETURNS TRIGGER AS
$BODY$
 BEGIN
	UPDATE Member
	SET games_attended = games_attended + 1
	WHERE NEW.memberID = id;
	RETURN NEW;
 END;
$BODY$ LANGUAGE plpgsql;

CREATE TRIGGER TG_update_gamesAttended
 AFTER INSERT
 ON Member_Attends_Games
 FOR EACH ROW
 EXECUTE PROCEDURE TF_update_gamesAttended_ref();



-- Begin production dataset
INSERT INTO Tent VALUES (0, 'apple', 'black');
INSERT INTO Tent VALUES (1, 'banana', 'blue');
INSERT INTO Tent VALUES (2, 'carrot', 'white');
INSERT INTO Tent VALUES (3, 'date', 'black');
INSERT INTO Tent VALUES (4, 'eggplant', 'blue');
INSERT INTO Tent VALUES (5, 'fig', 'white');

INSERT INTO Member VALUES (0, 'Anna', 3, 2, 't');
INSERT INTO Member VALUES (1, 'Brad', 0, 1, 'f');
INSERT INTO Member VALUES (2, 'Carl', 9, 3, 'f');
INSERT INTO Member VALUES (3, 'Diana', 4, 1, 't');
INSERT INTO Member VALUES (4, 'Eric', 6, 6, 'f');
INSERT INTO Member VALUES (5, 'Frank', 7, 2, 'f');
INSERT INTO Member VALUES (6, 'George', 8, 3, 'f');
INSERT INTO Member VALUES (7, 'Harry', 2, 3, 'f');
INSERT INTO Member VALUES (8, 'Issac', 3, 6, 'f');
INSERT INTO Member VALUES (9, 'James', 1, 1, 't');
INSERT INTO Member VALUES (10, 'Kevin', 7, 2, 'f');
INSERT INTO Member VALUES (11, 'Lucy', 10, 5, 'f');
INSERT INTO Member VALUES (12, 'Mary', 9, 2, 'f');
INSERT INTO Member VALUES (13, 'Nick', 7, 6, 'f');
INSERT INTO Member VALUES (14, 'Oliver', 8, 7, 't');
INSERT INTO Member VALUES (15, 'Percy', 3, 2, 'f');
INSERT INTO Member VALUES (16, 'Quinn', 7, 0, 'f');
INSERT INTO Member VALUES (17, 'Rachel', 2, 2, 'f');
INSERT INTO Member VALUES (18, 'Steve', 1, 1, 'f');
INSERT INTO Member VALUES (19, 'Tyler', 7, 1, 'f');
INSERT INTO Member VALUES (20, 'Ulysses', 20, 3, 'f');
INSERT INTO Member VALUES (21, 'Vick', 19, 5, 't');
INSERT INTO Member VALUES (22, 'Wallace', 5, 5, 'f');
INSERT INTO Member VALUES (23, 'Xavier', 7, 3, 'f');
INSERT INTO Member VALUES (24, 'Yvette', 3, 0, 'f');
INSERT INTO Member VALUES (25, 'Zoe', 15, 1, 'f');
INSERT INTO Member VALUES (26, 'Test Delete', 0, 0, 'f');

INSERT INTO Member_In_Tent VALUES (0, 0);
INSERT INTO Member_In_Tent VALUES (0, 1);
INSERT INTO Member_In_Tent VALUES (0, 2);
INSERT INTO Member_In_Tent VALUES (1, 3);
INSERT INTO Member_In_Tent VALUES (1, 4);
INSERT INTO Member_In_Tent VALUES (1, 5);
INSERT INTO Member_In_Tent VALUES (1, 6);
INSERT INTO Member_In_Tent VALUES (1, 7);
INSERT INTO Member_In_Tent VALUES (1, 8);
INSERT INTO Member_In_Tent VALUES (2, 9);
INSERT INTO Member_In_Tent VALUES (2, 10);
INSERT INTO Member_In_Tent VALUES (2, 11);
INSERT INTO Member_In_Tent VALUES (2, 12);
INSERT INTO Member_In_Tent VALUES (2, 13);
INSERT INTO Member_In_Tent VALUES (3, 14);
INSERT INTO Member_In_Tent VALUES (3, 15);
INSERT INTO Member_In_Tent VALUES (3, 16);
INSERT INTO Member_In_Tent VALUES (3, 17);
INSERT INTO Member_In_Tent VALUES (3, 18);
INSERT INTO Member_In_Tent VALUES (3, 19);
INSERT INTO Member_In_Tent VALUES (3, 20);
INSERT INTO Member_In_Tent VALUES (4, 21);
INSERT INTO Member_In_Tent VALUES (4, 22);
INSERT INTO Member_In_Tent VALUES (4, 23);
INSERT INTO Member_In_Tent VALUES (5, 24);
INSERT INTO Member_In_Tent VALUES (5, 25);
INSERT INTO Member_In_Tent VALUES (5, 26);

INSERT INTO Availability VALUES (0, '2017-01-16T08:00:00', '2017-01-16T13:00:00', 'f');
INSERT INTO Availability VALUES (0, '2017-01-20T08:00:00', '2017-01-20T13:00:00', 'f');
INSERT INTO Availability VALUES (0, '2017-01-22T11:00:00', '2017-01-22T19:00:00', 'f');
INSERT INTO Availability VALUES (0, '2017-01-23T10:00:00', '2017-01-23T14:30:00', 'f');
INSERT INTO Availability VALUES (0, '2017-01-30T08:00:00', '2017-01-30T13:00:00', 'f');
INSERT INTO Availability VALUES (0, '2017-02-01T08:00:00', '2017-02-01T16:00:00', 'f');
INSERT INTO Availability VALUES (0, '2017-02-04T15:00:00', '2017-02-04T20:00:00', 'f');
INSERT INTO Availability VALUES (0, '2017-02-06T08:00:00', '2017-02-06T13:00:00', 'f');
INSERT INTO Availability VALUES (0, '2017-02-08T18:00:00', '2017-02-08T23:00:00', 'f');
INSERT INTO Availability VALUES (1, '2017-01-14T09:00:00', '2017-01-14T12:00:00', 'f');
INSERT INTO Availability VALUES (1, '2017-01-15T19:00:00', '2017-01-15T23:30:00', 'f');
INSERT INTO Availability VALUES (1, '2017-01-17T14:00:00', '2017-01-17T22:00:00', 'f');
INSERT INTO Availability VALUES (1, '2017-01-19T16:00:00', '2017-01-19T23:30:00', 'f');
INSERT INTO Availability VALUES (1, '2017-01-22T09:00:00', '2017-01-22T12:00:00', 'f');
-- For example, above would be: (1, '2017-01-22T09:00:00', '2017-01-22T12:00:00', 'f');
INSERT INTO Availability VALUES (1, '2017-01-24T20:00:00', '2017-01-24T23:59:00', 'f');
INSERT INTO Availability VALUES (1, '2017-01-30T09:00:00', '2017-01-30T12:00:00', 'f');
INSERT INTO Availability VALUES (1, '2017-02-07T09:00:00', '2017-02-07T19:00:00', 'f');
INSERT INTO Availability VALUES (2, '2017-01-15T11:00:00', '2017-01-15T19:00:00', 'f');
INSERT INTO Availability VALUES (2, '2017-01-17T11:00:00', '2017-01-17T16:00:00', 'f');
INSERT INTO Availability VALUES (2, '2017-01-20T10:00:00', '2017-01-20T19:00:00', 'f');
INSERT INTO Availability VALUES (2, '2017-01-23T09:00:00', '2017-01-23T19:00:00', 'f');
INSERT INTO Availability VALUES (2, '2017-01-24T11:00:00', '2017-01-24T15:00:00', 'f');
INSERT INTO Availability VALUES (2, '2017-01-26T11:00:00', '2017-01-26T23:00:00', 'f');
INSERT INTO Availability VALUES (2, '2017-01-31T10:00:00', '2017-01-31T19:00:00', 'f');
INSERT INTO Availability VALUES (2, '2017-02-07T11:00:00', '2017-02-07T19:00:00', 'f');
INSERT INTO Availability VALUES (3, '2017-01-24T12:00:00', '2017-01-24T19:00:00', 'f');
INSERT INTO Availability VALUES (3, '2017-01-26T12:00:00', '2017-01-26T16:00:00', 'f');
INSERT INTO Availability VALUES (3, '2017-01-28T11:00:00', '2017-01-28T19:00:00', 'f');
INSERT INTO Availability VALUES (3, '2017-01-29T10:00:00', '2017-01-29T23:00:00', 'f');
INSERT INTO Availability VALUES (3, '2017-02-01T12:00:00', '2017-02-01T19:00:00', 'f');
INSERT INTO Availability VALUES (3, '2017-02-03T12:00:00', '2017-02-03T16:00:00', 'f');
INSERT INTO Availability VALUES (3, '2017-02-04T08:00:00', '2017-02-04T19:00:00', 'f');
INSERT INTO Availability VALUES (3, '2017-02-05T09:00:00', '2017-02-05T19:00:00', 'f');
INSERT INTO Availability VALUES (3, '2017-02-07T12:00:00', '2017-02-07T23:00:00', 'f');
INSERT INTO Availability VALUES (4, '2017-01-29T00:00:00', '2017-01-29T12:00:00', 'f');
INSERT INTO Availability VALUES (4, '2017-01-30T00:00:00', '2017-01-30T12:00:00', 'f');
INSERT INTO Availability VALUES (4, '2017-01-31T00:00:00', '2017-01-31T08:00:00', 'f');
INSERT INTO Availability VALUES (4, '2017-02-01T00:00:00', '2017-02-01T10:00:00', 'f');
INSERT INTO Availability VALUES (4, '2017-02-03T00:00:00', '2017-02-03T12:00:00', 'f');
INSERT INTO Availability VALUES (4, '2017-02-04T00:00:00', '2017-02-04T12:00:00', 'f');
INSERT INTO Availability VALUES (4, '2017-02-06T00:00:00', '2017-02-06T09:00:00', 'f');
INSERT INTO Availability VALUES (5, '2017-01-16T00:00:00', '2017-01-16T09:00:00', 'f');
INSERT INTO Availability VALUES (5, '2017-01-18T00:00:00', '2017-01-18T13:00:00', 'f');
INSERT INTO Availability VALUES (5, '2017-01-20T10:00:00', '2017-01-20T19:00:00', 'f');
INSERT INTO Availability VALUES (5, '2017-01-23T00:00:00', '2017-01-23T10:00:00', 'f');
INSERT INTO Availability VALUES (5, '2017-01-25T00:00:00', '2017-01-25T10:00:00', 'f');
INSERT INTO Availability VALUES (5, '2017-01-28T00:00:00', '2017-01-28T11:00:00', 'f');
INSERT INTO Availability VALUES (5, '2017-01-29T12:00:00', '2017-01-29T17:00:00', 'f');
INSERT INTO Availability VALUES (5, '2017-01-31T00:00:00', '2017-01-31T13:00:00', 'f');
INSERT INTO Availability VALUES (5, '2017-02-02T00:00:00', '2017-02-02T09:00:00', 'f');
INSERT INTO Availability VALUES (5, '2017-02-05T00:00:00', '2017-02-05T09:00:00', 'f');
INSERT INTO Availability VALUES (5, '2017-02-07T00:00:00', '2017-02-07T11:00:00', 'f');
INSERT INTO Availability VALUES (6, '2017-01-16T08:00:00', '2017-01-16T12:00:00', 'f');
INSERT INTO Availability VALUES (6, '2017-01-17T08:00:00', '2017-01-17T16:00:00', 'f');
INSERT INTO Availability VALUES (6, '2017-01-19T08:00:00', '2017-01-19T13:00:00', 'f');
INSERT INTO Availability VALUES (6, '2017-01-21T10:00:00', '2017-01-21T12:00:00', 'f');
INSERT INTO Availability VALUES (6, '2017-01-22T08:00:00', '2017-01-22T12:00:00', 'f');
INSERT INTO Availability VALUES (6, '2017-01-24T12:00:00', '2017-01-24T19:00:00', 'f');
INSERT INTO Availability VALUES (6, '2017-01-26T08:00:00', '2017-01-26T12:00:00', 'f');
INSERT INTO Availability VALUES (6, '2017-01-29T17:00:00', '2017-01-29T18:45:36', 'f');
INSERT INTO Availability VALUES (6, '2017-02-06T10:00:00', '2017-02-06T12:00:00', 'f');
INSERT INTO Availability VALUES (6, '2017-02-07T08:00:00', '2017-02-07T12:00:00', 'f');
INSERT INTO Availability VALUES (7, '2017-01-15T08:00:00', '2017-01-15T12:00:00', 'f');
INSERT INTO Availability VALUES (7, '2017-01-16T10:00:00', '2017-01-16T12:00:00', 'f');
INSERT INTO Availability VALUES (7, '2017-01-20T08:00:00', '2017-01-20T14:00:00', 'f');
INSERT INTO Availability VALUES (7, '2017-01-23T08:00:00', '2017-01-23T12:00:00', 'f');
INSERT INTO Availability VALUES (7, '2017-01-25T08:00:00', '2017-01-25T19:00:00', 'f');
INSERT INTO Availability VALUES (7, '2017-01-28T12:00:00', '2017-01-28T22:00:00', 'f');
INSERT INTO Availability VALUES (7, '2017-01-30T13:00:00', '2017-01-30T21:00:00', 'f');
INSERT INTO Availability VALUES (7, '2017-02-02T08:00:00', '2017-02-02T12:00:00', 'f');
INSERT INTO Availability VALUES (7, '2017-02-03T08:00:00', '2017-02-03T14:00:00', 'f');
INSERT INTO Availability VALUES (7, '2017-02-05T08:00:00', '2017-02-05T12:00:00', 'f');
INSERT INTO Availability VALUES (7, '2017-02-07T08:00:00', '2017-02-07T15:00:00', 'f');
INSERT INTO Availability VALUES (8, '2017-01-16T10:00:00', '2017-01-16T15:00:00', 'f');
INSERT INTO Availability VALUES (8, '2017-01-20T00:00:00', '2017-01-20T22:00:00', 'f');
INSERT INTO Availability VALUES (8, '2017-01-25T10:00:00', '2017-01-25T23:00:00', 'f');
INSERT INTO Availability VALUES (8, '2017-01-27T12:00:00', '2017-01-27T20:00:00', 'f');
INSERT INTO Availability VALUES (8, '2017-01-30T10:00:00', '2017-01-30T19:00:00', 'f');
INSERT INTO Availability VALUES (8, '2017-02-03T00:00:00', '2017-02-03T15:00:00', 'f');
INSERT INTO Availability VALUES (8, '2017-02-04T10:00:00', '2017-02-04T15:00:00', 'f');
INSERT INTO Availability VALUES (8, '2017-02-06T10:00:00', '2017-02-06T18:00:00', 'f');
INSERT INTO Availability VALUES (9, '2017-01-30T10:00:00', '2017-01-30T15:00:00', 'f');
INSERT INTO Availability VALUES (9, '2017-01-31T12:00:00', '2017-01-31T15:00:00', 'f');
INSERT INTO Availability VALUES (9, '2017-02-01T10:00:00', '2017-02-01T11:00:00', 'f');
INSERT INTO Availability VALUES (9, '2017-02-02T10:00:00', '2017-02-02T19:00:00', 'f');
INSERT INTO Availability VALUES (9, '2017-02-03T11:00:00', '2017-02-03T14:00:00', 'f');
INSERT INTO Availability VALUES (9, '2017-02-04T10:00:00', '2017-02-04T15:00:00', 'f');
INSERT INTO Availability VALUES (9, '2017-02-05T12:00:00', '2017-02-05T15:00:00', 'f');
INSERT INTO Availability VALUES (9, '2017-02-06T00:00:00', '2017-02-06T08:00:00', 'f');
INSERT INTO Availability VALUES (9, '2017-02-07T00:00:00', '2017-02-07T10:00:00', 'f');
INSERT INTO Availability VALUES (10, '2017-01-23T12:00:00', '2017-01-23T22:00:00', 'f');
INSERT INTO Availability VALUES (10, '2017-01-24T12:00:00', '2017-01-24T20:00:00', 'f');
INSERT INTO Availability VALUES (10, '2017-01-25T12:00:00', '2017-01-25T19:00:00', 'f');
INSERT INTO Availability VALUES (10, '2017-01-26T12:00:00', '2017-01-26T14:00:00', 'f');
INSERT INTO Availability VALUES (10, '2017-01-27T12:00:00', '2017-01-27T16:00:00', 'f');
INSERT INTO Availability VALUES (10, '2017-01-28T12:00:00', '2017-01-28T20:00:00', 'f');
INSERT INTO Availability VALUES (10, '2017-01-29T12:00:00', '2017-01-29T23:00:00', 'f');
INSERT INTO Availability VALUES (10, '2017-01-30T12:00:00', '2017-01-30T22:00:00', 'f');
INSERT INTO Availability VALUES (10, '2017-01-31T12:00:00', '2017-01-31T20:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-01-15T10:00:00', '2017-01-15T23:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-01-17T12:00:00', '2017-01-17T20:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-01-20T10:00:00', '2017-01-20T19:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-01-23T00:00:00', '2017-01-23T15:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-01-28T10:00:00', '2017-01-28T15:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-01-30T10:00:00', '2017-01-30T18:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-01-31T10:00:00', '2017-01-31T15:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-02-01T10:00:00', '2017-02-01T18:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-02-02T10:00:00', '2017-02-02T15:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-02-04T12:00:00', '2017-02-04T15:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-02-05T10:00:00', '2017-02-05T11:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-02-06T10:00:00', '2017-02-06T19:00:00', 'f');
INSERT INTO Availability VALUES (11, '2017-02-07T11:00:00', '2017-02-07T14:00:00', 'f');
INSERT INTO Availability VALUES (12, '2017-01-16T08:00:00', '2017-01-16T13:00:00', 'f');
INSERT INTO Availability VALUES (12, '2017-01-20T08:00:00', '2017-01-20T13:00:00', 'f');
INSERT INTO Availability VALUES (12, '2017-01-22T11:00:00', '2017-01-22T19:00:00', 'f');
INSERT INTO Availability VALUES (12, '2017-01-23T10:00:00', '2017-01-23T14:30:00', 'f');
INSERT INTO Availability VALUES (12, '2017-01-30T08:00:00', '2017-01-30T13:00:00', 'f');
INSERT INTO Availability VALUES (12, '2017-02-01T08:00:00', '2017-02-01T16:00:00', 'f');
INSERT INTO Availability VALUES (12, '2017-02-04T15:00:00', '2017-02-04T20:00:00', 'f');
INSERT INTO Availability VALUES (12, '2017-02-06T08:00:00', '2017-02-06T13:00:00', 'f');
INSERT INTO Availability VALUES (13, '2017-01-16T00:00:00', '2017-01-16T10:00:00', 'f');
INSERT INTO Availability VALUES (13, '2017-01-18T00:00:00', '2017-01-18T15:00:00', 'f');
INSERT INTO Availability VALUES (13, '2017-01-20T10:00:00', '2017-01-20T17:00:00', 'f');
INSERT INTO Availability VALUES (13, '2017-01-23T00:00:00', '2017-01-23T09:00:00', 'f');
INSERT INTO Availability VALUES (13, '2017-01-25T00:00:00', '2017-01-25T10:00:00', 'f');
INSERT INTO Availability VALUES (13, '2017-01-28T00:00:00', '2017-01-28T16:00:00', 'f');
INSERT INTO Availability VALUES (13, '2017-01-31T00:00:00', '2017-01-31T14:00:00', 'f');
INSERT INTO Availability VALUES (13, '2017-02-02T00:00:00', '2017-02-02T08:00:00', 'f');
INSERT INTO Availability VALUES (13, '2017-02-05T00:00:00', '2017-02-05T12:00:00', 'f');
INSERT INTO Availability VALUES (14, '2017-01-15T12:00:00', '2017-01-15T19:00:00', 'f');
INSERT INTO Availability VALUES (14, '2017-01-16T12:00:00', '2017-01-16T16:00:00', 'f');
INSERT INTO Availability VALUES (14, '2017-01-17T11:00:00', '2017-01-17T19:00:00', 'f');
INSERT INTO Availability VALUES (14, '2017-01-20T10:00:00', '2017-01-20T23:00:00', 'f');
INSERT INTO Availability VALUES (14, '2017-01-21T12:00:00', '2017-01-21T19:00:00', 'f');
INSERT INTO Availability VALUES (14, '2017-01-25T12:00:00', '2017-01-25T16:00:00', 'f');
INSERT INTO Availability VALUES (14, '2017-02-27T08:00:00', '2017-02-27T19:00:00', 'f');
INSERT INTO Availability VALUES (14, '2017-02-04T09:00:00', '2017-02-04T19:00:00', 'f');
INSERT INTO Availability VALUES (14, '2017-02-06T12:00:00', '2017-02-06T23:00:00', 'f');
INSERT INTO Availability VALUES (15, '2017-01-16T05:00:00', '2017-01-16T12:00:00', 'f');
INSERT INTO Availability VALUES (15, '2017-01-17T08:00:00', '2017-01-17T17:00:00', 'f');
INSERT INTO Availability VALUES (15, '2017-01-19T08:00:00', '2017-01-19T12:00:00', 'f');
INSERT INTO Availability VALUES (15, '2017-01-21T00:00:00', '2017-01-21T12:00:00', 'f');
INSERT INTO Availability VALUES (15, '2017-01-22T08:00:00', '2017-01-22T16:00:00', 'f');
INSERT INTO Availability VALUES (15, '2017-01-24T12:00:00', '2017-01-24T23:59:00', 'f');
INSERT INTO Availability VALUES (15, '2017-01-26T08:00:00', '2017-01-26T12:00:00', 'f');
INSERT INTO Availability VALUES (15, '2017-01-29T06:00:00', '2017-01-29T18:00:00', 'f');
INSERT INTO Availability VALUES (15, '2017-02-06T10:00:00', '2017-02-06T22:00:00', 'f');
INSERT INTO Availability VALUES (15, '2017-02-07T08:00:00', '2017-02-07T23:00:00', 'f');
INSERT INTO Availability VALUES (16, '2017-01-16T10:00:00', '2017-01-16T18:00:00', 'f');
INSERT INTO Availability VALUES (16, '2017-01-30T08:00:00', '2017-01-30T15:00:00', 'f');
INSERT INTO Availability VALUES (16, '2017-01-31T12:00:00', '2017-01-31T19:00:00', 'f');
INSERT INTO Availability VALUES (16, '2017-02-01T00:00:00', '2017-02-01T13:50:00', 'f');
INSERT INTO Availability VALUES (16, '2017-02-02T10:00:00', '2017-02-02T23:00:00', 'f');
INSERT INTO Availability VALUES (16, '2017-02-03T11:00:00', '2017-02-03T23:59:00', 'f');
INSERT INTO Availability VALUES (16, '2017-02-04T10:00:00', '2017-02-04T15:00:00', 'f');
INSERT INTO Availability VALUES (16, '2017-02-05T12:00:00', '2017-02-05T19:00:00', 'f');
INSERT INTO Availability VALUES (16, '2017-02-06T00:00:00', '2017-02-06T10:00:00', 'f');
INSERT INTO Availability VALUES (16, '2017-02-07T00:00:00', '2017-02-07T13:00:00', 'f');
INSERT INTO Availability VALUES (17, '2017-01-14T09:00:00', '2017-01-14T12:00:00', 'f');
INSERT INTO Availability VALUES (17, '2017-01-15T19:00:00', '2017-01-15T23:30:00', 'f');
INSERT INTO Availability VALUES (17, '2017-01-17T14:00:00', '2017-01-17T22:00:00', 'f');
INSERT INTO Availability VALUES (17, '2017-01-19T16:00:00', '2017-01-19T23:30:00', 'f');
INSERT INTO Availability VALUES (17, '2017-01-22T09:00:00', '2017-01-22T12:00:00', 'f');
INSERT INTO Availability VALUES (17, '2017-01-24T20:00:00', '2017-01-24T23:59:00', 'f');
INSERT INTO Availability VALUES (17, '2017-01-30T09:00:00', '2017-01-30T16:00:00', 'f');
INSERT INTO Availability VALUES (17, '2017-02-04T10:00:00', '2017-02-04T19:00:00', 'f');
INSERT INTO Availability VALUES (17, '2017-02-06T12:00:00', '2017-02-06T20:00:00', 'f');
INSERT INTO Availability VALUES (17, '2017-02-07T09:00:00', '2017-02-07T13:00:00', 'f');
INSERT INTO Availability VALUES (18, '2017-01-15T00:00:00', '2017-01-15T13:00:00', 'f');
INSERT INTO Availability VALUES (18, '2017-01-17T12:00:00', '2017-01-17T19:00:00', 'f');
INSERT INTO Availability VALUES (18, '2017-01-20T10:00:00', '2017-01-20T23:00:00', 'f');
INSERT INTO Availability VALUES (18, '2017-01-23T00:00:00', '2017-01-23T09:00:00', 'f');
INSERT INTO Availability VALUES (18, '2017-01-28T10:00:00', '2017-01-28T20:00:00', 'f');
INSERT INTO Availability VALUES (18, '2017-01-30T10:00:00', '2017-01-30T23:59:00', 'f');
INSERT INTO Availability VALUES (18, '2017-01-31T10:00:00', '2017-01-31T20:00:00', 'f');
INSERT INTO Availability VALUES (18, '2017-02-01T10:00:00', '2017-02-01T18:00:00', 'f');
INSERT INTO Availability VALUES (18, '2017-02-02T09:00:00', '2017-02-02T15:00:00', 'f');
INSERT INTO Availability VALUES (18, '2017-02-04T12:00:00', '2017-02-04T23:00:00', 'f');
INSERT INTO Availability VALUES (18, '2017-02-05T10:00:00', '2017-02-05T21:00:00', 'f');
INSERT INTO Availability VALUES (18, '2017-02-06T10:00:00', '2017-02-06T15:00:00', 'f');
INSERT INTO Availability VALUES (18, '2017-02-07T11:00:00', '2017-02-07T20:00:00', 'f');
INSERT INTO Availability VALUES (19, '2017-01-15T08:00:00', '2017-01-15T15:00:00', 'f');
INSERT INTO Availability VALUES (19, '2017-01-16T10:00:00', '2017-01-16T22:00:00', 'f');
INSERT INTO Availability VALUES (19, '2017-01-20T08:00:00', '2017-01-20T23:00:00', 'f');
INSERT INTO Availability VALUES (19, '2017-01-23T08:00:00', '2017-01-23T14:00:00', 'f');
INSERT INTO Availability VALUES (19, '2017-01-25T08:00:00', '2017-01-25T11:00:00', 'f');
INSERT INTO Availability VALUES (19, '2017-01-28T12:00:00', '2017-01-28T23:59:00', 'f');
INSERT INTO Availability VALUES (19, '2017-01-30T13:00:00', '2017-01-30T21:00:00', 'f');
INSERT INTO Availability VALUES (19, '2017-02-02T08:00:00', '2017-02-02T12:00:00', 'f');
INSERT INTO Availability VALUES (19, '2017-02-03T10:00:00', '2017-02-03T14:00:00', 'f');
INSERT INTO Availability VALUES (19, '2017-02-05T11:00:00', '2017-02-05T15:00:00', 'f');
INSERT INTO Availability VALUES (19, '2017-02-07T08:00:00', '2017-02-07T15:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-01-15T10:00:00', '2017-01-15T20:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-01-17T12:00:00', '2017-01-17T22:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-01-20T10:00:00', '2017-01-20T19:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-01-23T00:00:00', '2017-01-23T09:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-01-28T10:00:00', '2017-01-28T17:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-01-30T10:00:00', '2017-01-30T20:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-01-31T10:00:00', '2017-01-31T17:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-02-01T10:00:00', '2017-02-01T20:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-02-02T10:00:00', '2017-02-02T19:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-02-04T12:00:00', '2017-02-04T18:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-02-05T10:00:00', '2017-02-05T20:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-02-06T10:00:00', '2017-02-06T13:00:00', 'f');
INSERT INTO Availability VALUES (20, '2017-02-07T11:00:00', '2017-02-07T14:00:00', 'f');
INSERT INTO Availability VALUES (21, '2017-01-15T08:00:00', '2017-01-15T13:00:00', 'f');
INSERT INTO Availability VALUES (21, '2017-01-17T12:00:00', '2017-01-17T16:00:00', 'f');
INSERT INTO Availability VALUES (21, '2017-01-20T10:00:00', '2017-01-20T17:00:00', 'f');
INSERT INTO Availability VALUES (21, '2017-01-23T00:00:00', '2017-01-23T10:00:00', 'f');
INSERT INTO Availability VALUES (21, '2017-01-28T10:00:00', '2017-01-28T22:00:00', 'f');
INSERT INTO Availability VALUES (21, '2017-01-30T19:00:00', '2017-01-30T23:59:00', 'f');
INSERT INTO Availability VALUES (21, '2017-01-31T17:00:00', '2017-01-31T20:00:00', 'f');
INSERT INTO Availability VALUES (21, '2017-02-01T10:00:00', '2017-02-01T18:00:00', 'f');
INSERT INTO Availability VALUES (21, '2017-02-02T09:00:00', '2017-02-02T17:00:00', 'f');
INSERT INTO Availability VALUES (21, '2017-02-04T12:00:00', '2017-02-04T23:00:00', 'f');
INSERT INTO Availability VALUES (21, '2017-02-05T10:00:00', '2017-02-05T20:00:00', 'f');
INSERT INTO Availability VALUES (21, '2017-02-06T10:00:00', '2017-02-06T17:00:00', 'f');
INSERT INTO Availability VALUES (21, '2017-02-07T11:00:00', '2017-02-07T18:00:00', 'f');
INSERT INTO Availability VALUES (22, '2017-01-16T00:00:00', '2017-01-16T08:00:00', 'f');
INSERT INTO Availability VALUES (22, '2017-01-18T12:00:00', '2017-01-18T15:00:00', 'f');
INSERT INTO Availability VALUES (22, '2017-01-20T12:00:00', '2017-01-20T17:00:00', 'f');
INSERT INTO Availability VALUES (22, '2017-01-23T09:00:00', '2017-01-23T20:00:00', 'f');
INSERT INTO Availability VALUES (22, '2017-01-25T05:00:00', '2017-01-25T10:00:00', 'f');
INSERT INTO Availability VALUES (22, '2017-01-28T00:00:00', '2017-01-28T16:00:00', 'f');
INSERT INTO Availability VALUES (22, '2017-01-31T10:00:00', '2017-01-31T14:00:00', 'f');
INSERT INTO Availability VALUES (22, '2017-02-02T00:00:00', '2017-02-02T08:00:00', 'f');
INSERT INTO Availability VALUES (22, '2017-02-05T08:00:00', '2017-02-05T12:00:00', 'f');
INSERT INTO Availability VALUES (23, '2017-01-16T10:00:00', '2017-01-16T13:00:00', 'f');
INSERT INTO Availability VALUES (23, '2017-01-20T10:00:00', '2017-01-20T13:00:00', 'f');
INSERT INTO Availability VALUES (23, '2017-01-22T11:00:00', '2017-01-22T19:00:00', 'f');
INSERT INTO Availability VALUES (23, '2017-01-23T15:00:00', '2017-01-23T23:30:00', 'f');
INSERT INTO Availability VALUES (23, '2017-01-30T08:00:00', '2017-01-30T13:00:00', 'f');
INSERT INTO Availability VALUES (23, '2017-02-01T10:00:00', '2017-02-01T15:00:00', 'f');
INSERT INTO Availability VALUES (23, '2017-02-04T15:00:00', '2017-02-04T22:00:00', 'f');
INSERT INTO Availability VALUES (23, '2017-02-06T08:00:00', '2017-02-06T16:00:00', 'f');
INSERT INTO Availability VALUES (23, '2017-02-08T18:00:00', '2017-02-08T21:00:00', 'f');
INSERT INTO Availability VALUES (24, '2017-01-15T12:00:00', '2017-01-15T19:00:00', 'f');
INSERT INTO Availability VALUES (24, '2017-01-16T12:00:00', '2017-01-16T16:00:00', 'f');
INSERT INTO Availability VALUES (24, '2017-01-17T10:00:00', '2017-01-17T19:00:00', 'f');
INSERT INTO Availability VALUES (24, '2017-01-20T00:00:00', '2017-01-20T23:00:00', 'f');
INSERT INTO Availability VALUES (24, '2017-01-21T12:00:00', '2017-01-21T19:00:00', 'f');
INSERT INTO Availability VALUES (24, '2017-01-25T12:00:00', '2017-01-25T16:00:00', 'f');
INSERT INTO Availability VALUES (24, '2017-02-27T08:00:00', '2017-02-27T19:00:00', 'f');
INSERT INTO Availability VALUES (24, '2017-02-04T09:00:00', '2017-02-04T19:00:00', 'f');
INSERT INTO Availability VALUES (24, '2017-02-06T12:00:00', '2017-02-06T23:00:00', 'f');
INSERT INTO Availability VALUES (25, '2017-01-30T10:00:00', '2017-01-30T15:00:00', 'f');
INSERT INTO Availability VALUES (25, '2017-01-31T12:00:00', '2017-01-31T19:00:00', 'f');
INSERT INTO Availability VALUES (25, '2017-02-01T10:00:00', '2017-02-01T21:00:00', 'f');
INSERT INTO Availability VALUES (25, '2017-02-02T10:00:00', '2017-02-02T17:00:00', 'f');
INSERT INTO Availability VALUES (25, '2017-02-03T11:00:00', '2017-02-03T20:00:00', 'f');
INSERT INTO Availability VALUES (25, '2017-02-04T10:00:00', '2017-02-04T19:00:00', 'f');
INSERT INTO Availability VALUES (25, '2017-02-05T12:00:00', '2017-02-05T21:00:00', 'f');
INSERT INTO Availability VALUES (25, '2017-02-06T00:00:00', '2017-02-06T09:00:00', 'f');
INSERT INTO Availability VALUES (25, '2017-02-07T00:00:00', '2017-02-07T11:00:00', 'f');
INSERT INTO Availability VALUES (26, '2017-02-01T00:00:00', '2017-02-01T01:00:00', 'f');

INSERT INTO AttendanceGames VALUES ('MiamiMens', '2017-01-14', '17:00');
INSERT INTO AttendanceGames VALUES ('NCStateMens', '2017-01-23', '15:00');
INSERT INTO AttendanceGames VALUES ('WakeForestMens', '2017-01-28', '12:00');
INSERT INTO AttendanceGames VALUES ('PittMens', '2017-02-04', '19:00');
INSERT INTO AttendanceGames VALUES ('UNCWomens', '2017-01-12', '15:00');
INSERT INTO AttendanceGames VALUES ('VirginiaTechWomens', '2017-01-19', '12:00');
INSERT INTO AttendanceGames VALUES ('WakeForestWomens', '2017-01-29', '18:00');
INSERT INTO AttendanceGames VALUES ('ClemsonWomens', '2017-02-02', '20:00');

INSERT INTO Member_Attends_Games VALUES (0, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (0, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (1, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (2, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (2, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (2, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (3, 'PittMens');
INSERT INTO Member_Attends_Games VALUES (4, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (4, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (4, 'WakeForestMens');
INSERT INTO Member_Attends_Games VALUES (4, 'PittMens');
INSERT INTO Member_Attends_Games VALUES (4, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (4, 'VirginiaTechWomens');
INSERT INTO Member_Attends_Games VALUES (5, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (5, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (6, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (6, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (6, 'VirginiaTechWomens');
INSERT INTO Member_Attends_Games VALUES (7, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (7, 'PittMens');
INSERT INTO Member_Attends_Games VALUES (7, 'VirginiaTechWomens');
INSERT INTO Member_Attends_Games VALUES (8, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (8, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (8, 'ClemsonWomens');
INSERT INTO Member_Attends_Games VALUES (8, 'PittMens');
INSERT INTO Member_Attends_Games VALUES (8, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (8, 'VirginiaTechWomens');
INSERT INTO Member_Attends_Games VALUES (9, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (10, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (10, 'WakeForestWomens');
INSERT INTO Member_Attends_Games VALUES (11, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (11, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (11, 'WakeForestMens');
INSERT INTO Member_Attends_Games VALUES (11, 'PittMens');
INSERT INTO Member_Attends_Games VALUES (11, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (12, 'PittMens');
INSERT INTO Member_Attends_Games VALUES (12, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (13, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (13, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (13, 'ClemsonWomens');
INSERT INTO Member_Attends_Games VALUES (13, 'PittMens');
INSERT INTO Member_Attends_Games VALUES (13, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (13, 'VirginiaTechWomens');
INSERT INTO Member_Attends_Games VALUES (14, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (14, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (14, 'ClemsonWomens');
INSERT INTO Member_Attends_Games VALUES (14, 'PittMens');
INSERT INTO Member_Attends_Games VALUES (14, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (14, 'VirginiaTechWomens');
INSERT INTO Member_Attends_Games VALUES (14, 'WakeForestWomens');
INSERT INTO Member_Attends_Games VALUES (15, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (15, 'VirginiaTechWomens');
INSERT INTO Member_Attends_Games VALUES (17, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (17, 'VirginiaTechWomens');
INSERT INTO Member_Attends_Games VALUES (18, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (19, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (20, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (20, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (20, 'ClemsonWomens');
INSERT INTO Member_Attends_Games VALUES (21, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (21, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (21, 'WakeForestMens');
INSERT INTO Member_Attends_Games VALUES (21, 'PittMens');
INSERT INTO Member_Attends_Games VALUES (21, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (22, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (22, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (22, 'WakeForestMens');
INSERT INTO Member_Attends_Games VALUES (22, 'PittMens');
INSERT INTO Member_Attends_Games VALUES (22, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (23, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (23, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (23, 'WakeForestMens');
INSERT INTO Member_Attends_Games VALUES (24, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (24, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (25, 'MiamiMens');
INSERT INTO Member_Attends_Games VALUES (25, 'NCStateMens');
INSERT INTO Member_Attends_Games VALUES (25, 'ClemsonWomens');
INSERT INTO Member_Attends_Games VALUES (25, 'PittMens');
INSERT INTO Member_Attends_Games VALUES (25, 'UNCWomens');
INSERT INTO Member_Attends_Games VALUES (25, 'VirginiaTechWomens');
INSERT INTO Member_Attends_Games VALUES (26, 'PittMens');


-- USER QUERIES

-- Query for member to add times.
-- For member with m_id = 2, insert user is free from 8am-11am on February 7, 2017:
INSERT INTO Availability VALUES(2, '2017-02-07T08:00:00', '2017-02-07T11:00:00', 'f');

-- Get availabilities for every tent member query (for a captain to create a schedule or a member to see availabilities)
-- For tent with tentID = 1:
SELECT m.name, a.startTime, a.endTime
FROM Availability a, Member m, Member_In_Tent t
WHERE a.memberID = m.ID AND t.tentID = 1 AND m.id = t.memberID;

-- Captain updates schedule/shift query so a member has a shift (for a captain to notify members of their shifts)
UPDATE Availability SET shift = 't' WHERE memberID = 3 AND startTime = '2017-01-29T10:00:00' AND endTime = '2017-01-29T23:00:00';
UPDATE Availability SET shift = 't' WHERE memberID = 4 AND startTime = '2017-01-29T00:00:00' AND endTime = '2017-01-29T12:00:00';
UPDATE Availability SET shift = 't' WHERE memberID = 5 AND startTime = '2017-01-29T12:00:00' AND endTime = '2017-01-29T17:00:00';
UPDATE Availability SET shift = 't' WHERE memberID = 6 AND startTime = '2017-01-29T17:00:00' AND endTime = '2017-01-29T18:45:36';

-- Captain gets final shifts query (for a captain to see currently scheduled shifts)
-- For a captain in tent with tent id = 1:
SELECT m.name, a.startTime, a.endTime
FROM Availability a, Member m, Member_In_Tent t
WHERE a.memberID = m.id AND t.tentID = 1 AND m.id = t.memberID AND shift = 't';

-- Member get his/her shifts query (for a member to see his/her scheduled shifts)
-- For a member with m_id = 4:
SELECT m.name, a.startTime, a.endTime
FROM Availability a, Member m
WHERE a.memberID = m.id AND m.id = 4 AND shift = 't';

-- Captain get number of games attended for all members query (to find out who’s slacking)
-- For captain of a tent with tentID = 5:
SELECT m.name, m.games_attended
FROM Member m, Member_In_Tent t
WHERE t.tentID = 5 AND t.memberID = m.id;

-- Member get his/her games attended list query (to see which games he/she attended)
-- For a member with member ID = 14
SELECT mag.gameName
FROM Member_Attends_Games mag
WHERE mag.memberID = 14;

-- Captain get hours logged list for all members query (to find out who’s slacking)
-- For captain of a tent with tentID = 3;
SELECT m.name, m.hours_logged
FROM Member m, Member_In_Tent t
WHERE t.tentID = 3 AND t.memberID = m.id;

-- Member get his/her hours logged query (to find out how much he/she has done)
-- For a member with member ID = 6
SELECT m.hours_logged
FROM Member m
WHERE m.id = 6;