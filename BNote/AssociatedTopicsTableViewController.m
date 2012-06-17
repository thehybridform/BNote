//
//  AssociatedTopicsTableViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/16/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AssociatedTopicsTableViewController.h"
#import "LayerFormater.h"
#import "Topic.h"
#import "TopicSelectTableViewController.h"
#import "BNoteFactory.h"

@interface AssociatedTopicsTableViewController ()
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UIPopoverController *popup;

@end

@implementation AssociatedTopicsTableViewController
@synthesize data = _data;
@synthesize note = _note;
@synthesize popup = _popup;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setData:[[NSMutableArray alloc] init]];

    [LayerFormater roundCornersForView:[self view]];
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTopicSelector:)];
    [[self view] addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:)
                                                 name:TopicUpdated object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setData:nil];
    [self setPopup:nil];
}

- (void)setNote:(Note *)note
{
    _note = note;

    [self updateData];
}

- (void)reload:(id)sender
{
    if ([self popup]) {
        [[self popup] dismissPopoverAnimated:YES];
    }
    
    [self updateData];
}

- (void)updateData
{
    [[self data] removeAllObjects];
    NSEnumerator *topics = [[[self note] associatedTopics] objectEnumerator];
    Topic *topic;
    while (topic = [topics nextObject]) {
        [[self data] addObject:topic];
    }
    
    [[self tableView] reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Associated Topics";
}

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
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[topic title]];

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
    
}

- (void)showTopicSelector:(id)sender
{
    TopicSelectTableViewController *topicTable = 
    [[TopicSelectTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [topicTable associate];
    [topicTable setNote:[self note]];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:topicTable];
    [self setPopup:popup];
    
    CGRect rect = [[self view] frame];
    [popup presentPopoverFromRect:rect inView:[self view] 
         permittedArrowDirections:UIPopoverArrowDirectionUp 
                         animated:YES];    
}

@end
