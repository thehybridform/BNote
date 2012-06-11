//
//  Topic.h
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Topic : NSManagedObject

@property (nonatomic) int32_t color;
@property (nonatomic) NSTimeInterval created;
@property (nonatomic) int32_t index;
@property (nonatomic) NSTimeInterval lastUpdated;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *notes;
@end

@interface Topic (CoreDataGeneratedAccessors)

- (void)insertObject:(Note *)value inNotesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromNotesAtIndex:(NSUInteger)idx;
- (void)insertNotes:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeNotesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInNotesAtIndex:(NSUInteger)idx withObject:(Note *)value;
- (void)replaceNotesAtIndexes:(NSIndexSet *)indexes withNotes:(NSArray *)values;
- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSOrderedSet *)values;
- (void)removeNotes:(NSOrderedSet *)values;
@end
