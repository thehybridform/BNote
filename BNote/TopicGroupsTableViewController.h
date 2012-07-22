//
//  TopicGroupsTableViewController.h
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicGroup.h"

@interface TopicGroupsTableViewController : UITableViewController
@property (assign, nonatomic) UITextField *nameText;

- (IBAction)edit:(id)sender;

- (void)selectTopicGroup:(TopicGroup *)group;

@end

