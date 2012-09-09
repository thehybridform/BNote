//
//  BNoteWriter.m
//  BNote
//
//  Created by Young Kristin on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteWriter.h"
#import "BNoteReader.h"

@interface BNoteWriter()

- (id)initSingleton;

@end

@implementation BNoteWriter
@synthesize context = _context;

- (id)initSingleton
{
    self = [super init];
    
    return self;
}

+ (BNoteWriter *)instance
{
    static BNoteWriter *_default = nil;
    
    if (_default != nil) {
        return _default;
    }
    
    static dispatch_once_t safer;
    dispatch_once(&safer, ^{
        _default = [[BNoteWriter alloc] initSingleton];
    });
    
    return _default;
}

- (void)cleanup
{
    Topic *topic = [[BNoteReader instance] getFilteredTopic];
    [self removeTopic:topic];
}

- (id)insertNewObjectForEntityForName:(NSString *)name
{
    return [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:[self context]];
}

- (void)removeTopic:(Topic *)topic
{
    [self deleteObject:topic];
}

- (void)removeNote:(Note *)note
{
    [self deleteObject:note];
}

- (void)removeEntry:(Entry *)entry
{
    [self deleteObject:entry];
}

- (void)removeAttendant:(Attendant *)attendant
{
    [self deleteObject:attendant];
}

- (void)removePhoto:(Photo *)photo
{
    [self deleteObject:photo];
}

- (void)removeKeyWord:(KeyWord *)keyWord
{
    [self deleteObject:keyWord];
}

- (void)removeObjects:(NSArray *)objects
{
    for (id object in objects) {
        if (object) {
            [[self context] deleteObject:object];
        }
    }
}

- (void)deleteObject:(id)object
{
    if (object) {
        [[self context] deleteObject:object];
    }
}

- (void)moveNote:(Note *)note toTopic:(Topic *)topic
{
    if ([[note associatedTopics] containsObject:topic]) {
        [self disassociateNote:note toTopic:topic];
    }
    
    [note setTopic:topic];
    [note setColor:[topic color]];
}

- (void)associateNote:(Note *)note toTopic:(Topic *)topic
{
    [note addAssociatedTopicsObject:topic];
}

- (void)disassociateNote:(Note *)note toTopic:(Topic *)topic
{
    [note removeAssociatedTopicsObject:topic];
}

- (void)removeSketchPath:(SketchPath *)path
{
    [self deleteObject:path];
}

- (void)removeAllSketchPathFromPhoto:(Photo *)photo
{
    for (SketchPath *path in [photo sketchPaths]) {
        [[self context] deleteObject:path];
    }
}

- (void)updateAttendee:(Attendant *)attendant
{
    BOOL first = [BNoteStringUtils nilOrEmpty:[attendant firstName]];
    BOOL last = [BNoteStringUtils nilOrEmpty:[attendant lastName]];
    BOOL email = [BNoteStringUtils nilOrEmpty:[attendant email]];
    
    if (first && last && email) {
        Attendants *parent = [attendant parent];
        [parent removeChildrenObject:attendant];
    }
}

- (void)update
{
    NSError *error = nil;

    BOOL success = [[self context] save:&error];  
    
    if (error != nil) {
        NSLog(@"Error: %@", error);
    }

    if (!success) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }    
}

// these methods work around an ios 5.1 bug
- (void)moveEntry:(Entry *)entry toIndex:(NSUInteger)index
{
    Note *note = [entry note];
    [note removeEntriesObject:entry];
    [note insertObject:entry inEntriesAtIndex:index];
}

- (void)moveTopic:(Topic *)topic toIndex:(NSUInteger)index inGroup:(TopicGroup *)group
{
    if ([self topic:topic memberOf:group]) {
        [group removeTopicsObject:topic];
        [group insertObject:topic inTopicsAtIndex:index];
        
        [self update];
    }
}

- (BOOL)topic:(Topic *)topic memberOf:(TopicGroup *)group
{
    for (TopicGroup *g in [topic groups]) {
        if (g == group) {
            return YES;
        }
    }
    
    return NO;
}


