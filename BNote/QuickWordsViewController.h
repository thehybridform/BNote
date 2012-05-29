//
//  QuickWordsViewController.h
//  BNote
//
//  Created by Young Kristin on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@protocol QuickWordsViewControllerListener;


@interface QuickWordsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *detailButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *peopleButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *datesButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *keyWordsButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UITextView *targetTextView;

@property (assign, nonatomic) id<QuickWordsViewControllerListener> listener;

- (id)initWithEntry:(Entry *)entry;

- (IBAction)done:(id)sender;
- (IBAction)detail:(id)sender;
- (IBAction)people:(id)sender;
- (IBAction)dates:(id)sender;
- (IBAction)keyWords:(id)sender;

- (void)presentView:(UIView *)parent;
- (void)hideView;

@end

@protocol QuickWordsViewControllerListener <NSObject>

@required

- (void)didFinishFromQuickWords;

@end

