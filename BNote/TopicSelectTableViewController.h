//
//  TopicSelectTableViewController.h
//  BeNote
//
//  Created by Young Kristin on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@interface TopicSelectTableViewController : UITableViewController
@property (assign, nonatomic) Note *note;

- (void)associate;

@end
