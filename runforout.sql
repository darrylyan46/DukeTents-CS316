-- Create tables specified in E/R diagram

CREATE TABLE Tent
(id INTEGER PRIMARY KEY NOT NULL,
 name VARCHAR(30) NOT NULL,
 color varchar(5) NOT NULL);

-- Use NULLS approach for ISA relationship

CREATE TABLE Member
(id INTEGER PRIMARY KEY NOT NULL, 
 name VARCHAR(30) NOT NULL,
 hours_Logged INTEGER NOT NULL,
 games_Attended INTEGER NOT NULL,
 permissions BOOLEAN);

CREATE TABLE Member_In_Tent
(tentID INTEGER NOT NULL REFERENCES Tent(id),
 m_id INTEGER NOT NULL REFERENCES Member(id),
 PRIMARY KEY (tentID, m_id));

CREATE TABLE Availability
(m_id INTEGER NOT NULL REFERENCES Member(id),
 shift_date VARCHAR(30) NOT NULL, 
 shift_time VARCHAR(30), 
 shift BOOLEAN,
 PRIMARY KEY (m_id, shift_date, shift_start_time));

CREATE TABLE AttendanceGames
(name VARCHAR(30) NOT NULL PRIMARY KEY, 
 game_date VARCHAR(30) NOT NULL, 
 game_time VARCHAR(30) NOT NULL);

CREATE TABLE Member_Attends_Games
(m_id INTEGER NOT NULL REFERENCES Member(id), 
game_name VARCHAR(30) NOT NULL REFERENCES AttendanceGames(name),
PRIMARY KEY (m_id, game_name));

-- Begin production dataset
INSERT INTO Tent VALUES (0, 'apple', 'white'); 
INSERT INTO Tent VALUES (1, 'banana', 'white');
INSERT INTO Tent VALUES (2, 'carrot', 'white');
INSERT INTO Tent VALUES (3, 'date', 'white');
INSERT INTO Tent VALUES (4, 'eggplant', 'white');
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
INSERT INTO Member VALUES (19, 'Tyler', 7, 1), 'f';
INSERT INTO Member VALUES (20, 'Ulysses', 20, 3), 'f';
INSERT INTO Member VALUES (21, 'Vick', 19, 5, 't');
INSERT INTO Member VALUES (22, 'Wallace', 5, 5, 'f');
INSERT INTO Member VALUES (23, 'Xavier', 7, 3, 'f');
INSERT INTO Member VALUES (24, 'Yvette', 3, 2, 'f');
INSERT INTO Member VALUES (25, 'Zoe', 15, 6, 'f');

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

