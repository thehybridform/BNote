//
//  BNoteArchiver.h
//  BeNote
//
//  Created by kristin young on 8/15/12.
//
//

#import <Foundation/Foundation.h>
#import "Topic.h"
#import "TopicGroup.h"
#import "Note.h"

@protocol BNoteArchiver <NSObject>

- (NSString *)displayName;
- (NSString *)helpText;

- (BOOL)archiveTopicGroup:(TopicGroup *)topicGroup;
- (BOOL)archiveTopic:(Topic *)topic;
- (BOOL)archiveNote:(Note *)note;
- (BOOL)archiveAll;

@end
