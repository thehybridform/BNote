//
//  EntryContentViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@interface EntryContentViewController : UIViewController

@property (assign, nonatomic) UIViewController *parentController;

- (id)initWithEntry:(Entry *)entry;
- (Entry *)entry;
- (UITextView *)mainTextView;
- (UITextView *)detailTextView;
- (UIImageView *)imageView;
- (UIScrollView *)scrollView;
- (CGFloat)height;
- (CGFloat)width;

- (void)handleImageIcon:(BOOL)active;

- (NSString *)detail;

@end
