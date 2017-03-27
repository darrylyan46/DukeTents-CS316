INSERT INTO Tent VALUES (0, 'apple', 'white'); 
INSERT INTO Tent VALUES (1, 'banana', 'white');
INSERT INTO Tent VALUES (2, 'carrot', 'white');
INSERT INTO Tent VALUES (3, 'date', 'white');
INSERT INTO Tent VALUES (4, 'eggplant', 'white');
INSERT INTO Tent VALUES (5, 'fig', 'white');


INSERT INTO Member VALUES (0, 'Anna', 3, 2);
INSERT INTO Member VALUES (1, 'Brad', 0, 1); 
INSERT INTO Member VALUES (2, 'Carl', 9, 3); 
INSERT INTO Member VALUES (3, 'Diana', 4, 1); 
INSERT INTO Member VALUES (4, 'Eric', 6, 6); 
INSERT INTO Member VALUES (5, 'Frank', 7, 2);
INSERT INTO Member VALUES (6, 'George', 8, 3);
INSERT INTO Member VALUES (7, 'Harry', 2, 3);
INSERT INTO Member VALUES (8, 'Issac', 3, 6);
INSERT INTO Member VALUES (9, 'James', 1, 1);
INSERT INTO Member VALUES (10, 'Kevin', 7, 2);
INSERT INTO Member VALUES (11, 'Lucy', 10, 5);
INSERT INTO Member VALUES (12, 'Mary', 9, 2);
INSERT INTO Member VALUES (13, 'Nick', 7, 6);
INSERT INTO Member VALUES (14, 'Oliver', 8, 7);
INSERT INTO Member VALUES (15, 'Percy', 3, 2);
INSERT INTO Member VALUES (16, 'Quinn', 7, 0);
INSERT INTO Member VALUES (17, 'Rachel', 2, 2);
INSERT INTO Member VALUES (18, 'Steve', 1, 1);
INSERT INTO Member VALUES (19, 'Tyler', 7, 1);
INSERT INTO Member VALUES (20, 'Ulysses', 20, 3);
INSERT INTO Member VALUES (21, 'Vick', 19, 5);
INSERT INTO Member VALUES (22, 'Wallace', 5, 5);
INSERT INTO Member VALUES (23, 'Xavier', 7, 3);
INSERT INTO Member VALUES (24, 'Yvette', 3, 2);
INSERT INTO Member VALUES (25, 'Zoe', 15, 6);


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
INSERT INTO Member_In_Tent VALUES (4, 24);
INSERT INTO Member_In_Tent VALUES (5, 25);




INSERT INTO Availability VALUES (0, 170226, 080013, 'f'); 
INSERT INTO Availability VALUES (0, 170226, 170021, 'f'); 
INSERT INTO Availability VALUES (1, 170226, 090019, 'f'); 
INSERT INTO Availability VALUES (2, 170228, 140019, 'f');
INSERT INTO Availability VALUES (2, 170228, 160000, 'f'); 
INSERT INTO Availability VALUES (3, 170226, 020000, 'f'); 
INSERT INTO Availability VALUES (4, 170226, 000010, 'f'); 
INSERT INTO Availability VALUES (5, 170226, 050011, 'f');
INSERT INTO AttendanceGames VALUES ('SyracuseMens', 170216, 1900); 
INSERT INTO AttendanceGames VALUES ('MiamiWomens', 170218, 1400); 
INSERT INTO AttendanceGames VALUES ('UNCWomens', 170210, 1600); 
INSERT INTO AttendanceGames VALUES ('FSUMens', 170221, 1900); 
INSERT INTO AttendanceGames VALUES ('NCStateWomens', 170221, 2000);
INSERT INTO Member_Attends_Games VALUES (0, 'SyracuseMens'); 
INSERT INTO Member_Attends_Games VALUES (0, 'MiamiWomens'); 
INSERT INTO Member_Attends_Games VALUES (1, 'MiamiWomens'); 
INSERT INTO Member_Attends_Games VALUES (1, 'UNCWomens'); 
INSERT INTO Member_Attends_Games VALUES (3, 'FSUMens'); 
INSERT INTO Member_Attends_Games VALUES (5, 'NCStateWomens'); 
INSERT INTO Member_Attends_Games VALUES (5, 'SyracuseMens'); 
