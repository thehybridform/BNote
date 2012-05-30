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

- (void)execute:(id)sender
{
    UITextView *textView = [self textView];
    NSRange cursorPosition = [textView selectedRange];
    
    NSMutableString *text = [[NSMutableString alloc] initWithString:[textView text]];
    [text replaceCharactersInRange:cursorPosition withString:[self dateText]];
    [textView setText:text];
}

- (NSString *)dateText
{
    NSDate *date = [[[NSDate alloc] init] dateByAddingTimeInterval:[self offset] * 60 * 60 * 24];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@" EEEE MMMM d, YYYY "];
    
    return [dateFormat stringFromDate:date];    
}

@end
