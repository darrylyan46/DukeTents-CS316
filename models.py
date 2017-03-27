from sqlalchemy import sql, orm
from app import db

class Tent(db.Model):
    __tablename__ = 'tent'
    id = db.Column('id', db.Integer, primary_key=True)
    name = db.Column('name', db.String(20))
    color = db.Column('color', db.String(5))
    member = orm.relationship('memberInTent')
    '''
    @staticmethod
    def edit(old_name, name, address, beers_liked, bars_frequented):
        try:
            db.session.execute('DELETE FROM likes WHERE drinker = :name',
                               dict(name=old_name))
            db.session.execute('DELETE FROM frequents WHERE drinker = :name',
                               dict(name=old_name))
            db.session.execute('UPDATE drinker SET name = :name, address = :address'
                               ' WHERE name = :old_name',
                               dict(old_name=old_name, name=name, address=address))
            for beer in beers_liked:
                db.session.execute('INSERT INTO likes VALUES(:drinker, :beer)',
                                   dict(drinker=name, beer=beer))
            for bar, times_a_week in bars_frequented:
                db.session.execute('INSERT INTO frequents'
                                   ' VALUES(:drinker, :bar, :times_a_week)',
                                   dict(drinker=name, bar=bar,
                                        times_a_week=times_a_week))
            db.session.commit()
        except Exception as e:
            db.session.rollback()
            raise e
    '''

class Member(db.Model):
    __tablename__ = 'member'
    id = db.Column('id', db.Integer, primary_key=True)
    name = db.Column('name', db.String(20))
    hoursLogged = db.Column('hoursLogged', db.Integer)
    gamesAttended = db.Column('gamesAttended', db.Integer)
    permissions = db.Column('permissions', db.Boolean)
    tent = orm.relationship('memberInTent')
    attends = orm.relationship('attends')

class Availability(db.Model):
    __tablename__ = 'availability'
    memberID = db.Column('memberID', db.Integer, db.ForeignKey('member.id'),
                         primary_key=True)
    date = db.Column('date', db.String(20), primary_key=True)
    time = db.Column('time', db.String(20), primary_key=True)
    shift = db.Column('shift', db.Boolean)

class AttendanceGames(db.Model):
    __tablename__ = 'attendanceGames'
    name = db.Column('name', db.String(20), primary_key=True)
    date = db.Column('date', db.String(20))
    time = db.Column('time', db.String(20))
    member = orm.relationship('attends')

class MemberInTent(db.Model):
    __tablename__ = 'memberInTent'
    tentID = db.Column('tentID', db.Integer, db.ForeignKey('tent.id'),
                       primary_key=True)
    memberID = db.Column('memberID', db.Integer, db.ForeignKey('member.id'),
                         primary_key=True)

class Attends(db.Model):
    __tablename__ = 'attends'
    memberID = db.Column('memberID', db.Integer, db.ForeignKey('member.id'),
                         primary_key=True)
    gameName = db.Column('gameName', db.String(20), db.ForeignKey('attendanceGames.name'),
                         primary_key=True)
