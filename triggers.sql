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
