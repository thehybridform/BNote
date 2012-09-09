//
//  AttendantsCloner.m
//  BeNote
//
//  Created by Young Kristin on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendantsCloner.h"
#import "BNoteFactory.h"
#import "BNoteImageUtils.h"

@implementation AttendantsCloner

- (Attendants *)clone:(Attendants *)attendants into:(Note *)note
{
    Attendants *copy = [BNoteFactory createAttendants:note];
    
    for (Attendant *child in [attendants children]) {
        Attendant *att = [BNoteFactory createAttendant:copy];
        [att setEmail:[child email]];
        [att setFirstName:[child firstName]];
        [att setLastName:[child lastName]];
        
        if ([child image]) {
            [att setImage:[self copyImage:[child image]]];
        }
    }
    
    return copy;
}

- (NSData *)copyImage:(NSData *)data
{
    UIImage *image = [UIImage imageWithData:data];
    UIImage *copy = [BNoteImageUtils copyImage:image];
    
    return UIImageJPEGRepresentation(copy, 0.8);
}

@end
