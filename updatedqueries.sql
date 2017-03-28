
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
