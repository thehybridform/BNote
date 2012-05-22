//
//  BNoteWriter.h
//  BNote
//
//  Created by Young Kristin on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"
#import "Note.h"

@interface BNoteWriter : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;

+ (BNoteWriter *)instance;
- (void)removeTopic:(Topic *)topic;
- (void)update;
- (void)removeNote:(Note *)note;


- (id)insertNewObjectForEntityForName:(NSString *)name;


@end
