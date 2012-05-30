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

- (void)execute:(id)sender
{
    if ([[self question] answer]) {
        [[self question] setAnswer:nil]; 
        [self setTitle:@"   answer   " forState:UIControlStateNormal];
    } else {
        [[self question] setAnswer:@"bla"]; 
        [self setTitle:@"clear answer" forState:UIControlStateNormal];
    }
    
    [[BNoteWriter instance] update];
}


@end
