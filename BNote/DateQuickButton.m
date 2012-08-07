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
    UITextView *textView = [[self entryContent] selectedTextView];
    NSRange cursorPosition = [textView selectedRange];
    
    NSString *dateText = [self dateText];
    NSMutableString *text = [[NSMutableString alloc] initWithString:[textView text]];
    [text replaceCharactersInRange:cursorPosition withString:dateText];
    [textView setText:text];

    cursorPosition = NSMakeRange(cursorPosition.location + [dateText length], 0);
    [textView setSelectedRange:cursorPosition];
}

- (NSString *)dateText
{
    NSDate *date = [[[NSDate alloc] init] dateByAddingTimeInterval:[self offset] * 60 * 60 * 24];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@" EEEE MMMM d, YYYY "];
    
    return [dateFormat stringFromDate:date];    
}

@end
