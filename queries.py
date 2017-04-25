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
    return db.session.query(models.Tent).filter(models.Tent.id == tid).one()

def getTentFromUsername(db, uid):
    '''Returns Tent tuple from User id = uid'''
    tents = db.session.execute("""SELECT * FROM Member_In_Tent WHERE :id = tent_id""",
                                   dict(id=uid))
    return [tent for tent in tents][0]
def getIdFromEmail(db, email):
    '''Returns integer Tent.id from email'''
    uid_result = db.session.execute('''SELECT t.id FROM Member m, Member_In_Tent t
                                    WHERE m.email = :email AND m.id = t.member_id''')
    return uid_result[0]

def getMember(db, uid):
    '''Returns Member tuple with id = uid'''
    return db.session.query(models.Member).filter(models.Member.id == uid).one()

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
    db.session.execute("""INSERT INTO Availability VALUES(:mid, :start_time, :end_time, :bool)""",
                        dict(mid=avail.member_id, start_time=avail.start_time, end_time=avail.end_time, bool=avail.shift))
    return None

def insertNewUser(db, email, name, permissions, tentid, color, tent_name):
    if permissions:
        try:
            member_id = db.session.execute('''INSERT INTO Member
                                (email, name, hours_logged, games_attended, permissions)
                                VALUE (:email, :name, 0, 0, :permissions) RETURNING id''',
                                dict(email=email, name=name, permissions=permissions))
            tid = db.session.execute('''INSERT INTO Tent
                            (name, color)
                            VALUE (:tent_name, :color) RETURNING id''',
                            dict(tent_name=tent_name, color=color))
            db.session.execute('''INSERT INTO Member_In_Tent
                                (tent_id, member_id)
                                VALUE (:mid, :tid)''',
                                dict(mid=member_id, tid=tid))
            db.session.commit()
            return member_id
        except Exception as e:
            db.session.rollback()
            raise e
    else:
        try:
            member_id = db.session.execute('''INSERT INTO Member
                                (email, name, hours_logged, games_attended, permissions)
                                VALUE (:email, :name, 0, 0, :permissions) RETURNING id''',
                                dict(email=email, name=name, permissions=permissions))
            db.session.execute('''INSERT INTO Member_In_Tent
                                (tent_id, member_id)
                                VALUE (:mid, :tid)''',
                                dict(mid=member_id, tid=tentid))
            db.session.commit()
            return member_id
        except Exception as e:
            db.session.rollback()
            raise e