INSERT INTO Availability VALUES (0, '2017-01-16', '08:00-13:00', 'f'); 
INSERT INTO Availability VALUES (0, '2017-01-20', '08:00-13:00', 'f'); 
INSERT INTO Availability VALUES (0, '2017-01-22', '11:00-19:00', 'f'); 
INSERT INTO Availability VALUES (0, '2017-01-23', '10:00-14:30', 'f'); 
INSERT INTO Availability VALUES (0, '2017-01-30', '08:00-13:00', 'f'); 
INSERT INTO Availability VALUES (0, '2017-02-01', '08:00-16:00', 'f'); 
INSERT INTO Availability VALUES (0, '2017-02-04', '15:00-20:00', 'f'); 
INSERT INTO Availability VALUES (0, '2017-02-06', '08:00-13:00', 'f'); 
INSERT INTO Availability VALUES (0, '2017-02-08', '18:00-23:00', 'f'); 
INSERT INTO Availability VALUES (1, '2017-01-14', '09:00-12:00', 'f'); 
INSERT INTO Availability VALUES (1, '2017-01-15', '19:00-23:30', 'f'); 
INSERT INTO Availability VALUES (1, '2017-01-17', '14:00-22:00', 'f'); 
INSERT INTO Availability VALUES (1, '2017-01-19', '16:00-23:30', 'f'); 
INSERT INTO Availability VALUES (1, '2017-01-22', '09:00-12:00', 'f'); 
INSERT INTO Availability VALUES (1, '2017-01-24', '20:00-23:59', 'f'); 
INSERT INTO Availability VALUES (1, '2017-01-30', '09:00-12:00', 'f'); 
INSERT INTO Availability VALUES (1, '2017-02-07', '09:00-19:00', 'f'); 
INSERT INTO Availability VALUES (2, '2017-01-15', '11:00-19:00', 'f'); 
INSERT INTO Availability VALUES (2, '2017-01-17', '11:00-16:00', 'f'); 
INSERT INTO Availability VALUES (2, '2017-01-20', '10:00-19:00', 'f'); 
INSERT INTO Availability VALUES (2, '2017-01-23', '09:00-19:00', 'f'); 
INSERT INTO Availability VALUES (2, '2017-01-24', '11:00-15:00', 'f'); 
INSERT INTO Availability VALUES (2, '2017-01-26', '11:00-23:00', 'f'); 
INSERT INTO Availability VALUES (2, '2017-01-31', '10:00-19:00', 'f'); 
INSERT INTO Availability VALUES (2, '2017-02-07', '11:00-19:00', 'f'); 
INSERT INTO Availability VALUES (3, '2017-01-24', '12:00-19:00', 'f'); 
INSERT INTO Availability VALUES (3, '2017-01-26', '12:00-16:00', 'f'); 
INSERT INTO Availability VALUES (3, '2017-01-28', '11:00-19:00', 'f'); 
INSERT INTO Availability VALUES (3, '2017-01-29', '10:00-23:00', 'f'); 
INSERT INTO Availability VALUES (3, '2017-02-01', '12:00-19:00', 'f'); 
INSERT INTO Availability VALUES (3, '2017-02-03', '12:00-16:00', 'f'); 
INSERT INTO Availability VALUES (3, '2017-02-04', '08:00-19:00', 'f'); 
INSERT INTO Availability VALUES (3, '2017-02-05', '09:00-19:00', 'f'); 
INSERT INTO Availability VALUES (3, '2017-02-07', '12:00-23:00', 'f'); 
INSERT INTO Availability VALUES (4, '2017-01-29', '00:00-12:00', 'f'); 
INSERT INTO Availability VALUES (4, '2017-01-30', '00:00-12:00', 'f'); 
INSERT INTO Availability VALUES (4, '2017-01-31', '00:00-08:00', 'f'); 
INSERT INTO Availability VALUES (4, '2017-02-01', '00:00-10:00', 'f'); 
INSERT INTO Availability VALUES (4, '2017-02-03', '00:00-12:00', 'f'); 
INSERT INTO Availability VALUES (4, '2017-02-04', '00:00-12:00', 'f'); 
INSERT INTO Availability VALUES (4, '2017-02-06', '00:00-09:00', 'f'); 
INSERT INTO Availability VALUES (5, '2017-01-16', '00:00-09:00', 'f'); 
INSERT INTO Availability VALUES (5, '2017-01-18', '00:00-13:00', 'f'); 
INSERT INTO Availability VALUES (5, '2017-01-20', '10:00-19:00', 'f'); 
INSERT INTO Availability VALUES (5, '2017-01-23', '00:00-10:00', 'f'); 
INSERT INTO Availability VALUES (5, '2017-01-25', '00:00-10:00', 'f'); 
INSERT INTO Availability VALUES (5, '2017-01-28', '00:00-11:00', 'f'); 
INSERT INTO Availability VALUES (5, '2017-01-29', '12:00-17:00', 'f'); 
INSERT INTO Availability VALUES (5, '2017-01-31', '00:00-13:00', 'f'); 
INSERT INTO Availability VALUES (5, '2017-02-02', '00:00-09:00', 'f'); 
INSERT INTO Availability VALUES (5, '2017-02-05', '00:00-09:00', 'f'); 
INSERT INTO Availability VALUES (5, '2017-02-07', '00:00-11:00', 'f'); 
INSERT INTO Availability VALUES (6, '2017-01-16', '08:00-12:00', 'f'); 
INSERT INTO Availability VALUES (6, '2017-01-17', '08:00-16:00', 'f'); 
INSERT INTO Availability VALUES (6, '2017-01-19', '08:00-13:00', 'f'); 
INSERT INTO Availability VALUES (6, '2017-01-21', '10:00-12:00', 'f'); 
INSERT INTO Availability VALUES (6, '2017-01-22', '08:00-12:00', 'f'); 
INSERT INTO Availability VALUES (6, '2017-01-24', '12:00-19:00', 'f'); 
INSERT INTO Availability VALUES (6, '2017-01-26', '08:00-12:00', 'f'); 
INSERT INTO Availability VALUES (6, '2017-01-29', '17:00-23:59', 'f'); 
INSERT INTO Availability VALUES (6, '2017-02-06', '10:00-12:00', 'f'); 
INSERT INTO Availability VALUES (6, '2017-02-07', '08:00-12:00', 'f'); 
INSERT INTO Availability VALUES (7, '2017-01-15', '08:00-12:00', 'f'); 
INSERT INTO Availability VALUES (7, '2017-01-16', '10:00-12:00', 'f'); 
INSERT INTO Availability VALUES (7, '2017-01-20', '08:00-14:00', 'f'); 
INSERT INTO Availability VALUES (7, '2017-01-23', '08:00-12:00', 'f'); 
INSERT INTO Availability VALUES (7, '2017-01-25', '08:00-19:00', 'f'); 
INSERT INTO Availability VALUES (7, '2017-01-28', '12:00-22:00', 'f'); 
INSERT INTO Availability VALUES (7, '2017-01-30', '13:00-21:00', 'f'); 
INSERT INTO Availability VALUES (7, '2017-02-02', '08:00-12:00', 'f'); 
INSERT INTO Availability VALUES (7, '2017-02-03', '08:00-14:00', 'f'); 
INSERT INTO Availability VALUES (7, '2017-02-05', '08:00-12:00', 'f'); 
INSERT INTO Availability VALUES (7, '2017-02-07', '08:00-15:00', 'f'); 
INSERT INTO Availability VALUES (8, '2017-01-16', '10:00-15:00', 'f'); 
INSERT INTO Availability VALUES (8, '2017-01-20', '00:00-22:00', 'f'); 
INSERT INTO Availability VALUES (8, '2017-01-25', '10:00-23:00', 'f'); 
INSERT INTO Availability VALUES (8, '2017-01-27', '12:00-20:00', 'f'); 
INSERT INTO Availability VALUES (8, '2017-01-30', '10:00-19:00', 'f'); 
INSERT INTO Availability VALUES (8, '2017-02-03', '00:00-15:00', 'f'); 
INSERT INTO Availability VALUES (8, '2017-02-04', '10:00-15:00', 'f'); 
INSERT INTO Availability VALUES (8, '2017-02-06', '10:00-18:00', 'f'); 
INSERT INTO Availability VALUES (9, '2017-01-30', '10:00-15:00', 'f'); 
INSERT INTO Availability VALUES (9, '2017-01-31', '12:00-15:00', 'f'); 
INSERT INTO Availability VALUES (9, '2017-02-01', '10:00-11:00', 'f'); 
INSERT INTO Availability VALUES (9, '2017-02-02', '10:00-19:00', 'f'); 
INSERT INTO Availability VALUES (9, '2017-02-03', '11:00-14:00', 'f'); 
INSERT INTO Availability VALUES (9, '2017-02-04', '10:00-15:00', 'f'); 
INSERT INTO Availability VALUES (9, '2017-02-05', '12:00-15:00', 'f'); 
INSERT INTO Availability VALUES (9, '2017-02-06', '00:00-08:00', 'f'); 
INSERT INTO Availability VALUES (9, '2017-02-07', '00:00-10:00', 'f'); 
INSERT INTO Availability VALUES (10, '2017-01-23', '12:00-22:00', 'f'); 
INSERT INTO Availability VALUES (10, '2017-01-24', '12:00-20:00', 'f'); 
INSERT INTO Availability VALUES (10, '2017-01-25', '12:00-19:00', 'f'); 
INSERT INTO Availability VALUES (10, '2017-01-26', '12:00-14:00', 'f'); 
INSERT INTO Availability VALUES (10, '2017-01-27', '12:00-16:00', 'f'); 
INSERT INTO Availability VALUES (10, '2017-01-28', '12:00-20:00', 'f'); 
INSERT INTO Availability VALUES (10, '2017-01-29', '12:00-23:00', 'f'); 
INSERT INTO Availability VALUES (10, '2017-01-30', '12:00-22:00', 'f'); 
INSERT INTO Availability VALUES (10, '2017-01-31', '12:00-20:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-01-15', '10:00-23:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-01-17', '12:00-20:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-01-20', '10:00-19:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-01-23', '00:00-15:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-01-28', '10:00-15:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-01-30', '10:00-18:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-01-31', '10:00-15:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-02-01', '10:00-18:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-02-02', '10:00-15:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-02-04', '12:00-15:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-02-05', '10:00-11:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-02-06', '10:00-19:00', 'f'); 
INSERT INTO Availability VALUES (11, '2017-02-07', '11:00-14:00', 'f'); 
INSERT INTO Availability VALUES (12, '2017-01-16', '08:00-13:00', 'f'); 
INSERT INTO Availability VALUES (12, '2017-01-20', '08:00-13:00', 'f'); 
INSERT INTO Availability VALUES (12, '2017-01-22', '11:00-19:00', 'f'); 
INSERT INTO Availability VALUES (12, '2017-01-23', '10:00-14:30', 'f'); 
INSERT INTO Availability VALUES (12, '2017-01-30', '08:00-13:00', 'f'); 
INSERT INTO Availability VALUES (12, '2017-02-01', '08:00-16:00', 'f'); 
INSERT INTO Availability VALUES (12, '2017-02-04', '15:00-20:00', 'f'); 
INSERT INTO Availability VALUES (12, '2017-02-06', '08:00-13:00', 'f'); 
INSERT INTO Availability VALUES (13, '2017-01-16', '00:00-10:00', 'f'); 
INSERT INTO Availability VALUES (13, '2017-01-18', '00:00-15:00', 'f'); 
INSERT INTO Availability VALUES (13, '2017-01-20', '10:00-17:00', 'f'); 
INSERT INTO Availability VALUES (13, '2017-01-23', '00:00-09:00', 'f'); 
INSERT INTO Availability VALUES (13, '2017-01-25', '00:00-10:00', 'f'); 
INSERT INTO Availability VALUES (13, '2017-01-28', '00:00-16:00', 'f'); 
INSERT INTO Availability VALUES (13, '2017-01-31', '00:00-14:00', 'f'); 
INSERT INTO Availability VALUES (13, '2017-02-02', '00:00-08:00', 'f'); 
INSERT INTO Availability VALUES (13, '2017-02-05', '00:00-12:00', 'f'); 
INSERT INTO Availability VALUES (14, '2017-01-15', '12:00-19:00', 'f'); 
INSERT INTO Availability VALUES (14, '2017-01-16', '12:00-16:00', 'f'); 
INSERT INTO Availability VALUES (14, '2017-01-17', '11:00-19:00', 'f'); 
INSERT INTO Availability VALUES (14, '2017-01-20', '10:00-23:00', 'f'); 
INSERT INTO Availability VALUES (14, '2017-01-21', '12:00-19:00', 'f'); 
INSERT INTO Availability VALUES (14, '2017-01-25', '12:00-16:00', 'f'); 
INSERT INTO Availability VALUES (14, '2017-02-27', '08:00-19:00', 'f'); 
INSERT INTO Availability VALUES (14, '2017-02-04', '09:00-19:00', 'f'); 
INSERT INTO Availability VALUES (14, '2017-02-06', '12:00-23:00', 'f'); 
INSERT INTO Availability VALUES (15, '2017-01-16', '05:00-12:00', 'f'); 
INSERT INTO Availability VALUES (15, '2017-01-17', '08:00-17:00', 'f'); 
INSERT INTO Availability VALUES (15, '2017-01-19', '08:00-12:00', 'f'); 
INSERT INTO Availability VALUES (15, '2017-01-21', '00:00-12:00', 'f'); 
INSERT INTO Availability VALUES (15, '2017-01-22', '08:00-16:00', 'f'); 
INSERT INTO Availability VALUES (15, '2017-01-24', '12:00-23:59', 'f'); 
INSERT INTO Availability VALUES (15, '2017-01-26', '08:00-12:00', 'f'); 
INSERT INTO Availability VALUES (15, '2017-01-29', '06:00-18:00', 'f'); 
INSERT INTO Availability VALUES (15, '2017-02-06', '10:00-22:00', 'f'); 
INSERT INTO Availability VALUES (15, '2017-02-07', '08:00-23:00', 'f'); 
INSERT INTO Availability VALUES (16, '2017-01-16', '10:00-18:00', 'f'); 
INSERT INTO Availability VALUES (16, '2017-01-30', '08:00-15:00', 'f'); 
INSERT INTO Availability VALUES (16, '2017-01-31', '12:00-19:00', 'f'); 
INSERT INTO Availability VALUES (16, '2017-02-01', '00:00-13:50', 'f'); 
INSERT INTO Availability VALUES (16, '2017-02-02', '10:00-23:00', 'f'); 
INSERT INTO Availability VALUES (16, '2017-02-03', '11:00-23:59', 'f'); 
INSERT INTO Availability VALUES (16, '2017-02-04', '10:00-15:00', 'f'); 
INSERT INTO Availability VALUES (16, '2017-02-05', '12:00-19:00', 'f'); 
INSERT INTO Availability VALUES (16, '2017-02-06', '00:00-10:00', 'f'); 
INSERT INTO Availability VALUES (16, '2017-02-07', '00:00-13:00', 'f'); 
INSERT INTO Availability VALUES (17, '2017-01-14', '09:00-12:00', 'f'); 
INSERT INTO Availability VALUES (17, '2017-01-15', '19:00-23:30', 'f'); 
INSERT INTO Availability VALUES (17, '2017-01-17', '14:00-22:00', 'f'); 
INSERT INTO Availability VALUES (17, '2017-01-19', '16:00-23:30', 'f'); 
INSERT INTO Availability VALUES (17, '2017-01-22', '09:00-12:00', 'f'); 
INSERT INTO Availability VALUES (17, '2017-01-24', '20:00-23:59', 'f'); 
INSERT INTO Availability VALUES (17, '2017-01-30', '09:00-16:00', 'f'); 
INSERT INTO Availability VALUES (17, '2017-02-04', '10:00-19:00', 'f'); 
INSERT INTO Availability VALUES (17, '2017-02-06', '12:00-20:00', 'f'); 
INSERT INTO Availability VALUES (17, '2017-02-07', '09:00-13:00', 'f'); 
INSERT INTO Availability VALUES (18, '2017-01-15', '00:00-13:00', 'f'); 
INSERT INTO Availability VALUES (18, '2017-01-17', '12:00-19:00', 'f'); 
INSERT INTO Availability VALUES (18, '2017-01-20', '10:00-23:00', 'f'); 
INSERT INTO Availability VALUES (18, '2017-01-23', '00:00-09:00', 'f'); 
INSERT INTO Availability VALUES (18, '2017-01-28', '10:00-20:00', 'f'); 
INSERT INTO Availability VALUES (18, '2017-01-30', '10:00-23:59', 'f'); 
INSERT INTO Availability VALUES (18, '2017-01-31', '10:00-20:00', 'f'); 
INSERT INTO Availability VALUES (18, '2017-02-01', '10:00-18:00', 'f'); 
INSERT INTO Availability VALUES (18, '2017-02-02', '09:00-15:00', 'f'); 
INSERT INTO Availability VALUES (18, '2017-02-04', '12:00-23:00', 'f'); 
INSERT INTO Availability VALUES (18, '2017-02-05', '10:00-21:00', 'f'); 
INSERT INTO Availability VALUES (18, '2017-02-06', '10:00-15:00', 'f'); 
INSERT INTO Availability VALUES (18, '2017-02-07', '11:00-20:00', 'f'); 
INSERT INTO Availability VALUES (19, '2017-01-15', '08:00-15:00', 'f'); 
INSERT INTO Availability VALUES (19, '2017-01-16', '10:00-22:00', 'f'); 
INSERT INTO Availability VALUES (19, '2017-01-20', '08:00-23:00', 'f'); 
INSERT INTO Availability VALUES (19, '2017-01-23', '08:00-14:00', 'f'); 
INSERT INTO Availability VALUES (19, '2017-01-25', '08:00-11:00', 'f'); 
INSERT INTO Availability VALUES (19, '2017-01-28', '12:00-23:59', 'f'); 
INSERT INTO Availability VALUES (19, '2017-01-30', '13:00-21:00', 'f'); 
INSERT INTO Availability VALUES (19, '2017-02-02', '08:00-12:00', 'f'); 
INSERT INTO Availability VALUES (19, '2017-02-03', '10:00-14:00', 'f'); 
INSERT INTO Availability VALUES (19, '2017-02-05', '11:00-15:00', 'f'); 
INSERT INTO Availability VALUES (19, '2017-02-07', '08:00-15:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-01-15', '10:00-20:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-01-17', '12:00-22:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-01-20', '10:00-19:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-01-23', '00:00-09:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-01-28', '10:00-17:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-01-30', '10:00-20:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-01-31', '10:00-17:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-02-01', '10:00-20:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-02-02', '10:00-19:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-02-04', '12:00-18:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-02-05', '10:00-20:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-02-06', '10:00-13:00', 'f'); 
INSERT INTO Availability VALUES (20, '2017-02-07', '11:00-14:00', 'f'); 
INSERT INTO Availability VALUES (21, '2017-01-15', '08:00-13:00', 'f'); 
INSERT INTO Availability VALUES (21, '2017-01-17', '12:00-16:00', 'f'); 
INSERT INTO Availability VALUES (21, '2017-01-20', '10:00-17:00', 'f'); 
INSERT INTO Availability VALUES (21, '2017-01-23', '00:00-10:00', 'f'); 
INSERT INTO Availability VALUES (21, '2017-01-28', '10:00-22:00', 'f'); 
INSERT INTO Availability VALUES (21, '2017-01-30', '19:00-23:59', 'f'); 
INSERT INTO Availability VALUES (21, '2017-01-31', '17:00-20:00', 'f'); 
INSERT INTO Availability VALUES (21, '2017-02-01', '10:00-18:00', 'f'); 
INSERT INTO Availability VALUES (21, '2017-02-02', '09:00-17:00', 'f'); 
INSERT INTO Availability VALUES (21, '2017-02-04', '12:00-23:00', 'f'); 
INSERT INTO Availability VALUES (21, '2017-02-05', '10:00-20:00', 'f'); 
INSERT INTO Availability VALUES (21, '2017-02-06', '10:00-17:00', 'f'); 
INSERT INTO Availability VALUES (21, '2017-02-07', '11:00-18:00', 'f'); 
INSERT INTO Availability VALUES (22, '2017-01-16', '00:00-08:00', 'f'); 
INSERT INTO Availability VALUES (22, '2017-01-18', '12:00-15:00', 'f'); 
INSERT INTO Availability VALUES (22, '2017-01-20', '12:00-17:00', 'f'); 
INSERT INTO Availability VALUES (22, '2017-01-23', '09:00-20:00', 'f'); 
INSERT INTO Availability VALUES (22, '2017-01-25', '05:00-10:00', 'f'); 
INSERT INTO Availability VALUES (22, '2017-01-28', '00:00-16:00', 'f'); 
INSERT INTO Availability VALUES (22, '2017-01-31', '10:00-14:00', 'f'); 
INSERT INTO Availability VALUES (22, '2017-02-02', '00:00-08:00', 'f'); 
INSERT INTO Availability VALUES (22, '2017-02-05', '08:00-12:00', 'f'); 
INSERT INTO Availability VALUES (23, '2017-01-16', '10:00-13:00', 'f'); 
INSERT INTO Availability VALUES (23, '2017-01-20', '10:00-13:00', 'f'); 
INSERT INTO Availability VALUES (23, '2017-01-22', '11:00-19:00', 'f'); 
INSERT INTO Availability VALUES (23, '2017-01-23', '15:00-23:30', 'f'); 
INSERT INTO Availability VALUES (23, '2017-01-30', '08:00-13:00', 'f'); 
INSERT INTO Availability VALUES (23, '2017-02-01', '10:00-15:00', 'f'); 
INSERT INTO Availability VALUES (23, '2017-02-04', '15:00-22:00', 'f'); 
INSERT INTO Availability VALUES (23, '2017-02-06', '08:00-16:00', 'f'); 
INSERT INTO Availability VALUES (23, '2017-02-08', '18:00-21:00', 'f'); 
INSERT INTO Availability VALUES (24, '2017-01-15', '12:00-19:00', 'f'); 
INSERT INTO Availability VALUES (24, '2017-01-16', '12:00-16:00', 'f'); 
INSERT INTO Availability VALUES (24, '2017-01-17', '10:00-19:00', 'f'); 
INSERT INTO Availability VALUES (24, '2017-01-20', '00:00-23:00', 'f'); 
INSERT INTO Availability VALUES (24, '2017-01-21', '12:00-19:00', 'f'); 
INSERT INTO Availability VALUES (24, '2017-01-25', '12:00-16:00', 'f'); 
INSERT INTO Availability VALUES (24, '2017-02-27', '08:00-19:00', 'f'); 
INSERT INTO Availability VALUES (24, '2017-02-04', '09:00-19:00', 'f'); 
INSERT INTO Availability VALUES (24, '2017-02-06', '12:00-23:00', 'f'); 
INSERT INTO Availability VALUES (25, '2017-01-30', '10:00-15:00', 'f'); 
INSERT INTO Availability VALUES (25, '2017-01-31', '12:00-19:00', 'f'); 
INSERT INTO Availability VALUES (25, '2017-02-01', '10:00-21:00', 'f'); 
INSERT INTO Availability VALUES (25, '2017-02-02', '10:00-17:00', 'f'); 
INSERT INTO Availability VALUES (25, '2017-02-03', '11:00-20:00', 'f'); 
INSERT INTO Availability VALUES (25, '2017-02-04', '10:00-19:00', 'f'); 
INSERT INTO Availability VALUES (25, '2017-02-05', '12:00-21:00', 'f'); 
INSERT INTO Availability VALUES (25, '2017-02-06', '00:00-09:00', 'f'); 
INSERT INTO Availability VALUES (25, '2017-02-07', '00:00-11:00', 'f'); 

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




