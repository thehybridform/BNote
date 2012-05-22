//
//  NoteEditorViewController.h
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"

@protocol NoteEditorViewControllerDelegate;

@interface NoteEditorViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UIView *subjectView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UITextField *subject;


- (id)initWithNote:(Note *)note andDelegate:(id<NoteEditorViewControllerDelegate>)delegate;
- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@protocol NoteEditorViewControllerDelegate <NSObject>

@required
- (void)didFinish:(NoteEditorViewController *)controller;
- (void)didCancel:(NoteEditorViewController *)controller;


@end
