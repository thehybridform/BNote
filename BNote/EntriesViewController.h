//
//  EntriesViewController.h
//  BNote
//
//  Created by Young Kristin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "BNoteFilter.h"

@interface EntriesViewController : UITableViewController

@property (assign, nonatomic) IBOutlet UITableViewCell *entryCell;
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) id<BNoteFilter> filter;
@property (assign, nonatomic) UIViewController *parentController;

- (void)reload;
- (void)selectLastCell;
- (void)selectFirstCell;
- (void)selectEntry:(Entry *)entry;

@end