-- DYNAMIC QUERIES

-- Trigger for updating number of games attended for each member
-- after update or insert on number of games attended.
CREATE FUNCTION TF_update_gamesAttended_ref() RETURNS TRIGGER AS $$
 BEGIN
	UPDATE Member
	SET games_attended = games_attended + 1
	WHERE NEW.m_id = id;
	RETURN NEW;
 END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_update_gamesAttended
 AFTER INSERT ON Member_Attends_Games
 FOR EACH ROW
 EXECUTE PROCEDURE TF_update_gamesAttended_ref();

-- Trigger for updating Member hours logged after
-- update or insert on Availability
CREATE FUNCTION TF_update_hoursLogged_ref() RETURNS TRIGGER AS $$
 BEGIN
 	IF NEW.shift = 't' THEN
		UPDATE Member
		SET hours_logged = hours_logged + 1
		WHERE NEW.m_id = id;
	END IF;
	RETURN NEW;
 END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_update_hoursLogged
AFTER UPDATE ON Availability
FOR EACH ROW
EXECUTE PROCEDURE TF_update_hoursLogged_ref();

-- USER QUERIES

-- Query for member to add times. 
-- For member with m_id = 2, insert user is free from 8am-11am on February 7, 2017:
INSERT INTO Availability VALUES(2, '2017-02-07', '08:00-11:00');

