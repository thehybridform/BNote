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

@interface NotesViewController : UIViewController

@property (strong, nonatomic) Topic *topic;
@property (assign, nonatomic) UIViewController *detailViewController;

- (void)reload;

@end

