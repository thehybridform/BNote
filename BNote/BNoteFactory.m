//
//  BNoteFactory.m
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteFactory.h"
#import "BNoteWriter.h"

@implementation BNoteFactory

+ (Topic *)createTopicWithName:(NSString *)name inContext:(NSManagedObjectContext *)context
{
    Topic *topic = [NSEntityDescription insertNewObjectForEntityForName:@"Topic" inManagedObjectContext:context];
    [topic setCreated:[NSDate date]];
    [topic setLastUpdated:[topic created]];
    [topic setTitle:name];
    [topic setColor:[NSNumber numberWithInt:0xFFFFFF]];
    
    [BNoteWriter updateContext:context];
    
    return topic;
}

+ (Note *)createNoteForTopic:(Topic *)topic inContext:(NSManagedObjectContext *)context
{
    Note *note = [NSEntityDescription insertNewObjectForEntityForName:@"Note" inManagedObjectContext:context];
    [note setCreated:[NSDate date]];
    [note setLastUpdated:[note created]];
    [topic addNotesObject:note];
    
    [BNoteWriter updateContext:context];

    return note;
}

+ (Entry *)createEntryForNote:(Note *)note inContext:(NSManagedObjectContext *)context
{
    Entry *entry = [NSEntityDescription insertNewObjectForEntityForName:@"Entry" inManagedObjectContext:context];
    [entry setCreated:[NSDate date]];
    [entry setLastUpdated:[entry created]];
    [note addEntriesObject:entry];
    
    [BNoteWriter updateContext:context];

    return entry;
}

@end
