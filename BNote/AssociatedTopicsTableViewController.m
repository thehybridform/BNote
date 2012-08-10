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
#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "TopicManagementViewController.h"

@interface AssociatedTopicsTableViewController ()
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIPopoverController *popup;

@end

@implementation AssociatedTopicsTableViewController
@synthesize data = _data;
@synthesize note = _note;
@synthesize actionSheet = _actionSheet;
@synthesize popup = _popup;

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setData:[[NSMutableArray alloc] init]];

    [LayerFormater roundCornersForView:[self view]];
    
    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showActionSheet:)];
    [[self tableView] addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload:)
                                                 name:kTopicUpdated object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setNote:(Note *)note
{
    _note = note;

    [self updateData];
}

- (void)reload:(id)sender
{
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
    switch (section) {
        case 0:
            return @"Main Topic";
            break;
        case 1:
            return @"Associated Topics";
            break;
        default:
            break;
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return [[self data] count];
            break;
        default:
            break;
    }
    
    return -1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
        
    Topic *topic;
    switch ([indexPath section]) {
        case 0:
            topic = [[self note] topic];
            break;
        case 1:
            topic = [[self data] objectAtIndex:[indexPath row]];;
            break;
        default:
            break;
    }

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

- (void)showActionSheet:(id)sender
{
    if ([BNoteEntryUtils multipleTopics:[self note]]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Manage Topics" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Change Main Topic", @"Manage Associated Topics", nil];
    
        [self setActionSheet:actionSheet];
    
        CGRect rect = [[self view] frame];
        [actionSheet showFromRect:rect inView:[[self view] superview] animated:YES];
    }
}

- (void)showTopicSelectorForType:(TopicSelectType)type
{
    TopicManagementViewController *controller =
        [[TopicManagementViewController alloc] initWithNote:[self note] forType:type];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self setPopup:popup];
    [popup setDelegate:self];
    [controller setPopup:popup];

    UIView *view = [self view];
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:YES];

}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self setPopup:nil];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self showTopicSelectorForType:ChangeMainTopic];
            break;
            
        case 1:
            [self showTopicSelectorForType:AssociateTopic];
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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
