//
//  NoteEditorViewController.h
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Note.h"
#import "EntriesViewController.h"
#import "AttendantsViewController.h"
#import "DatePickerViewController.h"


@protocol NoteEditorViewControllerDelegate;

@interface NoteEditorViewController : UIViewController <DatePickerViewControllerListener, ABPeoplePickerNavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *dateView;
@property (strong, nonatomic) IBOutlet UIView *subjectView;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UITextField *subject;
@property (strong, nonatomic) IBOutlet UILabel *subjectLable;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *entityToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *keyPointButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *questionButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *decisionButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionItemButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *modeButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *trashButton;
@property (strong, nonatomic) IBOutlet UIImageView *attendantsImageView;
@property (strong, nonatomic) IBOutlet UIScrollView *attendantsScrollView;


@property (strong, nonatomic) IBOutlet EntriesViewController *entriesViewController;
@property (strong, nonatomic) IBOutlet AttendantsViewController *attendantsViewController;
@property (assign, nonatomic) id<NoteEditorViewControllerDelegate> delegate;

- (id)initWithNote:(Note *)note;
- (IBAction)done:(id)sender;
- (IBAction)editMode:(id)sender;

- (IBAction)addAttendee:(id)sender;
- (IBAction)addKeyPoint:(id)sender;
- (IBAction)addQuestion:(id)sender;
- (IBAction)addDecision:(id)sender;
- (IBAction)addActionItem:(id)sender;
- (IBAction)editEntries:(id)sender;

@end

@protocol NoteEditorViewControllerDelegate <NSObject>

@required
- (void)didFinishEditingNote:(Note *)note;


@end
