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
#import "BNoteWriter.h"

@interface AssociatedTopicsTableViewController ()
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UIPopoverController *popup;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation AssociatedTopicsTableViewController
@synthesize data = _data;
@synthesize note = _note;
@synthesize popup = _popup;
@synthesize actionSheet = _actionSheet;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setData:[[NSMutableArray alloc] init]];

    [LayerFormater roundCornersForView:[self view]];
    
    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheet:)];
    [[self tableView] addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:)
                                                 name:TopicUpdated object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setData:nil];
    [self setPopup:nil];
    [self setActionSheet:nil];
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
    return YES;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
        
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
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[topic title] delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Disassociate" otherButtonTitles: nil];
    
    [self setActionSheet:actionSheet];

    CGRect rect = [[[self view] superview] frame];
    [actionSheet showFromRect:rect inView:[[self view] superview] animated:YES];
}

- (void)showActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Associated Topics" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Remove" otherButtonTitles:@"Add", nil];
    
    [self setActionSheet:actionSheet];
    
    CGRect rect = [[self view] frame];
    [actionSheet showFromRect:rect inView:[[self view] superview] animated:YES];
}

- (void)showTopicSelector
{
    TopicSelectTableViewController *topicTable = 
    [[TopicSelectTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [topicTable associate];
    [topicTable setNote:[self note]];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:topicTable];
    [self setPopup:popup];
    
    [popup setPopoverContentSize:CGSizeMake(225, 400)];

    CGRect rect = [[self view] frame];
    [popup presentPopoverFromRect:rect inView:[[self view] superview]
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            [self showTopicSelector];
/*            Topic *topic = [[self data] objectAtIndex:buttonIndex];
            [[BNoteWriter instance] disassociateNote:[self note] toTopic:topic];
            [[self data] removeObject:topic];
            
            [[self tableView] reloadData];
            [self setActionSheet:nil];
 */
        }
            break;
            
        default:
            break;
    }
    
    [self setActionSheet:nil];    
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setActionSheet:nil];    
}

@end
