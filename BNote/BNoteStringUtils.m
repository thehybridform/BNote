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

+ (int)lineCount:(NSString *)string
{
    unsigned numberOfLines, index, stringLength = [string length];
    for (index = 0, numberOfLines = 0; index < stringLength; numberOfLines++) {
        index = NSMaxRange([string lineRangeForRange:NSMakeRange(index, 0)]);
    }
    
    return numberOfLines;
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

+ (NSString *)append:(NSArray *)strings
{
    NSString *result = [[NSString alloc] init];
    
    NSEnumerator *items = [strings objectEnumerator];
    NSString *s;
    while (s = [items nextObject]) {
        result = [result stringByAppendingString:s];
    }
    
    return result;
}


@end
