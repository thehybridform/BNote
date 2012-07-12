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

@property (assign, nonatomic) Topic *topic;

- (void)reload;

@end

