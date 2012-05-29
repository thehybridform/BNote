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
@property (strong, nonatomic) IBOutlet UIButton *deleteButton;
@property (strong, nonatomic) IBOutlet UIView *deleteMaskView;
@property (strong, nonatomic) id<EntryReviewViewControllerDelegate> entryReviewViewControllerDelegate;

- (void)storeCurrentTransform;
- (id)initWithEntry:(Entry *)entry;
- (void)setupForReviewing;
- (void)setupForDelete;
- (Entry *)entry;
- (IBAction)deleteEntry:(id)sender;
- (BOOL)isEditingEntry;
- (BOOL)isDeletingEntry;
- (void)startEditing;

@end


@protocol EntryReviewViewControllerDelegate <NSObject>

@required
- (void)selectedController;
- (void)deletedEntry:(EntryReviewViewController *)controller;
- (void)deleteCandidate:(EntryReviewViewController *)controller;
- (void)editCandidate:(EntryReviewViewController *)controller;

@end

