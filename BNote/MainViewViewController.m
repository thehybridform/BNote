//
//  MainViewViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MainViewViewController.h"
#import "LayerFormater.h"
#import "InformationViewController.h"
#import "EntrySummariesTableViewController.h"
#import "MasterViewController.h"
#import "Topic.h"
#import "NotesViewController.h"
#import "Entry.h"
#import "Note.h"
#import "EmailViewController.h"
#import "TopicEditorViewController.h"

@interface MainViewViewController ()
@property (strong, nonatomic) UIPopoverController *popup;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet UIButton *addTopicButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *notesLabel;
@property (strong, nonatomic) IBOutlet UILabel *peopleLabel;
@property (strong, nonatomic) IBOutlet UILabel *countLabel;
@property (strong, nonatomic) IBOutlet UIView *menu;
@property (strong, nonatomic) IBOutlet UIView *topicsView;
@property (strong, nonatomic) IBOutlet UIView *detailView;
@property (strong, nonatomic) IBOutlet MasterViewController *topicsTable;
@property (strong, nonatomic) IBOutlet EntrySummariesTableViewController *entriesTable;
@property (strong, nonatomic) IBOutlet NotesViewController *notesViewController;

@end

@implementation MainViewViewController
@synthesize menu = _menu;
@synthesize topicsTable = _topicsTable;
@synthesize entriesTable = _entriesTable;
@synthesize detailView = _detailView;
@synthesize notesViewController = _notesViewController;
@synthesize countLabel = _countLabel;
@synthesize notesLabel = _notesLabel;
@synthesize peopleLabel = _peopleLabel;
@synthesize topicsView = _topicsView;
@synthesize actionSheet = _actionSheet;
@synthesize shareButton = _shareButton;
@synthesize addTopicButton = _addTopicButton;
@synthesize popup = _popup;
@synthesize titleLabel = _titleLabel;

static NSString *email = @"E-mail";

- (id)initWithDefault
{
    self = [super initWithNibName:@"MainViewViewController" bundle:nil];
    if (self) {
        [[NSNotificationCenter defaultCenter]
            addObserver:self selector:@selector(selectedTopic:) name:TopicSelected object:nil];

        [[NSNotificationCenter defaultCenter]
            addObserver:self selector:@selector(selectedNote:) name:NoteSelected object:nil];
        
        UITapGestureRecognizer *tap =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showNoteOptions:)];
        [[self notesLabel] addGestureRecognizer:tap];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [LayerFormater addShadowToView:[self menu]];
    [LayerFormater addShadowToView:[self detailView]];
    
    [[self notesLabel] setFont:[BNoteConstants font:RobotoBold andSize:20.0]];
    [[self peopleLabel] setFont:[BNoteConstants font:RobotoBold andSize:20.0]];
    [[self countLabel] setFont:[BNoteConstants font:RobotoRegular andSize:15.0]];
    [[self titleLabel] setFont:[BNoteConstants font:RobotoRegular andSize:20.0]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setMenu:nil];
    [self setTopicsTable:nil];
    [self setEntriesTable:nil];
    [self setDetailView:nil];
    [self setNotesViewController:nil];
    [self setCountLabel:nil];
    [self setNotesLabel:nil];
    [self setPeopleLabel:nil];
    [self setTopicsView:nil];
    [self setActionSheet:nil];
    [self setShareButton:nil];
    [self setAddTopicButton:nil];
    [self setPopup:nil];
    [self setTitleLabel:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)selectedTopic:(NSNotification *)notification
{
    Topic *topic = [notification object];
    [[self entriesTable] setTopic:topic];
    [[self notesViewController] setTopic:topic];
    [[self titleLabel] setText:[topic title]];

    NSString *s = [NSString stringWithFormat:@"%d", [[topic notes] count]];
    [[self countLabel] setText:s];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNoteCount:)
                                                 name:TopicUpdated object:topic];
}

- (void)selectedNote:(NSNotification *)notification
{
    Note *note;
    
    NSObject *object = [notification object];
    if ([object isKindOfClass:[Entry class]]) {
        note = [((Entry *)object) note];
    } else {
        note = (Note *)object;
    }
   
    NoteEditorViewController *noteController = [[NoteEditorViewController alloc] initWithNote:note];
    [noteController setModalPresentationStyle:UIModalPresentationFullScreen];
    [noteController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self presentModalViewController:noteController animated:YES];
}

- (void)showNoteOptions:(NSNotification *)notification
{
    
}

- (void)updateNoteCount:(NSNotification *)notification
{
    Topic *topic = [notification object];
    NSString *s = [NSString stringWithFormat:@"%d", [[topic notes] count]];
    [[self countLabel] setText:s];
}

- (IBAction)addTopic:(id)sender
{
    if ([self popup]) {
        [[self popup] dismissPopoverAnimated:YES];
    }
    
    TopicEditorViewController *controller = [[TopicEditorViewController alloc] initWithDefaultNib];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self setPopup:popup];
    [popup setDelegate:self];
    [controller setPopup:popup];
    
    [popup setPopoverContentSize:[[controller view] bounds].size];
    
    UIView *view = [self addTopicButton];
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:YES];
}

- (IBAction)about:(id)sender
{
    InformationViewController *controller = [[InformationViewController alloc] initWithDefault];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:controller animated:YES];
}

- (IBAction)presentShareOptions:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    [actionSheet setDelegate:self];
    
    [actionSheet addButtonWithTitle:email];

    NSInteger index = [actionSheet addButtonWithTitle:@"Cancel"];
    [actionSheet setDestructiveButtonIndex:index];

    [actionSheet setTitle:@"Share Topic"];
    [self setActionSheet:actionSheet];

    CGRect rect = [[self shareButton] bounds];
    [actionSheet showFromRect:rect inView:[self shareButton] animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (title == email) {
            [self presentEmailer];
        }
    }
    
    [self setActionSheet:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setActionSheet:nil];
}

- (void)presentEmailer
{
    EmailViewController *controller = [[EmailViewController alloc] initWithTopic:[[self entriesTable] topic]];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:controller animated:YES];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self setPopup:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
