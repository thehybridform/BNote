//
//  EntryTableCellBasis.h
//  BeNote
//
//  Created by Young Kristin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"
#import "DatePickerViewController.h"

@class EntriesViewController;

@interface EntryTableCellBasis : UITableViewCell

@property (assign, nonatomic) Entry *entry;
@property (strong, nonatomic) UILabel *detail;
@property (strong, nonatomic) UITextView *textView;
@property (assign, nonatomic) UITextView *targetTextView;
@property (assign, nonatomic) EntriesViewController *parentController;

- (id)initWithIdentifier:(NSString *)reuseIdentifier;
- (void)setup;
- (void)unfocus;
- (void)handleImageIcon:(BOOL)active;
- (void)updateDetail;


@end
