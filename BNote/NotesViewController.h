//
//  NoteScrollViewController.h
//  BNote
//
//  Created by Young Kristin on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Topic.h"
#import "NoteView.h"
#import "NoteEditorViewController.h"
#import "EntrySummariesTableViewController.h"

@interface NotesViewController : UIViewController <NoteViewDelegate, NoteEditorViewControllerDelegate>

@property (strong, nonatomic) Topic *topic;
@property (strong, nonatomic) EntrySummariesTableViewController *entrySummariesTableViewController;

- (void)update;

@end

