//
//  QuestionFilterButton.m
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import "QuestionFilterButton.h"

@implementation QuestionFilterButton

- (void)execute:(id)sender
{
    id<BNoteFilter> filter = [[BNoteFilterFactory instance] create:QuestionType];
    [[self delegate] useFilter:filter sender:self];
}

@end
