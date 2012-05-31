//
//  EntryTableViewCell.h
//  BNote
//
//  Created by Young Kristin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"



@interface EntryTableViewCell : UITableViewCell

@property (strong, nonatomic) Entry *entry;
@property (strong, nonatomic) UITextView *textView;

- (void)edit;
- (void)finishedEdit;

@end

@protocol EntryCellDelegate <NSObject>


@end
