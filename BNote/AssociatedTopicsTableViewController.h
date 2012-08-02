//
//  AssociatedTopicsTableViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface AssociatedTopicsTableViewController : UITableViewController <UIActionSheetDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) Note *note;

@end
