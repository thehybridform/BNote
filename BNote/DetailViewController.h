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
@property (strong, nonatomic) IBOutlet UIButton *addNewNoteButton;
@property (strong, nonatomic) IBOutlet EntrySummariesTableViewController *tableViewController;
@property (strong, nonatomic) IBOutlet NotesViewController *notesViewController;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;

- (IBAction)createNewNote:(id)sender;
- (void)reload;

@end
