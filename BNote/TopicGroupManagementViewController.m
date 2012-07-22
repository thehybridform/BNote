//
//  TopicGroupManagementViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicGroupManagementViewController.h"
#import "SelectedTopicsTableViewController.h"
#import "TopicGroupsTableViewController.h"
#import "BNoteWriter.h"
#import "BNoteReader.h"
#import "BNoteFactory.h"
#import "BNoteSessionData.h"
#import "TopicGroup.h"

@interface TopicGroupManagementViewController ()
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet TopicGroupsTableViewController *topicGroupsTableViewController;
@property (strong, nonatomic) IBOutlet SelectedTopicsTableViewController *selectedTopicsTableViewController;
@property (assign, nonatomic) TopicGroup *currentTopicGroup;

@end

@implementation TopicGroupManagementViewController
@synthesize popup = _popup;
@synthesize textLabel = _textLabel;
@synthesize titleLabel = _titleLabel;
@synthesize nameText = _nameText;
@synthesize topicGroupsTableViewController = _topicGroupsTableViewController;
@synthesize selectedTopicsTableViewController = _selectedTopicsTableViewController;
@synthesize editButton = _editButton;
@synthesize currentTopicGroup = _currentTopicGroup;

- (id)init
{
    self = [super init];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedTopicGroup:) name:EditTopicGroupSelected object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self titleLabel] setFont:[BNoteConstants font:RobotoBold andSize:14]];
    [[self titleLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    [[self textLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[self textLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    [[self nameText] setFont:[BNoteConstants font:RobotoLight andSize:14]];
    
    [[self topicGroupsTableViewController] setNameText:[self nameText]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setTextLabel:nil];
    [self setTitleLabel:nil];
    [self setNameText:nil];
    [self setTopicGroupsTableViewController:nil];
    [self setSelectedTopicsTableViewController:nil];
    [self setEditButton:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)add:(id)sender
{
    TopicGroup *topicGroup = [BNoteFactory createTopicGroup:@"New Topic Group"];

    [[NSNotificationCenter defaultCenter] postNotificationName:AddTopicGroupSelected object:topicGroup];
}

- (IBAction)done:(id)sender
{
    [[self popup] dismissPopoverAnimated:YES];
    [[BNoteWriter instance] update];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicGroupSelected object:[self currentTopicGroup]];
}

- (void)selectedTopicGroup:(NSNotification *)notification
{
    TopicGroup *group = [notification object];
    [self setCurrentTopicGroup:group];
    
    if ([[group name] isEqualToString:@"All"]) {
        [[self nameText] setHidden:YES];
        [[self textLabel] setHidden:YES];
    } else {
        [[self nameText] setHidden:NO];
        [[self textLabel] setHidden:NO];
        [[self nameText] setText:[group name]];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
