Duke Tenting Application

How to use
----------

To run the sample SQL code, 'test-production.sql', have the file in the immediate directory
and run the following code in your virtual machine:

$ dropdb tents; createdb tents; psql tents -af test-production.sql > test-production.out

This will create the database with a sample production set and print the output of
querying the sample dataset. The sample dataset can be found inside the 'test-sample.sql'
file under the comment '-- Begin sample dataset'.

To use the web application, you must have icalendar and google-api-python-client Python packages installed.
To install these packages, use the following commands in your terminal:

$ sudo pip install icalendar
$ sudo pip install google-api-python-client
$ sudo pip install oauth2client

Once this is finished, run app.py from the project directory.

To navigate the webpage, you can either use a pre-existing Google account or
create a new account from scratch. Since the database is populated with a sample
dataset, fill in 3 for the "Existing Tent ID field".

You can view the calendar interface of already-populated availabilities. You can also
drag "Day Shift" and "Night Shift" availabilities, but the shifts do not save permanently.
To upload calendar data, navigate to your name profile and click "Import". You can either
select a iCalendar file (.ics extension) or import from Google Calendar (though you cannot
do this unless you signed up with a Google account). For an calendar file,
use the file 'myevents.ics'.

Make sure to press logout in the top-right corner before closing the application,
as the app will not function otherwise.
