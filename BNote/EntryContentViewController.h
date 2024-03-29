//
//  EntryContentViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuickWordsViewControllerActionButtonSource.h"
#import "Entry.h"
#import "EntryContent.h"

@class QuickWordsViewController;

extern float const kDefaultCellHeight;

@interface EntryContentViewController : UIViewController <EntryContent, UITextViewDelegate, QuickWordsViewControllerActionButtonSource>

@property (strong, nonatomic) UITextView *selectedTextView;
@property (strong, nonatomic) Entry *entry;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UITextView *mainTextView;

- (id)initWithEntry:(Entry *)entry;
- (void)handleImageIcon:(BOOL)active;
- (void)resign;

@end
