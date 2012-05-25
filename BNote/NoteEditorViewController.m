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

@interface NoteEditorViewController ()
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) UIColor *toolbarEditColor;
@end

@implementation NoteEditorViewController

@synthesize dateView = _dateView;
@synthesize subjectView = _subjectView;
@synthesize scrollView = _scrollView;
@synthesize date = _date;
@synthesize time = _time;
@synthesize subject = _subject;
@synthesize note = _note;
@synthesize listener = _listener;
@synthesize toolbar = _toolbar;
@synthesize toolbarEditColor = _toolbarEditColor;
@synthesize subjectLable = _subjectLable;
@synthesize entityToolbar = _entityToolbar;
@synthesize keyPointButton = _keyPointButton;
@synthesize questionButton= _questionButton;
@synthesize decisionButton = _decisionButton;
@synthesize actionItemButton = _actionItemButton;
@synthesize modeButton = _modeButton;
@synthesize entriesViewController = _entriesViewController;
@synthesize detailButton = _detailButton;
@synthesize peopleButton = _peopleButton;
@synthesize datesButton = _datesButton;
@synthesize keyWordsButton = _keyWordsButton;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setNote:nil];
    [self setToolbarEditColor:nil];
    [self setDateView:nil];
    [self setSubjectView:nil];
    [self setScrollView:nil];
    [self setDate:nil];
    [self setTime:nil];
    [self setSubject:nil];
    [self setSubjectLable:nil];
    [self setToolbar:nil];
    [self setEntityToolbar:nil];
    [self setKeyPointButton:nil];
    [self setQuestionButton:nil];
    [self setDecisionButton:nil];
    [self setActionItemButton:nil];
    [self setModeButton:nil];
    [self setEntriesViewController:nil];
    [self setListener:nil];
    [self setDetailButton:nil];
    [self setPeopleButton:nil];
    [self setDatesButton:nil];
    [self setKeyWordsButton:nil];
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
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[note created]];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];

    [format setDateFormat:@"MMMM dd, YYYY"];
    NSString *dateString = [format stringFromDate:date];
    
    [format setDateFormat:@"hh:mm aaa"];
    NSString *timeString = [format stringFromDate:date];

    [[self date] setText:dateString];
    [[self time] setText:timeString];
    
    [[self view] setBackgroundColor:UIColorFromRGB([[note topic] color])];
                                    
    [LayerFormater roundCornersForView:[self dateView]];
    [LayerFormater roundCornersForView:[self subjectView]];
    [LayerFormater roundCornersForView:[self scrollView]];
    [LayerFormater roundCornersForView:[self entityToolbar]];
    
    [self setToolbarEditColor:[[self toolbar] tintColor]];
    [[self subjectLable] setHidden:YES];
    
    [[self modeButton] setTitle:@"Add"];
    
    [[self entriesViewController] setNote:note];
    [[self entriesViewController] update];
    
    [[self detailButton] setEnabled:NO];
    [[self peopleButton] setEnabled:NO];
    [[self datesButton] setEnabled:NO];
    [[self keyWordsButton] setEnabled:NO];
}

- (IBAction)done:(id)sender
{
    [[self note] setSubject:[[self subject] text]];
    [[self listener] didFinish];
    [self dismissModalViewControllerAnimated:YES];
    [[self entriesViewController] setupForReviewing];
}

- (IBAction)editMode:(id)sender
{
    UISegmentedControl *control = (UISegmentedControl *)sender;
    
    if ([control selectedSegmentIndex] == 0) {
        [self editing];
    } else {
        [self reviewing];
    }
}

- (void)editing
{
    [[self toolbar] setTintColor:[self toolbarEditColor]];
    [[self entityToolbar] setTintColor:[self toolbarEditColor]];
    [[self subject] setHidden:NO];
    [[self subjectLable] setHidden:YES];
    [[self modeButton] setTitle:@"Add"];
    
    [[self detailButton] setEnabled:YES];
    [[self peopleButton] setEnabled:YES];
    [[self datesButton] setEnabled:YES];
    [[self keyWordsButton] setEnabled:YES];

    [[BNoteSessionData instance] setPhase:Editing];
}

- (void)reviewing
{
    [[self toolbar] setTintColor:[UIColor grayColor]];
    [[self entityToolbar] setTintColor:[UIColor grayColor]];
    [[self subject] setHidden:YES];
    [[self subjectLable] setHidden:NO];
    [[self subjectLable] setText:[[self subject] text]];
    [[self modeButton] setTitle:@"Filter"];
    
    [[self detailButton] setEnabled:NO];
    [[self peopleButton] setEnabled:NO];
    [[self datesButton] setEnabled:NO];
    [[self keyWordsButton] setEnabled:NO];

    [[BNoteSessionData instance] setPhase:Reviewing];
    [[self entriesViewController] setupForReviewing];
}

- (IBAction)addKeyPoint:(id)sender
{
    if ([[BNoteSessionData instance] canEditEntry]) {
        [[self entriesViewController] addEntry:[BNoteFactory createKeyPoint:[self note]]];
    }
}

- (IBAction)addQuestion:(id)sender
{
    if ([[BNoteSessionData instance] canEditEntry]) {
        [[self entriesViewController] addEntry:[BNoteFactory createQuestion:[self note]]];
    }
}

- (IBAction)addDecision:(id)sender
{
    if ([[BNoteSessionData instance] canEditEntry]) {
        [[self entriesViewController] addEntry:[BNoteFactory createDecision:[self note]]];
    }
}

- (IBAction)addActionItem:(id)sender
{
    if ([[BNoteSessionData instance] canEditEntry]) {
        [[self entriesViewController] addEntry:[BNoteFactory createActionItem:[self note]]];
    }
}

- (void)didFinish:(Entry *)entry
{
    [[self entriesViewController] addEntry:entry];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


@end

