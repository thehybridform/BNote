//
//  ActionItemFilterButton.m
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import "ActionItemFilterButton.h"

@implementation ActionItemFilterButton

- (void)execute:(id)sender
{
    id<BNoteFilter> filter = [[BNoteFilterFactory instance] create:ActionItemType];
    [[self delegate] useFilter:filter sender:self];
}

@end
