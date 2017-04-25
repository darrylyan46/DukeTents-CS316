'''
Created on Apr 14, 2016

@author: Darryl Yan
'''

from icalendar import Calendar
from datetime import datetime, timedelta


def readFile(data):
    """
    Function that reads a .ics file and returns information
    in a dictionary object where the key is the date and the
    value is a list of times.

    @:param filename - Filename of .ics file
    """
    fcal = Calendar.from_ical(data)
    times = {}
    for event in fcal.walk('vevent'):
        start = event.decoded('dtstart').replace(tzinfo=None) - timedelta(minutes=25)
        end = event.decoded('dtend').replace(tzinfo=None) + timedelta(minutes=25)

        #Limit event data that enters the database
        if start < datetime(2017, 1, 11) or start > datetime(2017, 2, 3):
            break

        startTime = str(start).replace(" ", "T")
        endTime = str(start).replace(" ", "T")
        time = (startTime, endTime)

        if start.date() not in times.keys():
            times[start.date()] = []
        times[start.date()].append(time)
    return times
