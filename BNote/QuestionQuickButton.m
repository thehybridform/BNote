//
//  QuestionQuickButton.m
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionQuickButton.h"
#import "BNoteWriter.h"
@implementation QuestionQuickButton
@synthesize question = _question;
@synthesize textView = _textView;

- (void)execute:(id)sender
{
    [[self textView] setText:@""];
    [[self question] setAnswer:nil];
}

@end
