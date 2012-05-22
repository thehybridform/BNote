//
//  DetailViewController.h
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteViewController.h"

@class Topic;

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate,
                                                    NoteViewControllerDelegate>

@property (strong, nonatomic) Topic *topic;
@property (strong, nonatomic) IBOutlet UIButton *defaultNoteButton;

@property (strong, nonatomic) IBOutlet UIScrollView *notesScrollView;
@property (strong, nonatomic) IBOutlet UIView *entrySummariesView;

- (IBAction)createNewNote:(id)sender;
- (void)configureView;

@end
