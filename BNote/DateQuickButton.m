//
//  DateQuickButton.m
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DateQuickButton.h"

@implementation DateQuickButton

@synthesize offset = _offset;

- (void)execute
{
    NSString *text = [[self textView] text];
    [[self textView] setText:[text stringByAppendingString:[self dateText]]];
}

- (NSString *)dateText
{
    NSDate *date = [[[NSDate alloc] init] dateByAddingTimeInterval:[self offset] * 60 * 60 * 24];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@" EEEE MMMM d, YYYY "];
    
    return [dateFormat stringFromDate:date];    
}

@end
