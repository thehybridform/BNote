//
//  Photo.h
//  BeNote
//
//  Created by Young Kristin on 6/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class KeyPoint, SketchPaths;

@interface Photo : NSManagedObject

@property (nonatomic) NSTimeInterval created;
@property (nonatomic, retain) NSData * original;
@property (nonatomic, retain) NSData * small;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) KeyPoint *keyPoint;
@property (nonatomic, retain) NSOrderedSet *sketchPaths;
@end

@interface Photo (CoreDataGeneratedAccessors)

- (void)insertObject:(SketchPaths *)value inSketchPathsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSketchPathsAtIndex:(NSUInteger)idx;
- (void)insertSketchPaths:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSketchPathsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSketchPathsAtIndex:(NSUInteger)idx withObject:(SketchPaths *)value;
- (void)replaceSketchPathsAtIndexes:(NSIndexSet *)indexes withSketchPaths:(NSArray *)values;
- (void)addSketchPathsObject:(SketchPaths *)value;
- (void)removeSketchPathsObject:(SketchPaths *)value;
- (void)addSketchPaths:(NSOrderedSet *)values;
- (void)removeSketchPaths:(NSOrderedSet *)values;
@end
