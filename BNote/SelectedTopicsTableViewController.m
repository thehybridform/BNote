//
//  SelectedTopicsTableViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectedTopicsTableViewController.h"
#import "Topic.h"
#import "TopicGroup.h"
#import "BNoteReader.h"
#import "BNoteWriter.h"
#import "BNoteFactory.h"

@interface SelectedTopicsTableViewController ()
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) TopicGroup *topicGroup;

@end

@implementation SelectedTopicsTableViewController
@synthesize data = _data;
@synthesize topicGroup = _topicGroup;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setData:[[BNoteReader instance] allTopics]];
    }
    
    return self;
}

- (void)selectedTopicGroup:(NSNotification *)notification
{
    TopicGroup *group = [notification object];
    
    if (group) {
        [[self view] setHidden:NO];
    } else {
        [[self view] setHidden:YES];
    }

    [self setTopicGroup:group];
    [[self tableView] reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedTopicGroup:) name:EditTopicGroupSelected object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];

        [[cell textLabel] setFont:[BNoteConstants font:RobotoLight andSize:15]];
    }
    
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[topic title]];

    if ([[[self topicGroup] topics] containsObject:topic]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    Topic *currentTopic = [[self data] objectAtIndex:[indexPath row]];
    [cell addSubview:[BNoteFactory createHighlightSliver:UIColorFromRGB([currentTopic color])]];
    [cell setSelectedBackgroundView:[BNoteFactory createHighlight:UIColorFromRGB([currentTopic color])]];
    
    
    static NSString *spacingText = @"   ";
    [[cell textLabel] setText:[spacingText stringByAppendingString:[currentTopic title]]];

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self topicGroup] && ![[[self topicGroup] name] isEqualToString:kAllTopicGroupName]) {
        Topic *topic = [[self data] objectAtIndex:[indexPath row]];

        UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell accessoryType] == UITableViewCellAccessoryNone) {
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            [[self topicGroup] addTopicsObject:topic];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [[self topicGroup] removeTopicsObject:topic];
        }
    }
}

@end
