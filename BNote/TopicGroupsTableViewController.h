//
//  TopicGroupsTableViewController.h
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicGroup.h"

@protocol TopicGroupsTableListener;

@interface TopicGroupsTableViewController : UITableViewController <UITextFieldDelegate>
@property (strong, nonatomic) TopicGroup *selectedTopicGroup;
@property (strong, nonatomic) id<TopicGroupsTableListener> listener;

- (IBAction)add:(id)sender;
- (IBAction)edit:(id)sender;

- (void)selectTopicGroup:(TopicGroup *)topicGroup;

@end

@protocol TopicGroupsTableListener <NSObject>

- (void)selectedTopicGroup:(TopicGroup *)topicGroup;

@end
