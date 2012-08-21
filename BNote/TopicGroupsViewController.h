//
//  TopicGroupsViewController.h
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicGroupSelector.h"

@interface TopicGroupsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UIPopoverController *popup;
@property (strong, nonatomic) id<TopicGroupSelector> delegate;

- (IBAction)newGroup:(id)sender;

@end
