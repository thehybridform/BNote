//
//  Topic.h
//  BeNote
//
//  Created by kristin young on 8/4/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note, TopicGroup;

@interface Topic : NSManagedObject

@property (nonatomic) int32_t color;
@property (nonatomic) NSTimeInterval created;
@property (nonatomic) NSTimeInterval lastUpdated;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * id;
@property (nonatomic, retain) NSOrderedSet *associatedNotes;
@property (nonatomic, retain) NSOrderedSet *groups;
@property (nonatomic, retain) NSOrderedSet *notes;
@property (nonatomic, retain) NSOrderedSet *relationship;
@end

@interface Topic (CoreDataGeneratedAccessors)

- (void)insertObject:(Note *)value inAssociatedNotesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromAssociatedNotesAtIndex:(NSUInteger)idx;
- (void)insertAssociatedNotes:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeAssociatedNotesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInAssociatedNotesAtIndex:(NSUInteger)idx withObject:(Note *)value;
- (void)replaceAssociatedNotesAtIndexes:(NSIndexSet *)indexes withAssociatedNotes:(NSArray *)values;
- (void)addAssociatedNotesObject:(Note *)value;
- (void)removeAssociatedNotesObject:(Note *)value;
- (void)addAssociatedNotes:(NSOrderedSet *)values;
- (void)removeAssociatedNotes:(NSOrderedSet *)values;
- (void)insertObject:(TopicGroup *)value inGroupsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromGroupsAtIndex:(NSUInteger)idx;
- (void)insertGroups:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeGroupsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInGroupsAtIndex:(NSUInteger)idx withObject:(TopicGroup *)value;
- (void)replaceGroupsAtIndexes:(NSIndexSet *)indexes withGroups:(NSArray *)values;
- (void)addGroupsObject:(TopicGroup *)value;
- (void)removeGroupsObject:(TopicGroup *)value;
- (void)addGroups:(NSOrderedSet *)values;
- (void)removeGroups:(NSOrderedSet *)values;
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
- (void)insertObject:(TopicGroup *)value inRelationshipAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRelationshipAtIndex:(NSUInteger)idx;
- (void)insertRelationship:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRelationshipAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRelationshipAtIndex:(NSUInteger)idx withObject:(TopicGroup *)value;
- (void)replaceRelationshipAtIndexes:(NSIndexSet *)indexes withRelationship:(NSArray *)values;
- (void)addRelationshipObject:(TopicGroup *)value;
- (void)removeRelationshipObject:(TopicGroup *)value;
- (void)addRelationship:(NSOrderedSet *)values;
- (void)removeRelationship:(NSOrderedSet *)values;
@end
