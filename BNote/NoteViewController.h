//
//  NoteViewController.h
//  BeNote
//
//  Created by Young Kristin on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NoteEditorViewController.h"

@interface NoteViewController : UIViewController

@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) UIViewController *detailViewController;

- (id)initWithNote:(Note *)note isAssociated:(BOOL)associated;

@end
