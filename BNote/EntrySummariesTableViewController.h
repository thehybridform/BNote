//
//  EntrySummariesTableViewController.h
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
#import "BNoteFilter.h"

@interface EntrySummariesTableViewController : UITableViewController

@property (assign, nonatomic) id<BNoteFilter> filter;

- (id)initWithTopic:(Topic *)topic;
                     
@end
