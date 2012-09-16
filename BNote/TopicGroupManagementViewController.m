//
//  TopicGroupManagementViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicGroupManagementViewController.h"
#import "SelectedTopicsTableViewController.h"
#import "BNoteWriter.h"
#import "BNoteReader.h"
#import "LayerFormater.h"

@interface TopicGroupManagementViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIView *menu;
@property (strong, nonatomic) IBOutlet UIView *footer;
@property (strong, nonatomic) IBOutlet TopicGroupsTableViewController *topicGroupsTableViewController;
@property (strong, nonatomic) IBOutlet SelectedTopicsTableViewController *selectedTopicsTableViewController;

@end

@implementation TopicGroupManagementViewController
@synthesize titleLabel = _titleLabel;
@synthesize topicGroupsTableViewController = _topicGroupsTableViewController;
@synthesize selectedTopicsTableViewController = _selectedTopicsTableViewController;
@synthesize currentTopicGroup = _currentTopicGroup;
@synthesize doneButton = _doneButton;
@synthesize footer = _footer;
@synthesize menu = _menu;
@synthesize delegate = _delegate;

static NSString *kTopicGroupText;
static NSString *kDoneText;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setTitleLabel:nil];
    [self setTopicGroupsTableViewController:nil];
    [self setSelectedTopicsTableViewController:nil];
    [self setDoneButton:nil];
    
    self.menu = nil;
}

- (id)init
{
    self = [super init];
    
    if (self) {
    }
    
    kTopicGroupText = NSLocalizedString(@"Topic Groups", @"Topic groups menu title.");
    kDoneText = NSLocalizedString(@"Done", @"Done");

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[self titleLabel] setFont:[BNoteConstants font:RobotoBold andSize:15]];
    [[self titleLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    
    self.titleLabel.text = kTopicGroupText;
    [self.doneButton setTitle:kDoneText forState:UIControlStateNormal];
    
    [LayerFormater setBorderWidth:1 forView:[self footer]];
    [LayerFormater setBorderColor:[BNoteConstants darkGray2] forView:self.footer];
    [LayerFormater addShadowToView:[self footer]];
    
    [LayerFormater setBorderWidth:1 forView:[self menu]];
    [LayerFormater setBorderColor:[BNoteConstants darkGray] forView:self.menu];
    [LayerFormater addShadowToView:[self menu]];
        
    self.topicGroupsTableViewController.listener = self.selectedTopicsTableViewController;
    self.topicGroupsTableViewController.invalidNameListener = self;
}

- (IBAction)done:(id)sender
{        
    NSMutableArray *emptyTopicGroups = [[NSMutableArray alloc] init];
    for (TopicGroup *group in [[BNoteReader instance] allTopicGroups]) {
        NSString *name = [BNoteStringUtils trim:group.name];
        if ([BNoteStringUtils nilOrEmpty:name]) {
            [emptyTopicGroups addObject:group];
        } else {
            if (![group.name isEqualToString:name]) {
                group.name = name;
            }
        }
    }
    
    [[BNoteWriter instance] removeObjects:emptyTopicGroups];
    
    [[BNoteWriter instance] update];
    
    TopicGroup *group = [[BNoteReader instance] getTopicGroup:self.topicGroupsTableViewController.selectedTopicGroup.name];

    if (!group) {
        group = [[BNoteReader instance] getTopicGroup:kAllTopicGroupName];
    }

    [self.delegate selectTopicGroup:group];
    
    [self dismissModalViewControllerAnimated:YES];
}

- (void)setCurrentTopicGroup:(TopicGroup *)currentTopicGroup
{
    _currentTopicGroup = currentTopicGroup;
    
    [self.topicGroupsTableViewController selectTopicGroup:currentTopicGroup];
}

- (void)invalidName:(BOOL)flag
{
    self.doneButton.hidden = flag;
    self.selectedTopicsTableViewController.view.hidden = flag;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
