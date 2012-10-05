//
//  Attendants.h
//  BeNote
//
//  Created by kristin young on 10/4/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Entry.h"

@class Attendant;

@interface Attendants : Entry

@property (nonatomic, retain) NSOrderedSet *children;
@end

@interface Attendants (CoreDataGeneratedAccessors)

- (void)insertObject:(Attendant *)value inChildrenAtIndex:(NSUInteger)idx;
- (void)removeObjectFromChildrenAtIndex:(NSUInteger)idx;
- (void)insertChildren:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeChildrenAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInChildrenAtIndex:(NSUInteger)idx withObject:(Attendant *)value;
- (void)replaceChildrenAtIndexes:(NSIndexSet *)indexes withChildren:(NSArray *)values;
- (void)addChildrenObject:(Attendant *)value;
- (void)removeChildrenObject:(Attendant *)value;
- (void)addChildren:(NSOrderedSet *)values;
- (void)removeChildren:(NSOrderedSet *)values;
@end
