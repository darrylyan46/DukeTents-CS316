from sqlalchemy import sql, orm
from app import db

class Tent(db.Model):
    __tablename__ = 'tent'
    id = db.Column('id', db.Integer, primary_key=True)
    name = db.Column('name', db.String(20))
    color = db.Column('color', db.String(5))
    member = orm.relationship('Member_In_Tent')

    def __init__(self, name, color):
        self.name = name
        self.color = color
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
    email = db.Column('email', db.String(30))
    name = db.Column('name', db.String(20))
    hours_logged = db.Column('hours_logged', db.Integer)
    games_attended = db.Column('games_attended', db.Integer)
    permissions = db.Column('permissions', db.Boolean)
    tent = orm.relationship('Member_In_Tent')
    attends = orm.relationship('Member_Attends_Games')

    def __init__(self, name, permissions):
        self.name = name
        self.permissions = permissions
        self.hours_Logged = 0
        self.games_Attended = 0

class Availability(db.Model):
    __tablename__ = 'availability'
    member_id = db.Column('member_id', db.Integer, db.ForeignKey('member.id'),
                         primary_key=True)
    start_time = db.Column('start_time', db.String(30), primary_key=True)
    end_time = db.Column('end_time', db.String(30), primary_key=True)
    shift = db.Column('shift', db.Boolean)

    def __init__(self, memberID, startTime, endTime, shift=False):
        self.memberID = memberID
        self.startTime = startTime
        self.endTime = endTime
        self.shift = shift

class AttendanceGames(db.Model):
    __tablename__ = 'attendanceGames'
    name = db.Column('name', db.String(30), primary_key=True)
    date = db.Column('date', db.String(30))
    time = db.Column('time', db.String(30))
    member = orm.relationship('Member_Attends_Games')

class Member_In_Tent(db.Model):
    __tablename__ = 'member_in_tent'
    tent_id = db.Column('tent_id', db.Integer, db.ForeignKey('tent.id'),
                       primary_key=True)
    member_id = db.Column('member_id', db.Integer, db.ForeignKey('member.id'),
                         primary_key=True)

class Member_Attends_Games(db.Model):
    __tablename__ = 'member_attends_games'
    member_id = db.Column('member_id', db.Integer, db.ForeignKey('member.id'),
                         primary_key=True)
    game_name = db.Column('game_name', db.String(20), db.ForeignKey('attendanceGames.name'),
                         primary_key=True)
