//
//  EntryTableViewCell.h
//  BNote
//
//  Created by Young Kristin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"
#import "EntryCell.h"

@class EntriesViewController;

@interface EntryTableViewCell : UITableViewCell <EntryCell, UIActionSheetDelegate>

@property (strong, nonatomic) Entry *entry;
@property (strong, nonatomic) UITextView *textView;
@property (assign, nonatomic) UITextView *targetTextView;
@property (strong, nonatomic) UITextView *subTextView;
@property (assign, nonatomic) EntriesViewController *parentController;

- (id)initWithIdentifier:(NSString *)reuseIdentifier;

+ (int)cellHieght:(Entry *)entry;

@end

