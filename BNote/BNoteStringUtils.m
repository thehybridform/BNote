//
//  BNoteStringUtils.m
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

+ (NSString *)dateToString:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, YYYY"];
    return [format stringFromDate:date];
}

+ (NSString *)formatDate:(NSTimeInterval)interval
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, YYYY, hh:mm aaa"];
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

+ (NSString*)ordinalNumberFormat:(NSInteger)num
{
    NSString *ending;
    
    int ones = num % 10;
    int tens = floor(num / 10);
    tens = tens % 10;
    if(tens == 1){
        ending = @"th";
    }else {
        switch (ones) {
            case 1:
                ending = @"st";
                break;
            case 2:
                ending = @"nd";
                break;
            case 3:
                ending = @"rd";
                break;
            default:
                ending = @"th";
                break;
        }
    }
    return [NSString stringWithFormat:@"%d%@", num, ending];
}

+ (NSString *)monthFor:(NSInteger)month
{
    switch (month) {
        case 1:
            return @"JAN";
        case 2:
            return @"FEB";
        case 3:
            return @"MAR";
        case 4:
            return @"APR";
        case 5:
            return @"MAY";
        case 6:
            return @"JUN";
        case 7:
            return @"JUL";
        case 8:
            return @"AUG";
        case 9:
            return @"SEP";
        case 10:
            return @"OCT";
        case 11:
            return @"NOV";
        case 12:
            return @"DEC";
        default:
            return nil;
    }
}

+ (NSString *)guuid
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    CFStringRef guiid = CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    return (__bridge NSString *)(guiid);
}

@end
