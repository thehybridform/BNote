//
//  MasterViewController.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"

@interface MasterViewController : UITableViewController <UIPopoverControllerDelegate>

- (IBAction)editTopicCell:(id)sender;
- (Topic *)searchTopic;

@end
