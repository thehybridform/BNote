//
//  TopicGroupsViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicGroupsViewController.h"
#import "BNoteSessionData.h"
#import "LayerFormater.h"
#import "BNoteReader.h"
#import "BNoteFactory.h"

@interface TopicGroupsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *topicGroupLabel;
@property (strong, nonatomic) IBOutlet UIView *menu;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TopicGroupsViewController
@synthesize menu = _menu;
@synthesize data = _data;
@synthesize popup = _popup;
@synthesize addButton = _addButton;
@synthesize tableView = _tableView;
@synthesize topicGroupLabel = _topicGroupLabel;
@synthesize delegate = _delegate;

static NSString *menuText;
static NSString *manageText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        NSMutableArray *data = [[BNoteReader instance] allTopicGroups];
        [self setData:data];
        
        for (TopicGroup *topicGroup in data) {
            if ([[topicGroup name] isEqualToString:kAllTopicGroupName]) {
                [data removeObject:topicGroup];
                [data insertObject:topicGroup atIndex:0];
                break;
            }
        }
    }
    
    menuText = NSLocalizedString(@"Select Topic Group", @"The select topics group menu title.");
    manageText = NSLocalizedString(@"Edit", nil);
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LayerFormater addShadowToView:[self menu]];
    
    [LayerFormater setBorderWidth:1 forView:[self menu]];
    [LayerFormater setBorderColor:[BNoteConstants darkGray] forView:[self menu]];

    [[self topicGroupLabel] setFont:[BNoteConstants font:RobotoBold andSize:15]];
    [[self topicGroupLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    
    self.topicGroupLabel.text = menuText;
    [self.addButton setTitle:manageText forState:UIControlStateNormal];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setAddButton:nil];
    [self setTableView:nil];
    [self setMenu:nil];
    [self setTopicGroupLabel:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self data] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"GroupCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        [LayerFormater setBorderWidth:1 forView:cell];

        [LayerFormater setBorderColor:[UIColor clearColor] forView:cell];
        
        UIFont *font = [BNoteConstants font:RobotoLight andSize:15.0];
        [[cell textLabel] setFont:font];
        [[cell textLabel] setTextColor:[BNoteConstants appHighlightColor1]];
        [cell setSelectedBackgroundView:[BNoteFactory createHighlight:[BNoteConstants appHighlightColor1]]];
    }

    TopicGroup *topicGroup = [[self data] objectAtIndex:[indexPath row]];
    NSString *text = @"   ";
    [[cell textLabel] setText:[text stringByAppendingString:[BNoteEntryUtils topicGroupName:topicGroup]]];
    
    NSString *name = [BNoteSessionData stringForKey:kTopicGroupSelected];
    
    if ([[topicGroup name] isEqualToString:name]) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [[self popup] dismissPopoverAnimated:YES];
    TopicGroup *topicGroup = [[self data] objectAtIndex:[indexPath row]];
    
    NSString *currentGroup = [BNoteSessionData stringForKey:kTopicGroupSelected];
    if (![[topicGroup name] isEqualToString:currentGroup]) {
        [self.delegate selectTopicGroup:topicGroup];
    }
}

- (IBAction)newGroup:(id)sender
{
    [[self popup] dismissPopoverAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:kTopicGroupManage object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
