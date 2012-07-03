//
//  MasterViewController.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TopicEditorViewController.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <TopicEditorViewControllerListener, UIPopoverControllerDelegate>

@property (strong, nonatomic) DetailViewController *detailViewController;

@end
