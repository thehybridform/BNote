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
        [[self actionItem] setCompleted:0]; 
        [self setTitle:@" mark complete " forState:UIControlStateNormal];
    } else {
        [[self actionItem] setCompleted:[NSDate timeIntervalSinceReferenceDate]]; 
        [self setTitle:@"mark incomplete" forState:UIControlStateNormal];
    }
    
    [[BNoteWriter instance] update];
}

@end
