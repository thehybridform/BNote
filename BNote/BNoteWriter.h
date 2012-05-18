//
//  BNoteWriter.h
//  BNote
//
//  Created by Young Kristin on 5/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"

@interface BNoteWriter : NSObject

+ (void)removeTopic:(Topic *)topic inContext:(NSManagedObjectContext *)context;
+ (void)updateContext:(NSManagedObjectContext *)context;

@end
