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

@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) id<BNoteFilter> filter;

- (void)addAndSelectLastEntry:(Entry *)entry;
- (void)selectFirstCell;
- (void)selectEntry:(Entry *)entry;
- (void)resignControll;
- (void)displaySummary;
- (BOOL)showingSummary;

@end
