//
//  DetailViewController.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NotesViewController.h"

@class Topic;

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate, NotesViewControllerListener>

@property (strong, nonatomic) Topic *topic;
@property (strong, nonatomic) IBOutlet UIButton *addNewNoteButton;

@property (strong, nonatomic) IBOutlet NotesViewController *notesViewController;
@property (strong, nonatomic) IBOutlet UIView *entrySummariesView;

- (IBAction)createNewNote:(id)sender;
- (void)configureView:(int)indexPath;

@end
