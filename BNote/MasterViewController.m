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

@interface MasterViewController () 
@property (readwrite, assign) Topic *currentTopic;

@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize data = _data;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize currentTopic = _currentTopic;

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

    [self setData:[BNoteReader allTopicsInContext:[self managedObjectContext]]];
    
    if ([[self data] count] == 0) {
        Topic *newTopic = [BNoteFactory createTopicWithName:@"Help" inContext:[self managedObjectContext]]; 
        [self setData:[NSMutableArray  arrayWithObject:newTopic]];
    }
    
    [[self tableView] selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    
    [self updateCellColors];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)add:(id)sender
{
    TopicEditorViewController *topicEditor = [[TopicEditorViewController alloc] initWithDefaultNib];
    [topicEditor setDelegate:self];
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
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setEditingAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        [cell setShowsReorderControl:YES];
    }

    Topic *currentTopic = [[self data] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[currentTopic title]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [indexPath row] > 0;
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    TopicEditorViewController *topicEditor = [[TopicEditorViewController alloc] initWithDefaultNib];
    [topicEditor setDelegate:self];
    [topicEditor setEditing:YES];
    [topicEditor setIndexPath:indexPath];
    
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [topicEditor setTopic:topic];
    [topicEditor setModalPresentationStyle:UIModalPresentationFormSheet];
    [topicEditor setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentModalViewController:topicEditor animated:YES];
    [self setCurrentTopic:topic];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[self data] removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];
        
        Topic *topic = [[self data] objectAtIndex:[indexPath row]];
        [BNoteWriter removeTopic:topic inContext:[self managedObjectContext]];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [[self data] exchangeObjectAtIndex:[fromIndexPath row] withObjectAtIndex:[toIndexPath row]];
    
    for (int i = 0; i < [[self data] count]; i++) {
        Topic *topic = [[self data] objectAtIndex:i];
        [topic setIndex:[NSNumber numberWithInt:i]];
    }
    
    [BNoteWriter updateContext:[self managedObjectContext]];
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [[self detailViewController] setDetailItem:topic];
}


#pragma mark TopicEditorViewControllerDelegate
- (void)didFinish:(TopicEditorViewController *)topicEditor
{
    NSString *title = [[topicEditor nameTextField] text];
    if (title && [title length] > 0) {
        if ([topicEditor isEditing]) {
            [[self currentTopic] setTitle:title];
            [[self currentTopic] setColor:[topicEditor currentColor]];
            [[self managedObjectContext] save:nil];
        } else {
            Topic *topic = [BNoteFactory createTopicWithName:title inContext:[self managedObjectContext]]; 
            [topic setColor:[topicEditor currentColor]];
            [topic setIndex:[NSNumber numberWithInt:[[self data] count]]];
            [[self data] addObject:topic];
        }
        
        [[self tableView] reloadData];
        [self updateCellColors];
    }
}

- (void)didCancel:(TopicEditorViewController *)topicEditor
{
    [self updateCellColors];
}

- (void)updateCellColors
{
    for (int i = 0; i < [[self data] count]; i++) {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        Topic *topic = [[self data] objectAtIndex:i];
        
        UIColor *color;
        if ([topic color] > 0) {
            color = UIColorFromRGB([[topic color] intValue]);
        } else {
            color = [UIColor whiteColor];
        }
        
        [[[self tableView] cellForRowAtIndexPath:path] setBackgroundColor:color];
    }
}
@end
