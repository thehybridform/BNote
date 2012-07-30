//
//  BNoteReader.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KeyWord.h"
#import "Topic.h"
#import "TopicGroup.h"

@interface BNoteReader : NSObject

@property (strong, nonatomic) NSManagedObjectContext *context;

+ (BNoteReader *)instance;
- (NSMutableArray *)allTopics;
- (NSMutableArray *)allTopicGroups;
- (NSMutableSet *)allKeyWords;
- (KeyWord *)keyWordFor:(NSString *)word;

- (TopicGroup *)getTopicGroup:(NSString *)name;
- (Topic *)getTopic:(NSString *)name;

- (NSSet *)findNotesWithText:(NSString *)searchText inTopicGroup:(TopicGroup *)group;


@end