/*** for the note
 
 
 static NSString *const kItemsKey = @"entries";
 
 - (void)removeEntriesObject:(Entry *)value
 {
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 NSUInteger idx = [tmpOrderedSet indexOfObject:value];
 if (idx != NSNotFound) {
 NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
 [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
 [tmpOrderedSet removeObject:value];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
 }
 }
 
 - (void)insertObject:(Entry *)value inEntriesAtIndex:(NSUInteger)idx
 {
 NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
 [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 [tmpOrderedSet insertObject:value atIndex:idx];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
 }

 
*/


/*** topic group
 
 
 static NSString *const kItemsKey = @"topics";
 
 - (void)addTopicsObject:(Topic *)value;
 {
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 NSUInteger idx = [tmpOrderedSet count];
 NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
 [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
 [tmpOrderedSet addObject:value];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
 }

 
 */

/*
 static NSString *const kItemsKey = @"subitems";
 
 - (void)insertObject:(FRPlaylistItem *)value inSubitemsAtIndex:(NSUInteger)idx {
 NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
 [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 [tmpOrderedSet insertObject:value atIndex:idx];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
 }
 
 - (void)removeObjectFromSubitemsAtIndex:(NSUInteger)idx {
 NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
 [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 [tmpOrderedSet removeObjectAtIndex:idx];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
 }
 
 - (void)insertSubitems:(NSArray *)values atIndexes:(NSIndexSet *)indexes {
 [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 [tmpOrderedSet insertObjects:values atIndexes:indexes];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
 }
 
 - (void)removeSubitemsAtIndexes:(NSIndexSet *)indexes {
 [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 [tmpOrderedSet removeObjectsAtIndexes:indexes];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
 }
 
 - (void)replaceObjectInSubitemsAtIndex:(NSUInteger)idx withObject:(FRPlaylistItem *)value {
 NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
 [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:kItemsKey];
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 [tmpOrderedSet replaceObjectAtIndex:idx withObject:value];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:kItemsKey];
 }
 
 - (void)replaceSubitemsAtIndexes:(NSIndexSet *)indexes withSubitems:(NSArray *)values {
 [self willChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:kItemsKey];
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 [tmpOrderedSet replaceObjectsAtIndexes:indexes withObjects:values];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeReplacement valuesAtIndexes:indexes forKey:kItemsKey];
 }
 
 - (void)addSubitemsObject:(FRPlaylistItem *)value {
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 NSUInteger idx = [tmpOrderedSet count];
 NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
 [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
 [tmpOrderedSet addObject:value];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
 }
 
 - (void)removeSubitemsObject:(FRPlaylistItem *)value {
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 NSUInteger idx = [tmpOrderedSet indexOfObject:value];
 if (idx != NSNotFound) {
 NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
 [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
 [tmpOrderedSet removeObject:value];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
 }
 }
 
 - (void)addSubitems:(NSOrderedSet *)values {
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
 NSUInteger valuesCount = [values count];
 NSUInteger objectsCount = [tmpOrderedSet count];
 for (NSUInteger i = 0; i < valuesCount; ++i) {
 [indexes addIndex:(objectsCount + i)];
 }
 if (valuesCount > 0) {
 [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
 [tmpOrderedSet addObjectsFromArray:[values array]];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
 }
 }
 
 - (void)removeSubitems:(NSOrderedSet *)values {
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 NSMutableIndexSet *indexes = [NSMutableIndexSet indexSet];
 for (id value in values) {
 NSUInteger idx = [tmpOrderedSet indexOfObject:value];
 if (idx != NSNotFound) {
 [indexes addIndex:idx];
 }
 }
 if ([indexes count] > 0) {
 [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
 [tmpOrderedSet removeObjectsAtIndexes:indexes];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
 }
 }
 
 
 
 
 
 static NSString *const kItemsKey = @"children";
 
 - (void)removeChildrenObject:(Attendant *)value
 {
 NSMutableOrderedSet *tmpOrderedSet = [NSMutableOrderedSet orderedSetWithOrderedSet:[self mutableOrderedSetValueForKey:kItemsKey]];
 NSUInteger idx = [tmpOrderedSet indexOfObject:value];
 if (idx != NSNotFound) {
 NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
 [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
 [tmpOrderedSet removeObject:value];
 [self setPrimitiveValue:tmpOrderedSet forKey:kItemsKey];
 [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
 }
 }

 */
@end
