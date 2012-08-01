//
//  EntrySummariesTableViewController.h
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
#import "NoteEditorViewController.h"

@interface EntrySummariesTableViewController : UITableViewController

typedef enum {
    None,
    DateAcending,
    DateDecending,
    
    Unknown
} SortType;

@property (assign, nonatomic) Topic *topic;
@property (assign, nonatomic) UIViewController *parentController;

@end
