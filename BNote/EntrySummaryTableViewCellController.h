//
//  EntrySummaryTableViewCellController.h
//  BeNote
//
//  Created by Young Kristin on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Entry.h"

@interface EntrySummaryTableViewCellController : UIViewController

- (id)initWithEntry:(Entry *)entry;

- (UITableViewCell *)cell;

@end
