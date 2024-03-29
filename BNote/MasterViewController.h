//
//  MasterViewController.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
#import "TopicEditorViewController.h"

@protocol TopicSelector;

@interface MasterViewController : UITableViewController <TopicEditorDelegate>

@property (strong, nonatomic) IBOutlet UIButton *addTopicButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) id<TopicSelector> listener;

- (IBAction)editTopicCell:(id)sender;
- (void)selectTopicGroup:(TopicGroup *)topicGroup;
- (IBAction)addTopic:(id)sender;

@end

@protocol TopicSelector <NSObject>

- (void)selectedTopic:(Topic *)topic;

@end