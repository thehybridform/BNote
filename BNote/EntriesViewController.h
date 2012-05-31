//
//  EntriesViewController.h
//  BNote
//
//  Created by Young Kristin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "QuickWordsViewController.h"

@interface EntriesViewController : UITableViewController <QuickWordsViewControllerListener>

@property (assign, nonatomic) IBOutlet UITableViewCell *entryCell;
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) Class filter;

- (BOOL)clearSelectedCell;
- (void)reload;
- (void)selectLastCell;

@end
