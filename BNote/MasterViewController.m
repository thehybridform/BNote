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
#import "BNoteDefaultData.h"

@interface MasterViewController () 
@property (strong, nonatomic) NSMutableArray *data;
@property (assign, nonatomic) NSInteger selectedIndex;
@property (strong, nonatomic) IBOutlet UIButton *addTopicButton;
@property (strong, nonatomic) IBOutlet UIButton *editButton;
@property (strong, nonatomic) Topic *searchTopic;

@end

@implementation MasterViewController

@synthesize data = _data;
@synthesize selectedIndex = _selectedIndex;
@synthesize searchTopic = _searchTopic;
@synthesize editButton = _editButton;
@synthesize listener = _listener;
@synthesize addTopicButton = _addTopicButton;

static NSString *filterdGroupText;

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
                                             selector:@selector(selectTopic:)
                                                 name:kClosedNoteEditor
                                               object:nil];
    
    filterdGroupText = NSLocalizedString(@"Filtered Group", @"The filtered topic title.");
}

- (void)updateData
{
    [self setData:[[[BNoteSessionData instance].selectedTopicGroup topics] mutableCopy]];
    [[self tableView] reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setAddTopicButton:nil];
    self.listener = nil;
    [self setEditButton:nil];
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
        
        [LayerFormater setBorderColor:[UIColor clearColor] forView:cell];
        
        UIFont *font = [BNoteConstants font:RobotoLight andSize:15.0];
        [[cell textLabel] setFont:font];
        [[cell textLabel] setTextColor:[BNoteConstants appHighlightColor1]];

        [cell setShowsReorderControl:NO];
        [LayerFormater setBorderWidth:1 forView:cell];
        
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTap:)];
        [cell addGestureRecognizer:longPress];
    }
    
    Topic *currentTopic = [[self data] objectAtIndex:[indexPath row]];
    [cell addSubview:[BNoteFactory createHighlightSliver:UIColorFromRGB([currentTopic color])]];
    [cell setSelectedBackgroundView:[BNoteFactory createHighlight:UIColorFromRGB([currentTopic color])]];
    

    static NSString *spacingText = @"  ";
    NSString *name = [currentTopic title];
    if ([name isEqualToString:kFilteredTopicName]) {
        name = filterdGroupText;
    }
    
    [[cell textLabel] setText:[spacingText stringByAppendingString:name]];
    
    return cell;
}

- (void)longPressTap:(UIGestureRecognizer *)gesture
{
    UITableViewCell *cell = (UITableViewCell *) gesture.view;
        
    int index = [self.tableView indexPathForCell:cell].row;
        
    Topic *topic = [[self data] objectAtIndex:index];
        
    if (topic.color == kFilterColor) {
        return;
    }

    TopicEditorViewController *controller = [[TopicEditorViewController alloc] initWithTopicGroup:[BNoteSessionData instance].selectedTopicGroup];
    [controller setTopic:topic];
        
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    controller.delegate = self;
        
    [self presentModalViewController:controller animated:YES];
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
    
    [[BNoteWriter instance] update];
    
    [self editTopicCell:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setSelectedIndex:[indexPath row]];
    
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [[BNoteSessionData instance] setSelectedTopic:topic];
    [BNoteSessionData setString:topic.title forKey:kTopicSelected];

    [self.listener selectedTopic:topic];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{    
}

- (void)selectCell:(int)index
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:self.tableView didSelectRowAtIndexPath:indexPath];
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

- (void)selectTopicGroup:(TopicGroup *)topicGroup
{
    [self setData:[[topicGroup topics] mutableCopy]];
    
    [[self tableView] reloadData];
    
    int selectedTopicIndex = -1;
    NSString *topicName = [BNoteSessionData stringForKey:kTopicSelected];
    for (Topic *topic in topicGroup.topics) {
        if ([topic.title isEqualToString:topicName]) {
            selectedTopicIndex = [topicGroup.topics indexOfObject:topic];
            break;
        }
    }

    NSIndexPath *indexPath;
    if (selectedTopicIndex >= 0) {
        indexPath = [NSIndexPath indexPathForRow:selectedTopicIndex inSection:0];
    } else if ([[self data] count] > 0) {
        indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }

    if (indexPath) {
        [self tableView:[self tableView] didSelectRowAtIndexPath:indexPath];
        [[self tableView] selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }

}

- (IBAction)editTopicCell:(id)sender
{
    if ([[self tableView] isEditing]) {
        [[self tableView] setEditing:NO animated:YES];
    } else {
        [[self tableView] setEditing:YES animated:YES];
    }
}

- (IBAction)addTopic:(id)sender
{
#ifdef LITE
    if ([[[self topicGroup] topics] count] > kMaxTopics) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"More Topics Not Supported", nil)
                              message:nil
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
#endif
    
    TopicGroup *topicGroup = [BNoteSessionData instance].selectedTopicGroup;
    TopicEditorViewController *controller = [[TopicEditorViewController alloc] initWithTopicGroup:topicGroup];
    
    [controller setModalPresentationStyle:UIModalPresentationFormSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    controller.delegate = self;
    
    [self presentModalViewController:controller animated:YES];
}

- (void)finishedWith:(Topic *)topic
{
    [self updateData];
    
    int index = [self.data indexOfObject:topic];
    [self selectCell:index];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
