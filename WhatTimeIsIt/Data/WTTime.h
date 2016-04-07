//
//  WTTime.h
//  WhatTimeIsIt
//
//  Created by Kevin Bloom on 3/17/16.
//  Copyright © 2016 Kevin Bloom. All rights reserved.
//

#ifndef WTTime_h
#define WTTime_h

#include <sys/time.h>

#define DegToRad(x) (x * (M_PI/180.f))

static CGFloat WTTimeDegreesPerHour = 360.0f/12.0f;
static CGFloat WTTimeDegreesPerMinutes = 360.0f/60.0f;

static dispatch_once_t onceToken;
static NSCalendar* calendar;

struct WTTime {
    int hour;
    int minute;
};
typedef struct WTTime WTTime;

static inline WTTime WTTimeMake(int hour, int minute);

static inline WTTime WTTimeCurrentTime();

static inline WTTime WTTimeRandomTime();

static inline CGFloat WTTimeHourToDegrees(int hour);

static inline CGFloat WTTimeMinutesToDegrees(int minutes);

static inline bool WTTimeEqualsTime(WTTime time1, WTTime time2);

/* Declarations for Inline */
static inline WTTime WTTimeMake(int hour, int minute) {
    WTTime t; t.hour = hour; t.minute = minute; return t;
}

static inline WTTime WTTimeCurrentWithBufferTime(int secondsBuffer) {
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    NSDate* currDate = [NSDate dateWithTimeIntervalSinceNow:secondsBuffer];
    NSDateComponents* currentDateComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:currDate];
    WTTime t;
    t.hour = (int)currentDateComponents.hour;
    t.minute = (int)currentDateComponents.minute;
    return t;
}

static inline WTTime WTTimeRandomTime() {
    dispatch_once(&onceToken, ^{
        calendar = [NSCalendar currentCalendar];
    });
    NSDate* currDate = [NSDate dateWithTimeIntervalSinceNow:arc4random()%3600];
    NSDateComponents* currentDateComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:currDate];
    WTTime t;
    t.hour = (int)currentDateComponents.hour;
    t.minute = (int)currentDateComponents.minute;
    return t;
}

static inline CGFloat WTTimeHourToDegrees(int hour) {
    return -WTTimeDegreesPerHour * (hour % 12);
}

static inline CGFloat WTTimeMinutesToDegrees(int minutes) {
    return -WTTimeDegreesPerMinutes * (minutes % 60);
}

static inline bool WTTimeEqualsTime(WTTime time1, WTTime time2) {
    return time1.hour == time2.hour && time1.minute == time2.minute;
}
#endif /* WTTime_h */
