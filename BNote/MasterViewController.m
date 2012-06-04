//
//  MasterViewController.m
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "BNoteFactory.h"
#import "BNoteReader.h"
#import "BNoteWriter.h"
#import "Topic.h"
#import "LayerFormater.h"
#import "BNoteSessionData.h"

@interface MasterViewController () 

@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize data = _data;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];

    self.navigationItem.rightBarButtonItem = addButton;
    self.title = NSLocalizedString(@"Topics", @"Topics");

    [self setData:[[BNoteReader instance] allTopics]];
    
    if ([[self data] count] == 0) {
        [self setData:[[NSMutableArray alloc] init]];
    } else {
        [[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)add:(id)sender
{
    TopicEditorViewController *topicEditor = [[TopicEditorViewController alloc] initWithDefaultNib];
    [topicEditor setListener:self];
    [topicEditor setModalPresentationStyle:UIModalPresentationFormSheet];
    [topicEditor setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentModalViewController:topicEditor animated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self data] count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Topic *currentTopic = [[self data] objectAtIndex:[indexPath row]];
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setEditingAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        [cell setShowsReorderControl:YES];
        [LayerFormater roundCornersForView:cell];
        
        [cell addSubview:[BNoteFactory createHighlightSliver:UIColorFromRGB([currentTopic color])]];
        [cell setSelectedBackgroundView:[BNoteFactory createHighlight:UIColorFromRGB([currentTopic color])]];
    }

    NSString *text = @"   ";
    [[cell textLabel] setText:[text stringByAppendingString:[currentTopic title]]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    TopicEditorViewController *topicEditor = [[TopicEditorViewController alloc] initWithDefaultNib];
    [topicEditor setListener:self];
    [topicEditor setEditing:YES];
    [topicEditor setIndexPath:indexPath];
    
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [topicEditor setTopic:topic];
    [topicEditor setModalPresentationStyle:UIModalPresentationFormSheet];
    [topicEditor setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:topicEditor animated:YES];
    [[BNoteSessionData instance] setCurrentTopic:topic];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Topic *topic = [[self data] objectAtIndex:[indexPath row]];
        [[BNoteWriter instance] removeTopic:topic];

        [[self data] removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [[self data] exchangeObjectAtIndex:[fromIndexPath row] withObjectAtIndex:[toIndexPath row]];
    
    for (int i = 0; i < [[self data] count]; i++) {
        Topic *topic = [[self data] objectAtIndex:i];
        [topic setIndex:i];
    }
    
    [[BNoteWriter instance] update];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [[self detailViewController] setTopic:topic];
}


#pragma mark TopicEditorViewControllerDelegate
- (void)didFinish:(TopicEditorViewController *)topicEditor
{
    NSString *title = [[topicEditor nameTextField] text];
    if (title && [title length] > 0) {
        if ([topicEditor isEditing]) {
            [[[BNoteSessionData instance] currentTopic] setTitle:title];
            [[[BNoteSessionData instance] currentTopic] setColor:[topicEditor currentColor]];
        } else {
            Topic *topic = [BNoteFactory createTopic:title]; 
            [topic setColor:[topicEditor currentColor]];
            [topic setIndex:[[self data] count]];
            [[self data] addObject:topic];
        }
        
        [[BNoteWriter instance] update];
        
        [[self tableView] reloadData];

    }
}

- (void)didCancel:(TopicEditorViewController *)topicEditor
{
}

@end
