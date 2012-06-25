//
//  BNoteStringUtils.m
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteStringUtils.h"
#import "Question.h"
#import "ActionItem.h"
#import "KeyPoint.h"
#import "Decision.h"
#import "Attendant.h"
#import "BNoteSessionData.h"

@implementation BNoteStringUtils

+ (NSString *)trim:(NSString *)string
{
    if (string) {
        return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }

    return nil;
}

+ (BOOL)nilOrEmpty:(NSString *)string
{
    if (!string) {
        return YES;
    }
    
    if ([string length] == 0) {
        return YES;
    }
    
    NSString *s = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return s == nil || [s length] == 0;
}

+ (NSString *)nameForEntry:(Entry *)entry
{
    if ([entry isKindOfClass:[ActionItem class]]) {
        return @"Action Item";
    } else if ([entry isKindOfClass:[Attendant class]]) {
        return @"Attendant";
    } else if ([entry isKindOfClass:[Decision class]]) {
        return @"Decision";
    } else if ([entry isKindOfClass:[KeyPoint class]]) {
        return @"Key Point";
    } else if ([entry isKindOfClass:[Question class]]) {
        return @"Question";
    }
    
    return @"Details";
}

+ (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM dd, YYYY"];
    return [format stringFromDate:date];
}

+ (NSString *)timeToString:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"hh:mm aaa"];
    return [format stringFromDate:date];
}

+ (NSString *)formatDate:(NSTimeInterval)interval
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMMM dd, YYYY, hh:mm aaa"];
    return [format stringFromDate:[NSDate dateWithTimeIntervalSinceReferenceDate:interval]];
}

+ (NSString *)append:(NSString *)firstArg, ... NS_REQUIRES_NIL_TERMINATION
{
    NSMutableString *string = [NSMutableString string];

    va_list args;
    va_start(args, firstArg);

    for (NSString *arg = firstArg; arg != nil; arg = va_arg(args, NSString *)) {
        if (arg) {
            [string appendString:arg];
        }
    }

    va_end(args);

    return string;
}

@end
