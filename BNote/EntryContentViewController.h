//
//  EntryContentViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@class QuickWordsViewController;

@interface EntryContentViewController : UIViewController
@property (assign, nonatomic) UIViewController *parentController;
@property (strong, nonatomic) QuickWordsViewController *quickWordsViewController;
@property (assign, nonatomic) UITextView *selectedTextView;

- (id)initWithEntry:(Entry *)entry;
- (Entry *)entry;
- (UITextView *)mainTextView;
- (UITextView *)detailTextView;
- (UIImageView *)imageView;
- (UIScrollView *)scrollView;
- (CGFloat)height;

- (void)handleImageIcon:(BOOL)active;

- (void)showMainText;
- (void)showDetailText;
- (NSString *)detail;

- (void)startedEditingText:(NSNotification *)notification;

- (void)updateDetail;

- (UITableViewCell *)cell;

@end
