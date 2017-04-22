from flask_sqlalchemy import SQLAlchemy
import models

def getAllTents(db):
    '''Returns all Tent tuples in database'''
    return db.session.query(models.Tent).all()

def getTentMembers(db, tid):
    '''Returns list of all Member tuples in a Tent with @tid'''
    members = db.session.execute('SELECT * FROM Member_In_Tent t, Member m WHERE t.tentID = :id AND m.id = t.memberID'
                                , dict(id=tid))
    return [member for member in members]

def getTent(db, tid):
    '''Returns Tent tuple with id = tid'''
    return db.session.query(models.Tent).filter(models.Tent.id == tid).one()

def getMember(db, uid):
    '''Returns Member tuple with id = uid'''
    return db.session.query(models.Member).filter(models.Member.id == uid).one()

def getMemberAttendedGames(db, uid):
    '''Returns list of AttendanceGames tuples that Member attended with id = uid'''
    games = db.session.execute("SELECT * FROM Member_Attends_Games mag, AttendanceGames ag WHERE mag.memberID = :id AND mag.gameName = ag.name",
                                dict(id=uid))
    return [game for game in games]

def getAllMemberAvailabilities(db, uid):
    '''Returns list of Availability tuples for Member with id = uid'''
    data = db.session.execute('SELECT m.name, a.startTime, a.endTime, a.shift FROM Availability a, Member m WHERE a.memberID = :id and m.id = a.memberID',
                                dict(id=uid))
    return [d for d in data]
