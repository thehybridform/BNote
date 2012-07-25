//
//  Photo.h
//  BeNote
//
//  Created by Young Kristin on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KeyPoint, SketchPath;

@interface Photo : NSManagedObject

@property (nonatomic) NSTimeInterval created;
@property (nonatomic, retain) NSData * original;
@property (nonatomic, retain) NSData * sketch;
@property (nonatomic, retain) NSData * small;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) KeyPoint *keyPoint;
@property (nonatomic, retain) NSOrderedSet *sketchPaths;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)insertObject:(SketchPath *)value inSketchPathsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSketchPathsAtIndex:(NSUInteger)idx;
- (void)insertSketchPaths:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSketchPathsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSketchPathsAtIndex:(NSUInteger)idx withObject:(SketchPath *)value;
- (void)replaceSketchPathsAtIndexes:(NSIndexSet *)indexes withSketchPaths:(NSArray *)values;
- (void)addSketchPathsObject:(SketchPath *)value;
- (void)removeSketchPathsObject:(SketchPath *)value;
- (void)addSketchPaths:(NSOrderedSet *)values;
- (void)removeSketchPaths:(NSOrderedSet *)values;
@end
