from sqlalchemy import sql
from app import db

class Tent(db.Model):
    id = db.Column('id', db.Integer, primary_key=True)
    name = db.Column('name', db.String(20))
    color = db.Column('color', db.String(5))
    member = db.relationship('Member_In_Tent')

    def __init__(self, name, color):
        self.name = name
        self.color = color

class Member(db.Model):
    id = db.Column('id', db.Integer, primary_key=True)
    email = db.Column('email', db.String(30))
    name = db.Column('name', db.String(20))
    hours_logged = db.Column('hours_logged', db.Integer)
    games_attended = db.Column('games_attended', db.Integer)
    permissions = db.Column('permissions', db.Boolean)
    tent = db.relationship('Member_In_Tent')
    attends = db.relationship('Member_Attends_Games')

    def __init__(self, name, permissions):
        self.name = name
        self.permissions = permissions
        self.hours_Logged = 0
        self.games_Attended = 0

class Availability(db.Model):
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
    name = db.Column('name', db.String(30), primary_key=True)
    date = db.Column('date', db.String(30))
    time = db.Column('time', db.String(30))
    member = db.relationship('Member_Attends_Games')

class Member_In_Tent(db.Model):
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
