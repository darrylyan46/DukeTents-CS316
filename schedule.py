"""
Created on April 14th, 2017

Author: Darryl Yan
"""

from icalendar import Calendar, Event
from datetime import datetime, time, timedelta
import json

class Slot:
    """
    Object that contains time in UTC format and name of individual
    scheduled for the slot.

    @:param name - Student name
    @:param time - Tent shift (in UTC)
    @:param num - Number of students required
    """
    def __init__(self, time, num):
        self.names = []
        self.time = time
        self.num = num

    def addName(self, name):
        self.names.append(name)

    def getNames(self):
        return self.names

    def getTime(self):
        return self.time

    def getNum(self):
        return self.num

def strToDateTime(str):
    """ Helper function that converts time string into datetime object """
    return datetime.strptime(str, "%Y-%m-%d %H:%M:%S")

def timeToStr(time):
    """ Helper function that converts datetime object into string """
    return time.strftime("%Y-%m-%d %H:%M:%S")

def getStartEnd(timeRange):
    """ Function that returns two-item tuple of start-end times of an event """
    timeList = timeRange.split(" to ")
    return (strToDateTime(timeList[0]), strToDateTime(timeList[1]))

def timeInJS(time):
    strTime = timeToStr(time)
    timeList = strTime.split(' ')
    return timeList[0] + "T" + timeList[1]

def isNight(currentTime):
    """
    Helper function that returns boolean if datetime object is considered
    night time slot.

    @param currentTime - A datetime object
    """
    if currentTime.weekday() <= 2 and currentTime.time() == time(23, 0, 0):
        return True

    if currentTime.weekday() > 2 and currentTime.time() == time(2, 30, 0):
        return True

    return False

def isFree(time1, time2):
    """
    Helper function that returns boolean if two time ranges conflict with
    each other.

    @:param time1 - Time range as a string
    @:param time2 - Time range as a string
    """
    splitOne = time1.split(" to ")
    begOne = strToDateTime(splitOne[0])
    endOne = strToDateTime(splitOne[1])

    splitTwo = time2.split(" to ")
    begTwo = strToDateTime(splitTwo[0])
    endTwo = strToDateTime(splitTwo[1])

    if begOne <= endTwo and endOne >= begTwo:
        return False

    return True

def initSchedule(beg, end, color):
    """
    Function that creates a collection of empty Slot Objects based
    on inputted tent color.

    @:param beg - Datetime object of beginning
    @:param end - Datetime object of end
    @:param color - String that represents tent color.
    """
    slotList = []

    currColor = color
    head = beg
    while head != end:
        num = -1
        if isNight(head):
            if head.weekday() <= 2:
                next = head + timedelta(hours=8)
            elif head.weekday() > 2:
                next = head + timedelta(hours=4, minutes=30)
        else:
            next = head + timedelta(minutes=30)

        if color == 'black':
            if isNight(head):
                num = 10
            else:
                num = 2
        elif color == 'blue':
            if isNight(head):
                num = 6
            else:
                num = 1
        elif color == 'white':
            if isNight(head):
                num = 2
            else:
                num = 1
        else:
            raise ValueError("Invalid color input. Please select a valid color (black, blue, white) and try again")


        lower = timeToStr(head)
        upper = timeToStr(next)
        newTime = lower + " to " + upper
        newSlot = Slot(newTime, num)
        slotList.append(newSlot)

        if next == end:
            if currColor == 'black':
                end = strToDateTime("2017-01-27 23:00:00")
                currColor = 'blue'
            elif currColor == 'blue':
                end = strToDateTime("2017-02-02 23:00:00")
                currColor = 'white'

        head = next

    return slotList


def fill_slots(entryList, slots):
    """
    Helper function that fills in the slots of empty schedule. Does not
    return any values.

    @:param entryList - A list of Entry objects containing student-calendar pairs
    @:param slots - A list of Slot objects
    """
    slotList = []
    for slot in slots:
        shift = slot.getTime()
        num = slot.getNum()
        shiftSplit = shift.split(" to ")
        shiftDate = strToDateTime(shiftSplit[0]).date()

        newSlot = Slot(shift, num)

        for entry in entryList:
            events = entry.getTimes()
            name = entry.getName()

            if shiftDate not in events.keys():
                newSlot.addName(name)
                continue

            else:
                shiftFree = True
                for event in events[shiftDate]:
                    if not isFree(event, shift):
                        shiftFree = False
                        break
                if shiftFree:
                    newSlot.addName(name)
                    continue
        slotList.append(newSlot)

    return slotList


def build_schedule(entryMap, color):
    """
    Function that builds list of all possible schedules from
    available entrant schedules.

    @:param entryMap - Key: Entrant, Value: Schedule
    @:param color - String representing tent color
    """
    colors = ['black', 'blue', 'white']
    assert(color in colors)
    if color == 'black':
        beg = strToDateTime("2017-01-11 23:00:00")
        end = strToDateTime("2017-01-19 23:00:00")

    if color == 'blue':
        beg = strToDateTime("2017-01-19 23:00:00")
        end = strToDateTime("2017-01-27 23:00:00")

    if color == 'white':
        beg = strToDateTime("2017-01-27 23:00:00")
        end = strToDateTime("2017-02-02 23:00:00")

    slots = initSchedule(beg, end, color)
    filledSlots = fill_slots(entryMap, slots)

    return filledSlots

def processData(events):
    """Processes list of events as JSON data for FullCalendar"""
    jsonData = []
    for event in events:
        title = " ".join(event.getNames()) + " (" + str(event.getNum()) + " required)"
        (start, end) = getStartEnd(event.getTime())

        jsonData.append({"title": title, "start": timeInJS(start), "end": timeInJS(end)})
    return json.dumps(jsonData)

def exportCalendar(slots):
    """
    Function that returns an ics file filled with
    tenters who can assume tenting shifts.

    @:param slots - A list of Slot objects
    """
    cal = Calendar()

    for slot in slots:
        event = Event()

        shift = slot.getTime()
        names = slot.getNames()
        num = str(slot.getNum())

        (start, end) = getStartEnd(shift)
        tenters = " ".join(names)

        event.add("summary", "Tent Shift - " + num + " tenters required")
        event.add("dtstart", start)
        event.add("dtend", end)
        event.add("description", tenters)
        cal.add_component(event)

    return cal.to_ical()
