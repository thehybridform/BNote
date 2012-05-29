//
//  NoteScrollViewController.h
//  BNote
//
//  Created by Young Kristin on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "Topic.h"
#import "NoteViewController.h"

@protocol NotesViewControllerListener;

@interface NotesViewController : UIViewController <NoteViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *maskView;
@property (assign, nonatomic) id<NotesViewControllerListener> listener;

- (void)configureView:(Topic *)topic;
- (void)addNote:(Note *)note;

@end

@protocol NotesViewControllerListener <NSObject>

@required
- (void)didFinish;

@end
