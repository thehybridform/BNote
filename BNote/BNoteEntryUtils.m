//
//  BNoteEntryUtils.m
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteEntryUtils.h"
#import "BNoteFilterFactory.h"
#import "BNoteFilter.h"
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


+ (NSString *)formatDetailTextForActionItem:(ActionItem *)actionItem
{
    NSString *detailText = @"";
    
    if ([actionItem responsibility]) {
        detailText = [BNoteStringUtils append:@" Responsibility: ", [actionItem responsibility], nil];
    }
    
    if ([actionItem dueDate]) {
        NSDate *dueDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[actionItem dueDate]]; 
        detailText = [BNoteStringUtils append:detailText, @" - Due on ", [BNoteStringUtils dateToString:dueDate], nil];
    }
    
    if ([actionItem completed]) {
        NSDate *completed = [NSDate dateWithTimeIntervalSinceReferenceDate:[actionItem completed]]; 
        detailText = [BNoteStringUtils append:detailText, @" - Completed on ", [BNoteStringUtils dateToString:completed], nil];
    }
        
    return [BNoteStringUtils nilOrEmpty:detailText] ? nil : detailText;
}

+ (NSString *)formatDetailTextForQuestion:(Question *)question
{
    NSString *detailText = [question answer];
    
    return [BNoteStringUtils nilOrEmpty:detailText] ? nil : detailText;
}

+ (BOOL)containsAttendants:(Note *)note
{
    NSEnumerator *entries = [[note entries] objectEnumerator];
    Entry *entry;
    
    while (entry = [entries nextObject]) {
        if ([entry isKindOfClass:[Attendant class]]) {
            return YES;
        }
    }
    
    return NO;
}

+ (NSMutableArray *)attendants:(Note *)note
{
    return [BNoteEntryUtils filter:note with:[BNoteFilterFactory create:AttendantType]];
}

+ (NSMutableArray *)filter:(Note *)note with:(id<BNoteFilter>)filter
{
    NSMutableArray *filtered = [[NSMutableArray alloc] init];
    NSEnumerator *entries = [[note entries] objectEnumerator];
    Entry *entry;
    
    while (entry = [entries nextObject]) {
        if ([filter accept:entry]) {
            [filtered addObject:entry];
        }
    }
    
    return filtered;
}

@end