-- Get availabilities for every tent member query (for a captain to create a schedule or a member to see availabilities)
-- For tent with tentID = 1:
SELECT m.name, a.shift_date, a.shift_time
FROM Availability a, Member m, Member_In_Tent t
WHERE a.m_ID = m.ID AND t.tentID = 1 AND m.id = t.m_ID;

-- Captain updates schedule/shift query so a member has a shift (for a captain to notify members of their shifts)
UPDATE Availability SET shift = 't' WHERE m_id = 3 AND shift_date = '2017-01-29' AND shift_time = '10:00-23:00';
UPDATE Availability SET shift = 't' WHERE m_id = 4 AND shift_date = '2017-01-29' AND shift_time = '00:00-12:00';
UPDATE Availability SET shift = 't' WHERE m_id = 5 AND shift_date = '2017-01-29' AND shift_time = '12:00-17:00';
UPDATE Availability SET shift = 't' WHERE m_id = 6 AND shift_date = '2017-01-29' AND shift_time = '17:00-23:59';

-- Captain gets final shifts query (for a captain to see currently scheduled shifts)
-- For a captain in tent with tent id = 1:
SELECT m.name, a.shift_date, a.shift_time
FROM Availability a, Member m, Member_In_Tent t
WHERE a.m_id = m.id AND t.tentID = 1 AND m.id = t.m_ID AND shift = 't';

-- Member get his/her shifts query (for a member to see his/her scheduled shifts)
-- For a member with m_id = 2:
SELECT m.name, a.shift_date, a.shift_time
FROM Availability a, Member m
WHERE a.m_ID = m.id AND m.id = 4 AND shift = 't';

-- Captain get number of games attended for all members query (to find out who’s slacking)
-- For captain of a tent with tentID = 0:
SELECT m.name, m.games_attended
FROM Member m, Member_In_Tent t
WHERE t.tentID = 4 AND t.m_id = m.id;

-- Member get his/her games attended list query (to see which games he/she attended)
-- For a member with member ID = 0
SELECT mag.game_name
FROM Member_Attends_Games mag
WHERE mag.m_id = 14;

-- Captain get hours logged list for all members query (to find out who’s slacking)
-- For captain of a tent with tentID = 0;
SELECT m.name, m.hours_logged
FROM Member m, Member_In_Tent t
WHERE t.tentID = 3 AND t.m_id = m.id;

-- Member get his/her hours logged query (to find out how much he/she has done)
-- For a member with member ID = 3
SELECT m.hours_logged
FROM Member m
WHERE m.id = 23;
