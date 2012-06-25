//
//  QuickWordsViewController.h
//  BNote
//
//  Created by Young Kristin on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"
#import "EntryContentViewController.h"

@interface QuickWordsViewController : UIViewController

- (id)initWithCell:(EntryContentViewController *)entryContentController;

- (IBAction)detail:(id)sender;
- (IBAction)dates:(id)sender;
- (IBAction)keyWords:(id)sender;

- (void)selectFirstButton;

@end

