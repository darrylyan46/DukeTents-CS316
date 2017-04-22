-- DYNAMIC QUERIES

-- Trigger that updates tables if Member is deleted
CREATE FUNCTION TF_delete_Member_ref() RETURNS TRIGGER AS $$
 BEGIN
 	DELETE FROM Member_In_Tent WHERE OLD.memberID = memberID;
 	DELETE FROM Availability WHERE OLD.memberid = memberID;
 	DELETE FROM Member_Attends_Games WHERE OLD.memberID = memberID;
 	RETURN NEW;
 END;
 $$ LANGUAGE plpgsql;

CREATE TRIGGER TG_delete_Member_ref() RETURNS TRIGGER AS $$
 AFTER DELETE ON Member
 FOR EACH ROW
 EXECUTE PROCEDURE TF_delete_Member_ref();

-- Trigger for updating Member hours logged after
-- update or insert on Availability
CREATE FUNCTION TF_update_hoursLogged_ref() RETURNS TRIGGER AS $$
 BEGIN
 	IF NEW.shift = 't' THEN
		UPDATE Member
		SET hours_logged = hours_logged + 1
		WHERE NEW.memberid = id;
	END IF;
	RETURN NEW;
 END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER TG_update_hoursLogged
AFTER UPDATE ON Availability
FOR EACH ROW
EXECUTE PROCEDURE TF_update_hoursLogged_ref();

-- TRIGGERS

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
