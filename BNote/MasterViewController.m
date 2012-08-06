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
#import "TopicEditorViewController.h"
#import "BNoteDefaultData.h"

@interface MasterViewController () 
@property (strong, nonatomic) NSMutableArray *data;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) IBOutlet UIButton *editTopicsButton;
@property (strong, nonatomic) Topic *searchTopic;
@property (strong, nonatomic) TopicGroup *topicGroup;

@end

@implementation MasterViewController

@synthesize data = _data;
@synthesize selectedIndex = _selectedIndex;
@synthesize editTopicsButton = _editTopicsButton;
@synthesize searchTopic = _searchTopic;
@synthesize topicGroup = _topicGroup;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self view] setBackgroundColor:[BNoteConstants appColor2]];
    [LayerFormater setBorderColor:[UIColor lightGrayColor] forView:[self view]];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(createdTopic:)
                                                 name:kTopicCreated
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectTopic:)
                                                 name:kTopicUpdated
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateReceived:)
                                                 name:kRefetchAllDatabaseData
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(selectTopicGroup:)
                                                 name:kTopicGroupSelected
                                               object:nil];
}

- (void)updateReceived:(NSNotification *)notification
{
    [[BNoteWriter instance] cleanup];
    
    NSString *groupName = [BNoteSessionData stringForKey:kTopicGroupSelected];
    if (!groupName) {
        groupName = kAllTopicGroupName;
        [BNoteSessionData setString:groupName forKey:kTopicGroupSelected];
    }

    TopicGroup *group = [[BNoteReader instance] getTopicGroup:groupName];
    
    if (!group) {
        group = [BNoteFactory createTopicGroup:groupName];
    }
    
    [self setTopicGroup:group];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kTopicGroupSelected object:group];

    if ([[self data] count] > 0) {
        [self selectCell:0];
    }
}

- (void)updateData
{
    [self setData:[[[self topicGroup] topics] mutableCopy]];
    [[self tableView] reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setEditTopicsButton:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (Topic *)searchTopic
{
    return [self searchTopic];
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
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [cell setEditingAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        
        [LayerFormater setBorderColor:[UIColor clearColor] forView:cell];
        
        UIFont *font = [BNoteConstants font:RobotoLight andSize:15.0];
        [[cell textLabel] setFont:font];
        [[cell textLabel] setTextColor:[BNoteConstants appHighlightColor1]];

        [cell setShowsReorderControl:NO];
        [LayerFormater setBorderWidth:1 forView:cell];
    }
    
    Topic *currentTopic = [[self data] objectAtIndex:[indexPath row]];
    [cell addSubview:[BNoteFactory createHighlightSliver:UIColorFromRGB([currentTopic color])]];
    [cell setSelectedBackgroundView:[BNoteFactory createHighlight:UIColorFromRGB([currentTopic color])]];
    

    static NSString *spacingText = @"  ";
    NSString *name = [currentTopic title];
    if ([name isEqualToString:kFilteredTopicName]) {
        name = @"Filtered Group";
    }
    
    [[cell textLabel] setText:[spacingText stringByAppendingString:name]];
    
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
    [[NSNotificationCenter defaultCenter] postNotificationName:kTopicGroupSelected object:[self topicGroup]];
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

    [[BNoteWriter instance] update];
    
    [self editTopicCell:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTopicGroupSelected object:[self topicGroup]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setSelectedIndex:[indexPath row]];
    
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [[BNoteSessionData instance] setSelectedTopic:topic];

    [[NSNotificationCenter defaultCenter] postNotificationName:kTopicSelected object:topic];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{    
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];

    TopicEditorViewController *controller = [[TopicEditorViewController alloc] initWithTopicGroup:[self topicGroup]];
    [controller setTopic:topic];

    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [[BNoteSessionData instance] setPopup:popup];
    [popup setDelegate:self];
    [controller setPopup:popup];
    
    [popup setPopoverContentSize:[[controller view] bounds].size];
    
    UIView *view = [[self tableView] cellForRowAtIndexPath:indexPath];
    CGRect rect = [view bounds];
    
    [popup presentPopoverFromRect:rect inView:view
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:YES];
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
    [self updateData];
    
    Topic *topic = [notification object];
    int index = [[self data] indexOfObject:topic];
    
    [self selectCell:index];
}

- (void)selectTopicGroup:(NSNotification *)notification
{
    TopicGroup *group = [notification object];
    [self setTopicGroup:group];
    [self setData:[[group topics] mutableCopy]];
    
    [[self tableView] reloadData];
    
    if ([[self data] count] > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self tableView:[self tableView] didSelectRowAtIndexPath:indexPath];
        [[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kTopicSelected object:nil];
    }

    [BNoteSessionData setString:[group name] forKey:kTopicGroupSelected];
}

- (IBAction)editTopicCell:(id)sender
{
    if ([[self tableView] isEditing]) {
        [[self tableView] setEditing:NO animated:YES];
    } else {
        [[self tableView] setEditing:YES animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[BNoteSessionData instance] setPopup:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
