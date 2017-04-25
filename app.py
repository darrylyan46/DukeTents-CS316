from flask import Flask, render_template, redirect, url_for, request, jsonify, flash, session
from flask_sqlalchemy import SQLAlchemy
from icsParse import readFile
import os
import models
import forms
import os
import queries

import httplib2

from apiclient import discovery
from oauth2client import client
from oauth2client.client import HttpAccessTokenRefreshError
from collections import defaultdict
import json



app = Flask(__name__)
app.secret_key = 's3cr3t'
app.config.from_object('config')
db = SQLAlchemy(app, session_options={'autocommit': False})
gcal_API_key = 'AIzaSyADferMigPB2Ch5Pf-Imc5Jvfz0ycZ40Vo'

@app.context_processor
def override_url_for():
    return dict(url_for=dated_url_for)

def dated_url_for(endpoint, **values):
    if endpoint == 'static':
        filename = values.get('filename', None)
        if filename:
            file_path = os.path.join(app.root_path,
                                     endpoint, filename)
            values['q'] = int(os.stat(file_path).st_mtime)
    return url_for(endpoint, **values)

@app.route('/')
def index():
    #some way to say not logged in: try to use session info
    if not session.get('username'):
        return redirect(url_for('login'))
    tid = queries.getIdFromEmail(db, session['username']).tent_id
    return redirect(url_for('tentProfile', tentid=tid))

@app.route('/all_tents')
def all_tents():
    tents = queries.getAllTents(db)
    return render_template('all-tents.html', tents=tents)


@app.route('/googleauth')
def googleauth():
  if 'credentials' not in session:
    return redirect(url_for('oauth2callback'))
  credentials = client.OAuth2Credentials.from_json(session['credentials'])
  if credentials.access_token_expired:
    return redirect(url_for('oauth2callback'))
  else:
      try:
          http_auth = credentials.authorize(httplib2.Http())
          info = discovery.build('people', 'v1', http_auth)
          inventory = info.people().get(resourceName='people/me')
          resp = inventory.execute()
          email = resp['emailAddresses'][0]['value']
          session['username'] = email
          if not db.session.query(db.exists().where(models.Member.email == email)).scalar():
              return redirect(url_for('signup'))
          else:
              tid = queries.getIdFromEmail(db, email).tent_id
              session['uid'] = queries.getMemberFromEmail(db, email).id
              return redirect(url_for('tentProfile', tentid=tid))
      except HttpAccessTokenRefreshError:
          return redirect(url_for('oauth2callback'))

@app.route('/oauth2callback')
def oauth2callback():
  flow = client.flow_from_clientsecrets(
      'client_secrets.json',
      scope='https://www.googleapis.com/auth/plus.login profile email',
      redirect_uri=url_for('oauth2callback', _external=True))
  if 'code' not in request.args:
    auth_uri = flow.step1_get_authorize_url()
    return redirect(auth_uri)
  else:
    auth_code = request.args.get('code')
    credentials = flow.step2_exchange(auth_code)
    session['credentials'] = credentials.to_json()
    return redirect(url_for('googleauth'))

@app.route('/gcalauth')
def gcalauth():
  if 'credentials_cal' not in session:
    return redirect(url_for('cal_callback'))
  credentials = client.OAuth2Credentials.from_json(session['credentials_cal'])
  if credentials.access_token_expired:
    return redirect(url_for('cal_callback'))
  else:
      try:
          http_auth = credentials.authorize(httplib2.Http())
          service = discovery.build('calendar', 'v3', http_auth)
          page_token = None
          events = service.events().list(calendarId='primary', pageToken=page_token).execute()
          uid = session['uid']
          user = queries.getMember(db, uid)
          for event in events['items']:
              start = str(event['start']['dateTime'])
              end = str(event['end']['dateTime'])
              db.session.execute('''INSERT INTO Availability VALUES(:mid, :startTime, :endTime, :bool)'''
                                  , dict(mid=uid, startTime=start, endTime=end, bool=False))
          db.session.commit()
          return redirect(url_for('userProfile', userid=uid))
      except HttpAccessTokenRefreshError:
          return redirect(url_for('cal_callback'))

@app.route('/cal_callback')
def cal_callback():
  flow = client.flow_from_clientsecrets(
      'client_secrets.json',
      scope='https://www.googleapis.com/auth/calendar',
      redirect_uri=url_for('cal_callback', _external=True))
  if 'code' not in request.args:
    auth_uri = flow.step1_get_authorize_url()
    return redirect(auth_uri)
  else:
    auth_code = request.args.get('code')
    credentials = flow.step2_exchange(auth_code)
    session['credentials_cal'] = credentials.to_json()
    return redirect(url_for('gcalauth'))


@app.route('/login', methods=["GET", "POST"])
def login():
    if request.method == "GET":
        if not session.get('username'):
            return render_template('login.html')
        else:
            tid = queries.getIdFromEmail(db, session['username']).tent_id
            return redirect(url_for('tentProfile', tentid=tid))
    else:
        uid = request.form['username']
        if queries.memberExists(db, uid):
            tent = queries.getTentFromUsername(db, uid)
            return redirect(url_for('tentProfile', tentid=tent.tent_id))
        else:
            flash("Please try again.")
            return render_template('login.html')


@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'GET':
        return render_template('signup.html')
    elif request.method == 'POST':
        email = session['username']
        name = request.form['name']
        tent_id = request.form['tentid']
        if request.form.get('captain') == "y":
            permissions = True
        else:
            permissions = False
        tentname = request.form['tentName']
        color = request.form['color']
        uid = queries.insertNewUser(db, email, name, permissions, tent_id, color, tentname)
        tid = queries.getTentFromUsername(db, uid).tent_id
        return redirect(url_for('tentProfile', tentid=tid))

@app.route('/tentProfile/<int:tentid>', methods=['GET', 'POST'])
def tentProfile(tentid):
    tent = queries.getTent(db, tentid)
    members = queries.getTentMembers(db, tentid)
    if request.method == "POST":
        events = request.json["addEvents"]
        for event in events:
            uid = session['uid']
            start = event["start"]
            end_time = event["end"]
            db.session.execute('''INSERT INTO Availability
                                VALUES (:mid, :start_time, :end_time, :bool)''',
                                dict(mid=uid, start_time=start, end_time=end_time, bool=True))
        db.session.commit()
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
                if not queries.checkAvailability(db, userid, startTime, endTime):
                        db.session.execute('''INSERT INTO Availability VALUES(:mid, :startTime, :endTime, :bool)'''
                            , dict(mid=userid, startTime=startTime, endTime=endTime, bool=False))
        db.session.commit()
        flash('Calendar data was successfully uploaded!')
    return render_template('userProfile.html', user=user)

@app.route('/userProfile/<int:userid>/data')
def memberData(userid):
    data = queries.getAllMemberAvailabilities(db, userid)
    return jsonify([dict(d) for d in data])


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
