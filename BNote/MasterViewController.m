//
//  MasterViewController.m
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"
#import "BNoteFactory.h"
#import "BNoteReader.h"
#import "BNoteWriter.h"
#import "Topic.h"
#import "LayerFormater.h"
#import "BNoteSessionData.h"

@interface MasterViewController () 
@property (strong, nonatomic) NSMutableArray *data;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) IBOutlet UIButton *editTopicsButton;

@end

@implementation MasterViewController

@synthesize data = _data;
@synthesize selectedIndex = _selectedIndex;
@synthesize editTopicsButton = _editTopicsButton;

- (void)dealloc 
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[BNoteConstants appColor1]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateReceived:)
                                                 name:RefetchAllDatabaseData
                                               object:[[UIApplication sharedApplication] delegate]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createdTopic:)
                                                 name:TopicCreated
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectTopic:)
                                                 name:TopicUpdated
                                               object:nil];
}

- (void)updateReceived:(NSNotification *)notification
{
    [self setData:[[BNoteReader instance] allTopics]];
    
    if ([[self data] count] == 0) {
        [self setData:[[NSMutableArray alloc] init]];
    } else {
        [[self tableView] reloadData];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:[self tableView] didSelectRowAtIndexPath:indexPath];
        [[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setEditTopicsButton:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        
        [LayerFormater setBorderColor:[UIColor clearColor] forView:cell];
        
        UIFont *font = [BNoteConstants font:RobotoLight andSize:15.0];
        [[cell textLabel] setFont:font];
        [[cell textLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    }

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

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    Topic *topic = [[self data] objectAtIndex:[sourceIndexPath row]];
    [[BNoteWriter instance] moveTopic:topic toIndex:[destinationIndexPath row] inGroup:[[topic groups] objectAtIndex:0]];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Topic *topic = [[self data] objectAtIndex:[indexPath row]];
        [[BNoteWriter instance] removeTopic:topic];

        [[self data] removeObjectAtIndex:[indexPath row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] 
                         withRowAnimation:UITableViewRowAnimationFade];

        int index = [indexPath row] - 1;
        if (index >= 0) {
            [self selectCell:index];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setSelectedIndex:[indexPath row]];
    
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [[BNoteSessionData instance] setSelectedTopic:topic];

    [[NSNotificationCenter defaultCenter] postNotificationName:TopicSelected object:topic];
}

- (void)selectCell:(int)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self tableView:[self tableView] didSelectRowAtIndexPath:indexPath];
    [[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];    
}

- (void)selectTopic:(NSNotification *)notification
{
    [self selectCell:[self selectedIndex]];
}

- (void)createdTopic:(NSNotification *)notification
{
    [self updateReceived:notification];
    
    Topic *topic = [notification object];
    [self selectCell:[[self data] indexOfObject:topic]];
}

- (IBAction)editTopicCell:(id)sender
{
    if ([[self tableView] isEditing]) {
        [[self tableView] setEditing:NO animated:YES];
        [[self editTopicsButton] setTitle:@"Organize" forState:UIControlStateNormal];
    } else {
        [[self tableView] setEditing:YES animated:YES];
        [[self editTopicsButton] setTitle:@"Done" forState:UIControlStateNormal];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
