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

@interface NotesViewController : UIViewController <UIScrollViewDelegate>

@property (assign, nonatomic) Topic *topic;

- (void)reset;
- (void)reload;
- (IBAction)pageChanged:(id)sender;

@end

