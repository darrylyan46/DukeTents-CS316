from flask_sqlalchemy import SQLAlchemy
import models

def getAllTents(db):
    '''Returns all Tent tuples in database'''
    return db.session.query(models.Tent).all()

def getTentMembers(db, tid):
    '''Returns list of all Member tuples in a Tent with @tid'''
    members = db.session.execute("""SELECT *
                                    FROM Member_In_Tent t, Member m
                                    WHERE t.tent_id = :id AND m.id = t.member_id"""
                                , dict(id=tid))
    return [member for member in members]

def getTent(db, tid):
    '''Returns Tent tuple with id = tid'''
    return db.session.query(models.Tent).filter(models.Tent.id == tid).first()

def getTentFromUsername(db, uid):
    '''Returns Tent tuple from User id = uid'''
    tent = db.session.execute("""SELECT * FROM Member_In_Tent WHERE :id = member_id""",
                                   dict(id=uid)).fetchone()
    return tent
def getIdFromEmail(db, email):
    '''Returns tuple of matching Member and Tent from email'''
    uid_result = db.session.execute('''SELECT * FROM Member m, Member_In_Tent t
                                    WHERE m.email = :email AND m.id = t.member_id''',
                                    dict(email=email)).fetchone()
    return uid_result

def getMemberFromEmail(db, email):
    '''Returns tuple of matching Member from email attribute'''
    return db.session.query(models.Member).filter(models.Member.email == email).first()

def checkAvailability(db, mid, startTime, endTime):
    ''' Returns boolean value indicating whether Availability with parameters exist'''
    true_val = db.session.query(db.exists().where(models.Availability.member_id == mid \
                and models.Availability.start_time == startTime \
                and models.Availability.end_time == endTime)).scalar()
    return true_val

def memberExists(db, mid):
    ''' Returns boolean value indicating whether a member with id = :mid exists'''
    return db.session.query(db.exists().where(models.Member.id == mid)).scalar()

def getMember(db, uid):
    '''Returns Member tuple with id = uid'''
    return db.session.query(models.Member).filter(models.Member.id == uid).first()

def getMemberAttendedGames(db, uid):
    '''Returns list of AttendanceGames tuples that Member attended with id = uid'''
    games = db.session.execute("""SELECT *
                                  FROM Member_Attends_Games mag, AttendanceGames ag
                                  WHERE mag.member_id = :id AND mag.game_name = ag.name""",
                                dict(id=uid))
    return [game for game in games]

def getAllMemberAvailabilities(db, uid):
    '''Returns list of Availability tuples for Member with id = uid'''
    data = db.session.execute(""" SELECT m.name, a.start_time, a.end_time, a.shift
                                  FROM Availability a, Member m
                                  WHERE a.member_id = :id AND m.id = a.member_id """,
                                dict(id=uid))
    return [d for d in data]

def getTentAvailabilities(db, tid):
    '''Returns list of Availability for all Members in a tent with id = tid'''
    data = db.session.execute("""SELECT a.member_id, m1.name, a.start_time, a.end_time, a.shift
                                 FROM Availability a, Member_In_Tent m, Member m1
                                 WHERE m.tent_id = :id AND a.member_id = m.member_id AND m1.id = a.member_id""",
                                dict(id=tid))
    return [d for d in data]

def insertAvailabilities(db, avail):
    '''Inserts Availability tuple into the database from Availability object'''
    db.session.execute("""INSERT INTO Availability VALUES (:mid, :start_time, :end_time, :bool)""",
                        dict(mid=avail.member_id, start_time=avail.start_time, end_time=avail.end_time, bool=avail.shift))
    return None

def insertNewUser(db, email, name, permissions, tentid, color, tent_name):
    if permissions:
        try:
            member_id = db.session.execute('''INSERT INTO Member (email, name, hours_logged, games_attended, permissions)
                                        VALUES (:email, :name, 0, 0, :permissions) RETURNING id''',
                                dict(email=email, name=name, permissions=permissions)).fetchone()
            tid = db.session.execute('''INSERT INTO Tent (name, color)
                            VALUES (:tent_name, :color) RETURNING id''',
                            dict(tent_name=tent_name, color=color)).fetchone()
            db.session.execute('''INSERT INTO Member_In_Tent
                                (tent_id, member_id)
                                VALUES (:tid, :mid)''',
                                dict(tid=tid.id, mid=member_id.id))
            db.session.commit()
            return member_id.id
        except Exception as e:
            db.session.rollback()
            raise e
    else:
        try:
            member_id = db.session.execute('''INSERT INTO Member (email, name, hours_logged, games_attended, permissions) VALUES (:email, :name, 0, 0, :permissions) RETURNING id''',
                                dict(email=email, name=name, permissions=permissions)).fetchone()
            db.session.execute('''INSERT INTO Member_In_Tent
                                (tent_id, member_id)
                                VALUES (:tid, :mid)''',
                                dict(tid=tentid, mid=member_id.id))
            db.session.commit()
            return member_id.id
        except Exception as e:
            db.session.rollback()
            raise e
