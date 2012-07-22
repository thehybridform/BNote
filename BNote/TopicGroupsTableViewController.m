//
//  TopicGroupsTableViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicGroupsTableViewController.h"
#import "Topic.h"
#import "TopicGroup.h"
#import "BNoteReader.h"
#import "BNoteWriter.h"
#import "BNoteSessionData.h"

@interface TopicGroupsTableViewController ()
@property (strong, nonatomic) NSMutableArray *data;
@property (assign, nonatomic) TopicGroup *selectedTopicGroup;
@property (assign, nonatomic) int selectedIndex;

@end

@implementation TopicGroupsTableViewController
@synthesize data = _data;
@synthesize nameText = _nameText;
@synthesize selectedTopicGroup = _selectedTopicGroup;
@synthesize selectedIndex = _selectedIndex;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setData:[[BNoteReader instance] allTopicGroups]];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addTopicGroup:) name:AddTopicGroupSelected object:nil];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setData:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)setNameText:(UITextField *)nameText
{
    _nameText = nameText;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(updateTopicGroupName:)
     name:UITextFieldTextDidChangeNotification object:nameText];
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
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];

        [[cell textLabel] setFont:[BNoteConstants font:RobotoLight andSize:15]];
    }
    
    TopicGroup *topicGroup = [[self data] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[topicGroup name]];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath row] > 0;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TopicGroup *topicGroup = [[self data] objectAtIndex:[indexPath row]];
        [[self data] removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];

        [[BNoteWriter instance] removeObjects:[NSArray arrayWithObject:topicGroup]];

        int index = [indexPath row] - 1;
        if (index >= 0) {
            [self selectCell:index];
        }
    }   
}

- (void)selectCell:(int)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self tableView:[self tableView] didSelectRowAtIndexPath:indexPath];
    [[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}
    
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setSelectedIndex:[indexPath row]];
    TopicGroup *topicGroup = [[self data] objectAtIndex:[indexPath row]];
    [self setSelectedTopicGroup:topicGroup];
    [[NSNotificationCenter defaultCenter] postNotificationName:EditTopicGroupSelected object:topicGroup];
}

- (IBAction)edit:(id)sender
{
    [[self tableView] setEditing:![[self tableView] isEditing] animated:YES];
}

- (void)selectTopicGroup:(TopicGroup *)group
{
    [self setData:[[BNoteReader instance] allTopicGroups]];
    [[self tableView] reloadData];

    int index = [[self data] indexOfObject:group];
    [self selectCell:index];
}

- (void)updateTopicGroupName:(NSNotification *)notification
{
    if ([self nameText] == [notification object]) {
        UITextField *nameText = [self nameText];
        [[self selectedTopicGroup] setName:[nameText text]];
        
        NSIndexPath *path = [NSIndexPath indexPathForRow:[self selectedIndex] inSection:0];
        UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:path];
        [[cell textLabel] setText:[nameText text]];
    }
}

- (void)addTopicGroup:(NSNotification *)notification
{
    [self selectTopicGroup:[notification object]];
}

@end
