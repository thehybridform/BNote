//
//  NoteEditorViewController.m
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoteEditorViewController.h"
#import "LayerFormater.h"
#import "Topic.h"
#import "KeyPoint.h"
#import "Attendant.h"
#import "ActionItem.h"
#import "Question.h"
#import "Decision.h"
#import "BNoteFactory.h"
#import "BNoteSessionData.h"
#import "BNoteWriter.h"

@interface NoteEditorViewController ()
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) UIColor *toolbarEditColor;

@end

@implementation NoteEditorViewController

@synthesize dateView = _dateView;
@synthesize subjectView = _subjectView;
@synthesize date = _date;
@synthesize time = _time;
@synthesize subject = _subject;
@synthesize note = _note;
@synthesize listener = _listener;
@synthesize toolbar = _toolbar;
@synthesize toolbarEditColor = _toolbarEditColor;
@synthesize subjectLable = _subjectLable;
@synthesize entityToolbar = _entityToolbar;
@synthesize participantsButton = _participantsButton;
@synthesize keyPointButton = _keyPointButton;
@synthesize questionButton= _questionButton;
@synthesize decisionButton = _decisionButton;
@synthesize actionItemButton = _actionItemButton;
@synthesize modeButton = _modeButton;
@synthesize editButton = _editButton;
@synthesize entriesViewController = _entriesViewController;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setNote:nil];
    [self setToolbarEditColor:nil];
    [self setDateView:nil];
    [self setSubjectView:nil];
    [self setDate:nil];
    [self setTime:nil];
    [self setSubject:nil];
    [self setSubjectLable:nil];
    [self setToolbar:nil];
    [self setEntityToolbar:nil];
    [self setParticipantsButton:nil];
    [self setKeyPointButton:nil];
    [self setQuestionButton:nil];
    [self setDecisionButton:nil];
    [self setActionItemButton:nil];
    [self setModeButton:nil];
    [self setEditButton:nil];
    [self setEntriesViewController:nil];
    [self setListener:nil];
}


- (id)initWithNote:(Note *)note
{
    self = [super initWithNibName:@"NoteEditorViewController" bundle:nil];
    if (self) {
        [self setNote:note];
        [[BNoteSessionData instance] setPhase:Editing];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Note *note = [self note];
    if ([note subject] && [[note subject] length] > 0) {
        [[self subject] setText:[note subject]];
    } else {
        [[self subject] becomeFirstResponder];
    }

    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[note created]];
    [self setupDateTime:date];
    
    [[self view] setBackgroundColor:UIColorFromRGB([[note topic] color])];
                                    
    [LayerFormater roundCornersForView:[self dateView]];
    [LayerFormater roundCornersForView:[self subjectView]];
    [LayerFormater roundCornersForView:[[self entriesViewController] view]];
    [LayerFormater roundCornersForView:[self entityToolbar]];
    
    [self setToolbarEditColor:[[self toolbar] tintColor]];
    [[self subjectLable] setHidden:YES];
    
    [[self modeButton] setTitle:@"Add"];
    
    [[self entriesViewController] setNote:note];
    
    UITapGestureRecognizer *normalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePicker:)];
    [[self dateView] addGestureRecognizer:normalTap];
}

- (IBAction)done:(id)sender
{
    [[self note] setSubject:[[self subject] text]];
    [[self listener] didFinish];
    [self dismissModalViewControllerAnimated:YES];
    
    [[BNoteWriter instance] update];
}

- (IBAction)editMode:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if ([control selectedSegmentIndex] == 0) {
        [self editing];
        [[self editButton] setEnabled:YES];
    } else {
        [self setupTableViewEditReady];
        [self reviewing];
        [[self editButton] setEnabled:NO];
    }
}

- (void)editing
{
    [[self toolbar] setTintColor:[self toolbarEditColor]];
    [[self entityToolbar] setTintColor:[self toolbarEditColor]];
    [[self subject] setHidden:NO];
    [[self subjectLable] setHidden:YES];
    [[self modeButton] setTitle:@"Add"];
    [[self entriesViewController] setFilter:nil];
    [[self participantsButton] setEnabled:YES];
    
    [[BNoteSessionData instance] setPhase:Editing];
}

- (void)reviewing
{
    [[self toolbar] setTintColor:[UIColor lightGrayColor]];
    [[self entityToolbar] setTintColor:[UIColor lightGrayColor]];
    [[self subject] setHidden:YES];
    [[self subjectLable] setHidden:NO];
    [[self subjectLable] setText:[[self subject] text]];
    [[self modeButton] setTitle:@"Filter"];
    [[self participantsButton] setEnabled:NO];
    
    [[BNoteSessionData instance] setPhase:Reviewing];
}

- (IBAction)addAttendee:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createAttendant:[self note]]];
    }
}

- (IBAction)addKeyPoint:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createKeyPoint:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[KeyPoint class]];
    }
}

- (IBAction)addQuestion:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createQuestion:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[Question class]];
    }
}

- (IBAction)addDecision:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createDecision:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[Decision class]];
    }
}

- (IBAction)addActionItem:(id)sender
{
    if ([[BNoteSessionData instance] phase] == Editing) {
        [self addEntry:[BNoteFactory createActionItem:[self note]]];
    } else {
        [[self entriesViewController] setFilter:[ActionItem class]];
    }
}

- (void)addEntry:(Entry *)entry
{
    [[self entriesViewController] reload];
    [[self entriesViewController] selectLastCell];
}

- (IBAction)editEntries:(id)sender
{
    if ([[self entriesViewController] isEditing]) {
        [self setupTableViewEditReady];
    } else {
        [self setupTableViewForEditing];
    }
}

- (void)setupTableViewEditReady
{
    [[self entriesViewController] setEditing:NO animated:YES]; 
    [[self keyPointButton] setEnabled:YES];
    [[self questionButton] setEnabled:YES];
    [[self decisionButton] setEnabled:YES];
    [[self actionItemButton] setEnabled:YES];
    [[self participantsButton] setEnabled:YES];
    [[self editButton] setTitle:@"Edit"];
}

- (void)setupTableViewForEditing
{
    [[self entriesViewController] clearSelectedCell];
    [[self entriesViewController] setEditing:YES animated:YES]; 
    [[self keyPointButton] setEnabled:NO];
    [[self questionButton] setEnabled:NO];
    [[self decisionButton] setEnabled:NO];
    [[self actionItemButton] setEnabled:NO];
    [[self participantsButton] setEnabled:NO];
    [[self editButton] setTitle:@"Done"];
}

- (void)showDatePicker:(id)sender
{
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[[self note] created]];

    DatePickerViewController *controller = [[DatePickerViewController alloc] initWithDate:date];
    [[controller view] setBackgroundColor:[[self view] backgroundColor]];
    [controller setListener:self];
    [controller setModalPresentationStyle:UIModalPresentationCurrentContext];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [[self entriesViewController] presentModalViewController:controller animated:YES];
}

- (void)dateTimeUpdated:(NSDate *)date
{
    [[self note] setCreated:[date timeIntervalSinceReferenceDate]];
    [self setupDateTime:date];
}

- (void)setupDateTime:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"MMMM dd, YYYY"];
    NSString *dateString = [format stringFromDate:date];
    
    [format setDateFormat:@"hh:mm aaa"];
    NSString *timeString = [format stringFromDate:date];
    
    [[self date] setText:dateString];
    [[self time] setText:timeString];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end

