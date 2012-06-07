//
//  ResponsibilityTableViewController.h
//  BNote
//
//  Created by Young Kristin on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionItem.h"
#import "Attendant.h"

@protocol ResponsibilityTableViewControllerDelegate;

@interface ResponsibilityTableViewController : UITableViewController
@property (assign, nonatomic) id<ResponsibilityTableViewControllerDelegate> delegate;

- (id)initWithEntries:(NSOrderedSet *)entries;

@end

@protocol ResponsibilityTableViewControllerDelegate <NSObject>

- (void)selectedAttendant:(Attendant *)attendant;

@end