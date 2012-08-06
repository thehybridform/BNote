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

+ (NSString *)readString:(NSString *)filename;

+ (BNoteReader *)instance;
- (NSMutableArray *)allTopics;
- (NSMutableArray *)allTopicGroups;
- (NSMutableSet *)allKeyWords;
- (KeyWord *)keyWordFor:(NSString *)word;

- (TopicGroup *)getTopicGroup:(NSString *)name;
- (Topic *)getFilteredTopic;

- (NSSet *)findNotesWithText:(NSString *)searchText inTopicGroup:(TopicGroup *)group;


@end
