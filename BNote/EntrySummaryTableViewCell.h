//
//  EntrySummaryTableViewCell.h
//  BNote
//
//  Created by Young Kristin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@interface EntrySummaryTableViewCell : UITableViewCell

@property (strong, nonatomic) Entry *entry;

- (id)initWithIdentifier:(NSString *)reuseIdentifier;

@end
