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
@property (strong, nonatomic) NSMutableArray *data;

@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize data = _data;

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefetchAllDatabaseData object:nil];
}

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
    [[self view] setBackgroundColor:[BNoteConstants appColor1]];

    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton =
        [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(add:)];

    self.navigationItem.rightBarButtonItem = addButton;
    self.title = NSLocalizedString(@"Topics", @"Topics");
    
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateReceived:)
                                                 name:RefetchAllDatabaseData
                                               object:[[UIApplication sharedApplication] delegate]];
}

- (void)loadData
{
    [self setData:[[BNoteReader instance] allTopics]];
    
    if ([[self data] count] == 0) {
        [self setData:[[NSMutableArray alloc] init]];
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:[self tableView] didSelectRowAtIndexPath:indexPath];
        [[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)updateReceived:(NSNotification *)note
{
    [self loadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RefetchAllDatabaseData object:nil];
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
    Topic *currentTopic = [[self data] objectAtIndex:[indexPath row]];
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [cell setEditingAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    [cell setShowsReorderControl:NO];
    [LayerFormater setBorderWidth:1 forView:cell];
    
    [cell addSubview:[BNoteFactory createHighlightSliver:UIColorFromRGB([currentTopic color])]];
    [cell setSelectedBackgroundView:[BNoteFactory createHighlight:UIColorFromRGB([currentTopic color])]];

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
    
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [topicEditor setTopic:topic];
    [topicEditor setModalPresentationStyle:UIModalPresentationFormSheet];
    [topicEditor setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:topicEditor animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Topic *topic = [[self data] objectAtIndex:[indexPath row]];
        [[BNoteWriter instance] removeTopic:topic];

        [[self data] removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
        
        /*
        int nextIndex = [indexPath row];
        if (nextIndex == 0) {
            nextIndex++;
        } else {
            nextIndex--;
        }

        NSIndexPath *path = [NSIndexPath indexPathForRow:nextIndex-1 inSection:0];
        [[self tableView] selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionMiddle];
         */
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [[self detailViewController] setTopic:topic];
}

- (void)didFinish:(Topic *)topic
{
    if (![[self data] containsObject:topic]) {
        [[self data] addObject:topic];
    }
    
    [[self tableView] reloadData];

    int index = ([[self data] count] - 1);
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self tableView:[self tableView] didSelectRowAtIndexPath:indexPath];
    [[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)didCancel
{
}

@end
