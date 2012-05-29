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
#import "QuickWordsViewController.h"

@interface EntriesViewController : UIViewController <EntryReviewViewControllerDelegate, QuickWordsViewControllerListener>

@property (strong, nonatomic) IBOutlet UIView *maskView;
@property (strong, nonatomic) Note *note;

- (void)update;
- (void)addEntry:(Entry *)entry;
- (void)setupForReviewing;
- (void)startEditingEntry:(Entry *)entry;


@end

