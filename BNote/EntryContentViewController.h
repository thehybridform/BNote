//
//  EntryContentViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"
#import "EntryContent.h"

@class QuickWordsViewController;

@interface EntryContentViewController : UIViewController <EntryContent>
@property (strong, nonatomic) QuickWordsViewController *quickWordsViewController;
@property (strong, nonatomic) UITextView *selectedTextView;
@property (strong, nonatomic) Entry *entry;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UITextView *mainTextView;

- (id)initWithEntry:(Entry *)entry;
- (void)handleImageIcon:(BOOL)active;

- (void)hideControls;
- (void)showControls;

@end
