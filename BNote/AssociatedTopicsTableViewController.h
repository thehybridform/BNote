//
//  AssociatedTopicsTableViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "TopicManagementViewController.h"

@interface AssociatedTopicsTableViewController : UITableViewController <UIActionSheetDelegate, TopicManagementViewControllerListener>

@property (assign, nonatomic) Note *note;

@end
