//
//  BNoteEntryUtils.m
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteEntryUtils.h"
#import "Entry.h"

@implementation BNoteEntryUtils

+ (Attendant *)findMatch:(Note *)note withFirstName:(NSString *)first andLastName:(NSString *)last
{
    NSEnumerator *entries = [[note entries] objectEnumerator];
    Entry *entry;
    
    while (entry = [entries nextObject]) {
        if ([entry isKindOfClass:[Attendant class]]) {
            Attendant *attendant = (Attendant *) entry;
            if ([[attendant firstName] isEqualToString:first] && [[attendant lastName] isEqualToString:last]) {
                return attendant;
            }
        }
    }
    
    return nil;
}


@end
