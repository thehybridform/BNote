//
//  KeyPointFilterButton.m
//  BeNote
//
//  Created by kristin young on 7/29/12.
//
//

#import "KeyPointFilterButton.h"

@implementation KeyPointFilterButton

- (void)execute:(id)sender
{
    id<BNoteFilter> filter = [[BNoteFilterFactory instance] create:KeyPointType];
    [[self delegate] useFilter:filter sender:self];
}

@end
