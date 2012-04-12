//
//  MTHAlarm.m
//  SingMeToSleep
//
//  Created by Mike Hickman on 11/19/11.
//  Copyright (c) 2011 Hobsons. All rights reserved.
//

#import "MTHAlarm.h"

@implementation MTHAlarm
@synthesize active;
@synthesize alarmSoundName;
@synthesize alarmVolumeShouldRise;
@synthesize alarmTime;
@synthesize nextAlarmTime;

-(id)init{
    if(self=[super init]){
        NSNumber *off=[[NSNumber alloc]initWithInt:0];
        activeDays=[[NSMutableArray alloc]initWithObjects:off,off,off,off,off,off,off,off, nil];
        nextAlarmTime=[[NSDate alloc]init];
    }
    return self;
}

-(void)dealloc{
    [activeDays release];
    [alarmSoundName release];
    [nextAlarmTime release];
    
}
-(void)calcNextAlarmTime{
    NSDate *alarm=[[NSDate alloc]init];
   long oneDay=86400;
    for (int i=1; i<8; i++) {
        if([self shouldSetOnDay:i]){
            NSLog(@"today %d",i);
            break;
        }
    }
   // [alarm release];
    
}
-(Boolean)shouldSetOnDay:(WeekDay)day{
    NSCalendar *gregorian = [[[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar]autorelease];
    NSDate *date = [[[NSDate alloc]init]autorelease];
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:date];
    WeekDay today = [weekdayComponents weekday];
    if (today==Saturday) {
        today=Wrap;
    }
    NSDateFormatter *formatter=[[[NSDateFormatter alloc]init]autorelease];
    [formatter setDateFormat:@"HH:mm"];
    NSString *currentTime=[formatter stringFromDate:date];
    int nowTimeSeconds= [self convertStringTimeToIntSeconds:currentTime];
    int alarmTimeSeconds=[self convertStringTimeToIntSeconds:alarmTime];
    
   
    
    if([[activeDays objectAtIndex:day] isEqual:[[NSNumber alloc]initWithInt:1]]){
        if (day>today || (day==today && alarmTimeSeconds>nowTimeSeconds)){
            int daysAdd=0;
            if(today==Wrap){
                daysAdd=7-(today-day);
            }else{
                daysAdd=day-today;
            }
            if (daysAdd>0) {
                
            }
            NSDateComponents *components=[[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit |NSDayCalendarUnit | NSMonthCalendarUnit |NSYearCalendarUnit) fromDate:date];
            NSArray *parts=[alarmTime componentsSeparatedByString:@":"];
            int hours=[[parts objectAtIndex:0]intValue];
            int minutes=[[parts objectAtIndex:1]intValue];
            
            [components setHour:hours];
            [components setMinute:minutes];
            [components setSecond:0];
            NSDate *results=[gregorian dateFromComponents:components];
            [results addTimeInterval:60*60*24*daysAdd];
            [self setNextAlarmTime:results];
            return YES;
        }
    }else {
        return NO;
    }
}
-(Boolean)shouldAlarmSound{
    if(nextAlarmTime && [nextAlarmTime timeIntervalSinceNow]<0){
        NSDateFormatter *formatter=[[[NSDateFormatter alloc]init]autorelease];
        [formatter setDateFormat:@"HH:mm"];
        NSLog(@"time set %@",[formatter stringFromDate:nextAlarmTime]);
        return YES;
    }else {
        return NO;
    }
}
-(void)soundAlarm{
    NSLog(@"alarm");
    
}
-(void)stopAlarm{
    NSLog(@"alarm off");
    
}
-(void)addActiveDay:(WeekDay)day{
    NSNumber *on=[[NSNumber alloc]initWithInt:1];
    [activeDays replaceObjectAtIndex:day withObject:on];
    
}
-(void)removeActiveDay:(WeekDay)day{
    NSNumber *off=[[NSNumber alloc]initWithInt:0];
    [activeDays replaceObjectAtIndex:day withObject:off];
}
-(int)convertStringTimeToIntSeconds:(NSString*)time{
    NSArray *parts=[time componentsSeparatedByString:@":"];
    int hours=[[parts objectAtIndex:0]intValue]*60*60;
    int minutes=[[parts objectAtIndex:1]intValue]*60;
    int seconds=hours+minutes;
    
    return seconds;
}

@end
