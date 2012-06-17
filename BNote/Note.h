//
//  Note.h
//  BeNote
//
//  Created by Young Kristin on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry, Topic;

@interface Note : NSManagedObject

@property (nonatomic) int32_t color;
@property (nonatomic) NSTimeInterval created;
@property (nonatomic) int32_t index;
@property (nonatomic) NSTimeInterval lastUpdated;
@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSOrderedSet *entries;
@property (nonatomic, retain) Topic *topic;
@property (nonatomic, retain) NSSet *associatedTopics;
@end

@interface Note (CoreDataGeneratedAccessors)

- (void)insertObject:(Entry *)value inEntriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromEntriesAtIndex:(NSUInteger)idx;
- (void)insertEntries:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeEntriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInEntriesAtIndex:(NSUInteger)idx withObject:(Entry *)value;
- (void)replaceEntriesAtIndexes:(NSIndexSet *)indexes withEntries:(NSArray *)values;
- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSOrderedSet *)values;
- (void)removeEntries:(NSOrderedSet *)values;
- (void)addAssociatedTopicsObject:(Topic *)value;
- (void)removeAssociatedTopicsObject:(Topic *)value;
- (void)addAssociatedTopics:(NSSet *)values;
- (void)removeAssociatedTopics:(NSSet *)values;

@end
