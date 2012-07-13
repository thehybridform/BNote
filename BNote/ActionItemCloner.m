//
//  ActionItemCloner.m
//  BeNote
//
//  Created by Young Kristin on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActionItemCloner.h"
#import "ActionItem.h"
#import "BNoteFactory.h"

@implementation ActionItemCloner

- (ActionItem *)clone:(ActionItem *)actionItem into:(Note *)note
{
    ActionItem *copy = [BNoteFactory createActionItem:note];
    [copy setText:[actionItem text]];
    [copy setDueDate:[actionItem dueDate]];
    [copy setResponsibility:[actionItem responsibility]];
    [copy setCompleted:[actionItem completed]];
    
    return copy;
}

@end
