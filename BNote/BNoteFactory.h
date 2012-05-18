//
//  BNoteFactory.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Topic.h"
#import "Note.h"
#import "Entry.h"

@interface BNoteFactory : NSObject

+ (Topic *)createTopicWithName:(NSString *)name inContext:(NSManagedObjectContext *)context;
+ (Note *)createNoteForTopic:(Topic *)topic inContext:(NSManagedObjectContext *)context;
+ (Entry *)createEntryForNote:(Note *)note inContext:(NSManagedObjectContext *)context;

@end
