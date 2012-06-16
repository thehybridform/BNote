//
//  AttendantTableViewCell.h
//  BeNote
//
//  Created by Young Kristin on 6/14/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntryCell.h"
#import "Entry.h"

@interface AttendantTableViewCell : UITableViewCell <EntryCell>
@property (assign, nonatomic) Entry *entry;
@property (assign, nonatomic) UIViewController *parentController;

- (id)initWithIdentifier:(NSString *)reuseIdentifier;


@end
