//
//  Topic.m
//  BeNote
//
//  Created by Young Kristin on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Topic.h"
#import "Note.h"
#import "TopicGroup.h"


@implementation Topic

@dynamic color;
@dynamic created;
@dynamic lastUpdated;
@dynamic title;
@dynamic associatedNotes;
@dynamic groups;
@dynamic notes;
@dynamic relationship;


static NSString *const kItemsKey = @"associatedNotes";

- (void)addAssociatedNotesObject:(Note *)value
{
    NSMutableOrderedSet *tmpOrderedSet =
    [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
    NSUInteger idx = [tmpOrderedSet count];
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
    [tmpOrderedSet addObject:value];
    [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
}

@end
