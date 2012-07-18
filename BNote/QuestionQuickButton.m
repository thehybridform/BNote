//
//  QuestionQuickButton.m
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionQuickButton.h"
#import "BNoteWriter.h"
#import "QuestionContentViewController.h"

@implementation QuestionQuickButton
@synthesize question = _question;

- (void)execute:(id)sender
{
//    QuestionContentViewController *controller = (QuestionContentViewController *) [self entryContentViewController];
    if ([[self question] answer]) {
        [[self question] setAnswer:nil];
        [self setTitle:@"   Answer   " forState:UIControlStateNormal];
//        [[controller mainTextView] becomeFirstResponder];
//        [controller setSelectedTextView:[controller mainTextView]];
    } else {
        [self setTitle:@"Clear Answer" forState:UIControlStateNormal];
//        [[controller detailTextView] becomeFirstResponder];
//        [controller setSelectedTextView:[controller detailTextView]];
    }
    
//    [controller updateDetail];
}

@end
