from flask import Flask, render_template, redirect, url_for, request, jsonify, flash
from flask_sqlalchemy import SQLAlchemy
from icsParse import readFile
import models
import forms
import queries

app = Flask(__name__)
app.secret_key = 's3cr3t'
app.config.from_object('config')
db = SQLAlchemy(app, session_options={'autocommit': False})

@app.route('/')
def all_tents():
    tents = queries.getAllTents(db)
    return render_template('all-tents.html', tents=tents)

@app.route('/login')
def login():
    if request.method == 'GET':
        return render_template('login.html')
    else:
        return render_template('tentProfile.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'GET':
        return render_template('signup.html')
    elif request.method == 'POST':
        name = request.form['username']
        # Check if username is in database already
        tent_id = request.form['tentid']
        isCaptain = request.form['captain']
        permissions = False
        if isCaptain == "Captain":
            tentname = request.form['tentName']
            color = request.form['color']
            newTent = models.Tent(tentname, color)
            db.session.add(newTent)
            permissions = True
        newUser = models.Member(name, permissions)
        db.session.add(newUser)
        db.session.commit()
        return render_template(url_for('userProfile', user=newUser.id))

@app.route('/tentProfile/<int:tentid>')
def tentProfile(tentid, methods=['GET', 'POST']):
    tent = queries.getTent(db, tentid)
    members = queries.getTentMembers(db, tentid)
    return render_template('tentProfile.html', tent=tent, tenters=members)

@app.route('/tentProfile/<int:tentid>/data')
def tentData(tentid):
    data = queries.getTentAvailabilities(db, tentid)
    return jsonify([dict(d) for d in data])

@app.route('/userProfile/<int:userid>', methods=['GET', 'POST'])
def userProfile(userid=None):
    user = queries.getMember(db, userid)
    if request.method == 'POST':
        f = request.files['sched']
        timeDict = readFile(f.read())
        for date in timeDict:
            for startTime, endTime in timeDict[date]:
                try:
                    db.session.execute('INSERT INTO Availability VALUES(:mid, :startTime, :endTime, :bool)',
                                        dict(mid=userid, startTime=startTime, endTime=endTime, bool=False))
                    db.session.commit()
                except Exception as e:
                    db.session.rollback()
                    raise e
        flash('Calendar data was successfully uploaded!')
    return render_template('userProfile.html', user=user)

@app.route('/userProfile/<int:userid>/data')
def memberData(userid):
    data = queries.getAllMemberAvailabilities(db, userid)
    return jsonify([dict(d) for d in data])

@app.template_filter('pluralize')
def pluralize(number, singular='', plural='s'):
    return singular if number in (0, 1) else plural

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
