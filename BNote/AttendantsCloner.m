//
//  AttendantsCloner.m
//  BeNote
//
//  Created by Young Kristin on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendantsCloner.h"
#import "Attendants.h"
#import "Attendant.h"
#import "BNoteFactory.h"

@implementation AttendantsCloner

- (Attendants *)clone:(Attendants *)attendants into:(Note *)note
{
    Attendants *copy = [BNoteFactory createAttendants:note];
    
    for (Attendant *child in [attendants children]) {
        Attendant *att = [BNoteFactory createAttendant:copy];
        [att setEmail:[child email]];
        [att setFirstName:[child firstName]];
        [att setLastName:[child lastName]];
    }
    
    return copy;
}

@end
