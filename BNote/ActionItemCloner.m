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
#import "Attendant.h"

@implementation ActionItemCloner

- (ActionItem *)clone:(ActionItem *)actionItem into:(Note *)note
{
    ActionItem *copy = [BNoteFactory createActionItem:note];
    [copy setText:[actionItem text]];
    [copy setDueDate:[actionItem dueDate]];
    
    if (actionItem.attendant) {
        Attendant *attendant = [BNoteFactory createAttendant];
        attendant.firstName = actionItem.attendant.firstName;
        attendant.lastName = actionItem.attendant.lastName;
        attendant.email = actionItem.attendant.email;
        
        copy.attendant = attendant;
    }
    
    [copy setCompleted:[actionItem completed]];
    
    return copy;
}

@end
