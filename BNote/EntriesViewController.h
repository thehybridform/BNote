//
//  EntriesViewController.h
//  BNote
//
//  Created by Young Kristin on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "Entry.h"
#import "EntryReviewViewController.h"

@interface EntriesViewController : UIViewController <EntryReviewViewControllerDelegate, UIActionSheetDelegate>

@property (strong, nonatomic) Note *note;

- (void)update;
- (void)addEntry:(Entry *)entry;
- (void)setupForReviewing;

@end

