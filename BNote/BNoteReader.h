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
- (NSArray *)allKeyWords;
- (KeyWord *)keyWordFor:(NSString *)word;

- (TopicGroup *)getTopicGroup:(NSString *)name;
- (Topic *)getFilteredTopic;
- (Topic *)getTopicForName:(NSString *)name;

- (NSSet *)findNotesWithText:(NSString *)searchText;

- (NSArray *)topicNames;

@end
