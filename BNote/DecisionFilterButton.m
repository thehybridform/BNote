//
//  DecisionFilterButton.m
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import "DecisionFilterButton.h"

@implementation DecisionFilterButton

- (void)execute:(id)sender
{
    id<BNoteFilter> filter = [[BNoteFilterFactory instance] create:DecistionType];
    [[self delegate] useFilter:filter sender:self];
}

@end
