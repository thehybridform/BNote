//
//  NoteViewController.h
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "NoteEditorViewController.h"

@protocol NoteViewControllerDelegate;

@interface NoteViewController : UIViewController <UIActionSheetDelegate, NoteEditorViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *subject;

- (id)initWithNote:(Note *)note andDelegate:(id<NoteViewControllerDelegate>)delegate;

@end

@protocol NoteViewControllerDelegate <NSObject>


@required
- (void)noteDeleted:(NoteViewController *)controller;
- (void)noteUpdated:(NoteViewController *)controller;

@end

