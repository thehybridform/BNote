//
//  SelectedTopicsTableViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SelectedTopicsTableViewController.h"
#import "Topic.h"
#import "BNoteReader.h"
#import "BNoteFactory.h"
#import "LayerFormater.h"

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

- (void)selectedTopicGroup:(TopicGroup *)group
{
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

    [LayerFormater setBorderWidth:1 forView:self.view];
    [LayerFormater setBorderColor:[BNoteConstants darkGray] forView:self.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.textLabel.textColor = [BNoteConstants appHighlightColor1];
        [[cell textLabel] setFont:[BNoteConstants font:RobotoLight andSize:15]];
    }
    
    Topic *currentTopic = [[self data] objectAtIndex:(NSUInteger) [indexPath row]];
    [cell addSubview:[BNoteFactory createHighlightSliver:UIColorFromRGB([currentTopic color])]];
    [cell setSelectedBackgroundView:[BNoteFactory createHighlight:UIColorFromRGB([currentTopic color])]];
    
    if ([[[self topicGroup] topics] containsObject:currentTopic]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
        
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
        Topic *topic = [[self data] objectAtIndex:(NSUInteger) [indexPath row]];
        [[self topicGroup] addTopicsObject:topic];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self topicGroup] && ![[[self topicGroup] name] isEqualToString:kAllTopicGroupName]) {
        Topic *topic = [[self data] objectAtIndex:(NSUInteger) [indexPath row]];
        [[self topicGroup] removeTopicsObject:topic];
    }
}

@end
