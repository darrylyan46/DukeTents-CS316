from flask import Flask, render_template, redirect, url_for, request, jsonify, session
from flask_sqlalchemy import SQLAlchemy
from icsParse import readFile
import models
import forms
import queries

import httplib2

from apiclient import discovery
from oauth2client import client
from oauth2client.client import HttpAccessTokenRefreshError
import json



app = Flask(__name__)
app.secret_key = 's3cr3t'
app.config.from_object('config')
db = SQLAlchemy(app, session_options={'autocommit': False})

@app.route('/')
def index():
    #some way to say not logged in: try to use session info
    if 'username' not in session or session['username'] is not True:
        return redirect(url_for('login'))

    tentid = queries.getTentFromUsername(db, session['username'])
    tenters = queries.getTentMembers(db, tentid)
    return render_template('tentProfile.html', tent=tentid, tenters=tenters)

@app.route('/alltents')
def alltents():
    return render_template('all-tents.html')


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
          #TODO
          #if this email doesn't exist in the database,
            # insert to create a new member
          session['username'] = email
          #tentid = queries.getTentFromUsername(db, email)
          #test case, Anna -- for some reason, test case does not work.
          # tentid = queries.getTentFromUsername(db,0)
          # tenters = queries.getTentMembers(db, tentid)
          # return render_template('tentProfile.html',tent=tentid,tenters=tenters)
          return redirect(url_for('alltents'))
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

@app.route('/login', methods=['GET','POST'])
def login():
    if request.method == 'GET':
        return render_template('login.html')
    else:
        #iffy..what goes here?
        tentid = queries.getTentFromUsername(db,str(request.form['username']))
        tenters = queries.getTentMembers(db, tentid)
        return render_template('tentProfile.html', tent=tentid, tenters=tenters)

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
def tentProfile(tentid):
    if (tentid == -1):
        return render_template('login.html')
    tent = queries.getTent(db, tentid)
    members = queries.getTentMembers(db, tentid)
    return render_template('tentProfile.html', tent=tent, tenters=members)

@app.route('/tentProfile/<int:tentid>/data')
def tentData(tentid):
    data = queries.getTentAvailabilities(db, tentid)
    return jsonify([dict(d) for d in data])

@app.route('/userProfile/<int:userid>')
def userProfile(userid):
    user = db.session.query(models.Member)\
            .filter(models.Member.id == userid).one()
    if request.method == "POST":
        f = request.form['sched']
        timeDict = readFile(f)
        for date, events in timeDict:
            for event in events:
                newEvent = models.Availability(userid, date, event, False)
                db.session.add(newEvent)
        db.session.commit()
    return render_template('userProfile.html', user=user)

@app.route('/userProfile/<int:userid>/data')
def memberData(userid):
    data = queries.getAllMemberAvailabilities(db, userid)
    return jsonify([dict(d) for d in data])

@app.route('/userProfile/<int:userid>/enterSchedule')
def enterSchedule(userid):
    return

@app.template_filter('pluralize')
def pluralize(number, singular='', plural='s'):
    return singular if number in (0, 1) else plural

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
