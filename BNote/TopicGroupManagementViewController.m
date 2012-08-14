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
#import "BNoteStringUtils.h"
#import "TopicGroup.h"
#import "LayerFormater.h"

@interface TopicGroupManagementViewController ()
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UILabel *errorLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIView *footer;
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet TopicGroupsTableViewController *topicGroupsTableViewController;
@property (strong, nonatomic) IBOutlet SelectedTopicsTableViewController *selectedTopicsTableViewController;
@property (strong, nonatomic) TopicGroup *currentTopicGroup;
@property (strong, nonatomic) NSMutableArray *topicGroupNames;
@property (assign, nonatomic) BOOL canDismiss;

@end

@implementation TopicGroupManagementViewController
@synthesize popup = _popup;
@synthesize textLabel = _textLabel;
@synthesize errorLabel = _errorLabel;
@synthesize titleLabel = _titleLabel;
@synthesize nameText = _nameText;
@synthesize topicGroupsTableViewController = _topicGroupsTableViewController;
@synthesize selectedTopicsTableViewController = _selectedTopicsTableViewController;
@synthesize currentTopicGroup = _currentTopicGroup;
@synthesize topicGroupNames = _topicGroupNames;
@synthesize canDismiss = _canDismiss;
@synthesize doneButton = _doneButton;
@synthesize footer = _footer;
@synthesize addButton = _addButton;

static NSString *topicGroupText;
static NSString *doneText;
static NSString *errorText;
static NSString *normalText;
static NSString *newTopicGroupPlaceHolderText;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setTextLabel:nil];
    [self setTitleLabel:nil];
    [self setErrorLabel:nil];
    [self setNameText:nil];
    [self setTopicGroupsTableViewController:nil];
    [self setSelectedTopicsTableViewController:nil];
    [self setDoneButton:nil];
    [self setPopup:nil];
    
    self.addButton = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [self setCanDismiss:YES];
    }
    
    errorText = NSLocalizedString(@"Topic name already exists.", @"Error text for duplicate topic group name.");
    normalText = NSLocalizedString(@"Select Topics for this group.", @"Instruciton to select topic group to be included.");
    topicGroupText = NSLocalizedString(@"Topic Groups", @"Topic groups menu title.");
    newTopicGroupPlaceHolderText = NSLocalizedString(@"New Topic Group Name", @"New topic group name place holder.");
    doneText = NSLocalizedString(@"Done", @"Done");
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self errorLabel] setFont:[BNoteConstants font:RobotoBold andSize:12]];
    [[self titleLabel] setFont:[BNoteConstants font:RobotoBold andSize:15]];
    [[self titleLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    [[self textLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[self textLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    [[self nameText] setFont:[BNoteConstants font:RobotoLight andSize:14]];
    
    [[self topicGroupsTableViewController] setNameText:[self nameText]];
    
    self.titleLabel.text = topicGroupText;
    self.nameText.placeholder = newTopicGroupPlaceHolderText;
    self.textLabel.text = normalText;
    self.errorLabel.text = errorText;
    [self.doneButton setTitle:doneText forState:UIControlStateNormal];
    
    [LayerFormater setBorderWidth:1 forView:[self footer]];
    [LayerFormater setBorderColor:[BNoteConstants darkGray2] forView:self.footer];
    
    TopicGroup *group = [[BNoteReader instance] getTopicGroup:kAllTopicGroupName];
    [[NSNotificationCenter defaultCenter] postNotificationName:kEditTopicGroupSelected object:group];
    
    [self setTopicGroupNames:[[NSMutableArray alloc] init]];
    for (TopicGroup *group in [[BNoteReader instance] allTopicGroups]) {
        [[self topicGroupNames] addObject:[group name]];
    }
    
    [[self errorLabel] setHidden:YES];
    [[self nameText] setDelegate:self];
    
    [LayerFormater addShadowToView:[self footer]];
    
    [[NSNotificationCenter defaultCenter]
        addObserver:self selector:@selector(selectedTopicGroup:) name:kEditTopicGroupSelected object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(updateTopicGroupName:) name:UITextFieldTextDidChangeNotification object:[self nameText]];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(checkTopicGroupName:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kEditTopicGroupSelected object:[self currentTopicGroup]];
}

- (IBAction)add:(id)sender
{
#ifdef LITE
    if ([[[BNoteReader instance] allTopicGroups] count] > kMaxTopicGroups) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"More Topic Groups Not Supported", nil)
                              message:nil
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];

        [alert show];
        return;
    }
#endif
    
    TopicGroup *topicGroup = [BNoteFactory createTopicGroup:@" "];

    [[NSNotificationCenter defaultCenter] postNotificationName:kAddTopicGroupSelected object:topicGroup];
}

- (IBAction)done:(id)sender
{
    [[self popup] dismissPopoverAnimated:YES];
        
    NSMutableArray *emptyTopicGroups = [[NSMutableArray alloc] init];
    for (TopicGroup *group in [[BNoteReader instance] allTopicGroups]) {
        if ([BNoteStringUtils nilOrEmpty:[group name]]) {
            [emptyTopicGroups addObject:group];
        }
    }
    
    [[BNoteWriter instance] removeObjects:emptyTopicGroups];
    
    [[BNoteWriter instance] update];
    
    TopicGroup *group = [[BNoteReader instance] getTopicGroup:[[self currentTopicGroup] name]];

    if (!group) {
        [self setCurrentTopicGroup:[[BNoteReader instance] getTopicGroup:kAllTopicGroupName]];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTopicGroupSelected object:[self currentTopicGroup]];
}

- (void)selectedTopicGroup:(NSNotification *)notification
{
    TopicGroup *group = [notification object];

    if (group) {
        [[BNoteWriter instance] update];

        [self setCurrentTopicGroup:group];

        [[self topicGroupNames] removeAllObjects];
        for (TopicGroup *topicGroup in [[BNoteReader instance] allTopicGroups]) {
            if (topicGroup != group) {
                [[self topicGroupNames] addObject:[topicGroup name]];
            }
        }
    
        [[self nameText] setHidden:NO];
        [[self textLabel] setHidden:NO];
        [[self nameText] setText:[group name]];
    } else {
        [[self nameText] setHidden:YES];
        [[self textLabel] setHidden:YES];
    }
}

- (void)updateTopicGroupName:(NSNotification *)notification
{
    if ([self nameText] == [notification object]) {
        for (NSString *name in [self topicGroupNames]) {
            if ([name isEqualToString:[[self nameText] text]]) {
                [[self doneButton] setHidden:YES];
                [[self textLabel] setHidden:YES];
                [[self errorLabel] setHidden:NO];
                [self setCanDismiss:NO];
                return;
            }
        }
    
        [self setCanDismiss:YES];
        [[self doneButton] setHidden:NO];
        [[self textLabel] setHidden:NO];
        [[self errorLabel] setHidden:YES];
    }
}

- (void)checkTopicGroupName:(NSNotification *)notification
{
    if (![self canDismiss]) {
        NSString *name = [[self nameText] text];
        name = [BNoteStringUtils append:name, @" ", @"Copy", nil];
        [[self nameText] setText:name];
    }
}

- (BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController
{
    return [self canDismiss];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[BNoteSessionData instance] setPopup:nil];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self canDismiss]) {
        [textField resignFirstResponder];
    }
    
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
