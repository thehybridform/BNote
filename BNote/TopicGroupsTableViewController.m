//
//  TopicGroupsTableViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicGroupsTableViewController.h"
#import "BNoteReader.h"
#import "BNoteWriter.h"
#import "LayerFormater.h"
#import "BNoteFactory.h"

@interface TopicGroupsTableViewController ()
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UITextField *nameText;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) UILabel *selectedCellLabel;
@property (assign, nonatomic) BOOL invalidName;

@end

@implementation TopicGroupsTableViewController
@synthesize data = _data;
@synthesize nameText = _nameText;
@synthesize selectedTopicGroup = _selectedTopicGroup;
@synthesize editButton = _editButton;
@synthesize listener = _listener;
@synthesize addButton = _addButton;
@synthesize textLabel = _textLabel;
@synthesize selectedCellLabel = _selectedCellLabel;
@synthesize invalidNameListener = _invalidNameListener;
@synthesize invalidName = _invalidName;

static NSString *kEditText;
static NSString *kNewTopicGroupPlaceHolderText;
static NSString *kNormalText;
static NSString *kTopicGroupExists;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self refreshTopicGroupData];
    }
    
    kEditText = NSLocalizedString(@"Edit", @"Edit");
    kNewTopicGroupPlaceHolderText = NSLocalizedString(@"New Topic Group Name", @"New topic group name place holder.");
    kNormalText = NSLocalizedString(@"Select Topics for this group.", @"Instruciton to select topic group to be included.");
    kTopicGroupExists = NSLocalizedString(@"Topic Group name already exists.", @"Topic Group name already exists.");

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.nameText.hidden = YES;
    self.textLabel.hidden = YES;
    [self.listener selectedTopicGroup:nil];

    [self.editButton setTitle:kEditText forState:UIControlStateNormal];
    
    [LayerFormater setBorderWidth:1 forView:self.view];
    [LayerFormater setBorderColor:[BNoteConstants darkGray] forView:self.view];
    
    [[self nameText] setFont:[BNoteConstants font:RobotoLight andSize:14]];
    self.nameText.placeholder = kNewTopicGroupPlaceHolderText;
    self.nameText.delegate = self;

    self.textLabel.text = kNormalText;
    [[self textLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[self textLabel] setTextColor:[BNoteConstants appHighlightColor1]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTopicGroupName:) name:UITextFieldTextDidChangeNotification object:self.nameText];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setEditButton:nil];
    self.addButton = nil;
    [self setNameText:nil];
    [self setTextLabel:nil];
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
    
    int index = self.data.count;
    
    TopicGroup *topicGroup = [BNoteFactory createTopicGroup:@""];
    [self.data addObject:topicGroup];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    [self selectCell:index];
    
    [[self nameText] becomeFirstResponder];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self data] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.textColor = [BNoteConstants appHighlightColor1];
        [[cell textLabel] setFont:[BNoteConstants font:RobotoLight andSize:15]];
        [cell setSelectedBackgroundView:[BNoteFactory createHighlight:[BNoteConstants appHighlightColor1]]];
    }
    
    TopicGroup *topicGroup = [[self data] objectAtIndex:(NSUInteger) [indexPath row]];
    NSString *name = [BNoteEntryUtils topicGroupName:topicGroup];

    if ([BNoteStringUtils nilOrEmpty:name]) {
        cell.textLabel.text = @" ";
    } else {
        cell.textLabel.text = name;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TopicGroup *topicGroup = [[self data] objectAtIndex:(NSUInteger) [indexPath row]];
        [[self data] removeObjectAtIndex:(NSUInteger) [indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];

        [[BNoteWriter instance] removeObjects:[NSArray arrayWithObject:topicGroup]];

        [self selectCell:[indexPath row] - 1];
    }
}

- (void)selectCell:(int)index
{
    if (self.data.count > 0) {
        self.nameText.hidden = NO;
        self.textLabel.hidden = NO;

        if (index < 0) {
            index = 0;
        }

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
        [[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
    } else {
        self.nameText.hidden = YES;
        self.textLabel.hidden = YES;
        [self.listener selectedTopicGroup:nil];
        [[self tableView] setEditing:NO animated:YES];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedCellLabel = [tableView cellForRowAtIndexPath:indexPath].textLabel;
    
    TopicGroup *topicGroup = [[self data] objectAtIndex:(NSUInteger) [indexPath row]];
    [self setSelectedTopicGroup:topicGroup];
    
    [self.listener selectedTopicGroup:topicGroup];
    self.nameText.text = topicGroup.name;
}

- (IBAction)edit:(id)sender
{
    [[self tableView] setEditing:![[self tableView] isEditing] animated:YES];
}

- (void)selectTopicGroup:(TopicGroup *)topicGroup
{
    int index = 0;

    if ([self.data containsObject:topicGroup]) {
        index = [self.data indexOfObject:topicGroup];
    }
    
    [self selectCell:index];
}

- (void)updateTopicGroupName:(NSNotification *)notification
{
    self.selectedTopicGroup.name = self.nameText.text;
    self.selectedCellLabel.text = self.nameText.text;

    self.invalidName = [self nameExists:self.nameText.text];

    if (self.invalidName) {
        self.textLabel.text = kTopicGroupExists;
        self.textLabel.textColor = [UIColor redColor];
        [self.invalidNameListener invalidName:YES];
        [self.tableView setUserInteractionEnabled:NO];
        self.tableView.backgroundColor = [UIColor lightGrayColor];
    } else {
        self.textLabel.text = kNormalText;
        self.textLabel.textColor = [BNoteConstants appHighlightColor1];
        [self.invalidNameListener invalidName:NO];
        [self.tableView setUserInteractionEnabled:YES];
        self.tableView.backgroundColor = [UIColor clearColor];
    }
}

- (void)refreshTopicGroupData
{
    [self setData:[[BNoteReader instance] allTopicGroups]];
    for (TopicGroup *topicGroup in [self data]) {
        if ([[topicGroup name] isEqualToString:kAllTopicGroupName]) {
            [[self data] removeObject:topicGroup];
            break;
        }
    }
}

- (BOOL)nameExists:(NSString *)name
{
    if ([BNoteStringUtils nilOrEmpty:name]) {
        return NO;
    }

    int count = 0;
    NSString *name2 = [BNoteStringUtils trim:name.lowercaseString];
    for (TopicGroup *topicGroup in self.data) {
        NSString *name1 = [BNoteStringUtils trim:topicGroup.name.lowercaseString];
        if ([name1 isEqualToString:name2]) {
            count++;
        }
    }

    return count >= 2;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];

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
