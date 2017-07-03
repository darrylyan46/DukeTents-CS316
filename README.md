# DukeTents (DB Project for COMPSCI316)
A Flask web applciation that organizes and visualizes calendar data 
from iCalendar files and Google Calendar for the Duke Men's Basketball 
tenting tradition in a user-friendly web-interface.

## Motivation
Planning a schedule for large groups of students of 10-12 for the tenting tradition
is usually done through exhaustive editing of Excel spreadsheets. Our goal was
to provide a user-friendly web interface for processing schedule data and viewing
data within groups.

## Setting Up

To use the application, you will first need to install the necessary dependencies.
DukeTents is built with several Python packages. These packages include:
* flask
* flask_sqlalchemy
* icalendar
* google-api-python-client
* oauth2client

These packages can easily be installed via `pip install <package-name>` or via
[virtual environments](http://python-guide-pt-br.readthedocs.io/en/latest/dev/virtualenvs/)
to organize your project dependencies.

You will also need to have [PostgreSQL](https://www.postgresql.org/) 
on the device you are running the app from, whether it be from 
[Vagrant VirtualBox](https://www.vagrantup.com/) development environment.

#### Database Initialization
In your development environment, run the sample SQL code, 
`test-production.sql` found in the project-directory. 
Have the file in the immediate directory and run the following code 
in your shell:

```
dropdb tents; createdb tents; psql tents -af test-production.sql > test-production.out
```

This will create the database with a sample production set inside the database *tents*
and print the output of querying the sample dataset. The sample dataset can be found inside 
the `test-sample.sql` file under the comment, `-- Begin sample dataset`.

## Usage
Once you have finished setting up, you must edit the file `config.py` to direct to the
location of your database. Once this is done, run `app.py` from the project directory.

To navigate the webpage, you can either use a pre-existing Google account or
create a new account from scratch. Since the database is populated with a sample
dataset, fill in 3 for the "Existing Tent ID field".

You can view the calendar interface of already-populated availabilities. You can also
drag "Day Shift" and "Night Shift" availabilities, but the shifts do not save permanently.
To upload calendar data, navigate to your name profile and click "Import". You can either
select a iCalendar file (.ics extension) or import from Google Calendar (though you cannot
do this unless you signed up with a Google account). For an calendar file,
use the file `myevents.ics`.

Make sure to press logout in the top-right corner before closing the application,
as the app will not function otherwise.

## Built With
* [Flask](http://flask.pocoo.org/) - A Python Microframework
* [SQLAlchemy](https://www.sqlalchemy.org/) - An ORM for Python. See [Flask-SQLAlchemy](http://flask-sqlalchemy.pocoo.org/2.1/) for specifics.
* [PostgreSQL](https://www.postgresql.org/) - An open-source RDBMS.
* [Python 2](https://www.python.org/downloads/), using [`iCalendar`](https://icalendar.readthedocs.io/en/latest/) and `datetime` modules
* HTML/CSS and Javascript

##Authors
* [Darryl Yan](https://github.com/darrylyan46) - primary contributer, full-stack development and SQL
* [Ian Hua](https://github.com/xh47) - SQL
* Joy Kim - OAuth service
* [Linda Zhou](https://github.com/zlindaz) - SQL and front-end
