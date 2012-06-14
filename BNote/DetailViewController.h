//
//  DetailViewController.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesViewController.h"
#import "EntrySummariesTableViewController.h"

@class Topic;

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) Topic *topic;

- (IBAction)createNewNote:(id)sender;
- (IBAction)sendEmail:(id)sender;
- (IBAction)help:(id)sender;
- (IBAction)configure:(id)sender;

@end
