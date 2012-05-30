//
//  ActionItemMarkDone.m
//  BNote
//
//  Created by Young Kristin on 5/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemMarkDone.h"
#import "BNoteWriter.h"

@implementation ActionItemMarkDone

- (void)execute:(id)sender
{
    if ([[self actionItem] completed]) {
        [[self actionItem] setCompleted:NO]; 
        [self setTitle:@"mark incomplete" forState:UIControlStateNormal];
    } else {
        [[self actionItem] setCompleted:YES]; 
        [self setTitle:@" mark complete " forState:UIControlStateNormal];
    }
    
    [[BNoteWriter instance] update];
}

@end
