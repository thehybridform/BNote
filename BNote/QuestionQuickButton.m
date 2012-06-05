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
    EntryTableViewCell *cell = [self entryCellView];
    UITextView *subTextView = [cell subTextView];
    Question *question = (Question *) [cell entry];
    
    BOOL answeringQuestion = [[cell textView] isHidden];
    
    if (answeringQuestion) {
        [[cell textView] setHidden:NO];
        [[cell textLabel] setHidden:YES];
        [[cell subTextView] setHidden:YES];
        [cell setTargetTextView:[cell textView]];
        [[cell textView] becomeFirstResponder];
    } else {
        [subTextView setHidden:NO];
        [[cell textLabel] setHidden:YES];
        [[cell textView] setHidden:YES];
        [[self entryCellView] setTargetTextView:subTextView];
        
        UIView *parent = [subTextView superview];
        float x = [parent frame].origin.x + 70;
        float y = [parent frame].origin.y + 10;
        float width = [parent frame].size.width - 20 - 70;
        float height = [parent frame].size.height - 20;
        
        [subTextView setFrame:CGRectMake(x, y, width, height)];
        [subTextView setText:[question answer]];
        [subTextView becomeFirstResponder];
    }
}


@end
