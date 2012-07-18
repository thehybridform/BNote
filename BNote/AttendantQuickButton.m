//
//  AttendantQuickButton.m
//  BeNote
//
//  Created by Young Kristin on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendantQuickButton.h"

@implementation AttendantQuickButton
@synthesize attendant = _attendant;

- (void)execute:(id)sender
{
    UITextView *textView = [[self entryContent] selectedTextView];
    NSRange cursorPosition = [textView selectedRange];
    
    NSString *keyWord = [BNoteStringUtils append:@" ", [[self titleLabel] text], @" ", nil];
    
    NSMutableString *text = [[NSMutableString alloc] initWithString:[textView text]];
    [text replaceCharactersInRange:cursorPosition withString:keyWord];
    [textView setText:text];
}

@end
