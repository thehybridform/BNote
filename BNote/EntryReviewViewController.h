//
//  EntryReviewViewController.h
//  BNote
//
//  Created by Young Kristin on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@protocol EntryReviewViewControllerDelegate;

@interface EntryReviewViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *textLable;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIView *imageViewParent;
@property (strong, nonatomic) id<EntryReviewViewControllerDelegate> entryReviewViewControllerDelegate;


- (id)initWithEntry:(Entry *)entry;
- (void)setupForReviewing;
- (Entry *)entry;

@end


@protocol EntryReviewViewControllerDelegate <NSObject>

@required
- (void)presentActionSheetForController:(CGRect)rect;
- (void)selectedController;

@end

