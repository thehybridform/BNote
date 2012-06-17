//
//  QuickWordsViewController.h
//  BNote
//
//  Created by Young Kristin on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"
#import "EntryTableViewCell.h"

@protocol QuickWordsViewControllerListener;


@interface QuickWordsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *attendantToolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *decisionToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *detailButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *datesButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *keyWordsButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;


@property (assign, nonatomic) id<QuickWordsViewControllerListener> listener;

- (id)initWithCell:(EntryTableViewCell *)cell;

- (IBAction)detail:(id)sender;
- (IBAction)dates:(id)sender;
- (IBAction)keyWords:(id)sender;

- (void)selectFirstButton;

@end

@protocol QuickWordsViewControllerListener <NSObject>

@required

- (UIViewController *)controller;

@end

