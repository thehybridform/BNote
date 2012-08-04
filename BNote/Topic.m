//
//  Topic.m
//  BeNote
//
//  Created by kristin young on 8/4/12.
//
//

#import "Topic.h"
#import "Note.h"
#import "TopicGroup.h"


@implementation Topic

@dynamic color;
@dynamic created;
@dynamic lastUpdated;
@dynamic title;
@dynamic id;
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
