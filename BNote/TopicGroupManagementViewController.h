//
//  TopicGroupManagementViewController.h
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicGroupSelector.h"
#import "TopicGroupsTableViewController.h"

@interface TopicGroupManagementViewController : UIViewController <InvalidTopicGroupNameListener>

@property (strong, nonatomic) id<TopicGroupSelector> delegate;
@property (strong, nonatomic) TopicGroup *currentTopicGroup;

- (IBAction)done:(id)sender;

@end


