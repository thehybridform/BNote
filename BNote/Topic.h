//
//  Topic.h
//  BNote
//
//  Created by Young Kristin on 5/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Note;

@interface Topic : NSManagedObject

@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) NSDate * lastUpdated;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * color;
@property (nonatomic, retain) NSNumber * index;
@property (nonatomic, retain) NSSet *notes;
@end

@interface Topic (CoreDataGeneratedAccessors)

- (void)addNotesObject:(Note *)value;
- (void)removeNotesObject:(Note *)value;
- (void)addNotes:(NSSet *)values;
- (void)removeNotes:(NSSet *)values;

@end
