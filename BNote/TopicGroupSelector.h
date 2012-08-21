//
//  TopicGroupSelector.h
//  BeNote
//
//  Created by kristin young on 8/20/12.
//
//

#import <Foundation/Foundation.h>
#import "TopicGroup.h"

@protocol TopicGroupSelector <NSObject>

- (void)selectTopicGroup:(TopicGroup *)topicGroup;

@end
