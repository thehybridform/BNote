//
//  BNoteStringUtils.m
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteStringUtils.h"

@implementation BNoteStringUtils

+ (NSString *)trim:(NSString *)string
{
    if (string) {
        return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    }

    return nil;
}

+ (BOOL)nilOrEmpty:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] == nil;
}

@end
