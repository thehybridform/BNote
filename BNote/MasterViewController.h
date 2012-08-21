//
//  MasterViewController.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@protocol TopicSelector;

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) id<TopicSelector> listener;

- (IBAction)editTopicCell:(id)sender;
- (Topic *)searchTopic;

@end

@protocol TopicSelector <NSObject>

- (void)selectedTopic:(Topic *)topic;

@end