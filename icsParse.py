'''
Created on Apr 14, 2016

@author: Darryl Yan
'''

from icalendar import Calendar
from datetime import datetime, timedelta

"""
Class that contains individual's name
and scheduled events

@param name - Student name
@param times - Dictionary of date-event pairs
"""
class Entry:
    name = ""
    times = {}

    def __init__(self, name):
        self.name = name

    def getName(self):
        return self.name

    def getTimes(self):
        return self.times

    def addEvent(self, date, event):
        if date not in self.times.keys():
            self.times[date] = []
            self.times[date].append(event)
        else:
            self.times[date].append(event)


"""
Function that builds a dictionary out of a list of names
and list of .ics values

@param nameArray: List of names, ordered by input
@param fileArray: List of .ics filenames, ordered by input
"""
def makeDict(nameArray, fileArray):
    dict = {}
    for index in range(len(nameArray)):
        dict[nameArray[index]] = fileArray[index]

    return dict

"""
Function that reads a .ics file and stores information
in a pre-defined Entry object.

@param filename - Filename of .ics file
@param obj - Entry object where the .ics data is stored
"""
def readFile(data, obj):
    fcal = Calendar.from_ical(data)
    for event in fcal.walk('vevent'):
        start = event.decoded('dtstart').replace(tzinfo=None) - timedelta(minutes=25)
        end = event.decoded('dtend').replace(tzinfo=None) + timedelta(minutes=25)

        if start < datetime(2017, 1, 11):
            continue
        if start > datetime(2017, 2, 3):
            break

        time = str(start) + " to " + str(end)

        obj.addEvent(start.date(), time)


"""
Function that creates a dictionary of date-Entry object pairs
from a dictionary of names and filenames.

@param nameDict - Dictionary (key - name, value - .ics filename)
"""
def readFiles(nameDict):
    ret = []
    for name, file in nameDict.items():
        newEntry = Entry(name)
        readFile(file, newEntry)
        ret.append(newEntry)
    return ret