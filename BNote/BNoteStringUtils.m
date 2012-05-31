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
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] == nil;
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



@end
