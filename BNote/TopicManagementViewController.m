//
//  TopicManagementViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TopicManagementViewController.h"
#import "BNoteReader.h"
#import "BNoteWriter.h"
#import "BNoteFactory.h"
#import "Topic.h"
#import "LayerFormater.h"

@interface TopicManagementViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *helpLable;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) Note *note;
@property (assign, nonatomic) TopicSelectType topicSelectType;
@property (strong, nonatomic) NSMutableArray *selected;

@end

@implementation TopicManagementViewController
@synthesize titleLable = _titleLable;
@synthesize helpLable = _helpLable;
@synthesize data = _data;
@synthesize note = _note;
@synthesize topicSelectType = _topicSelectType;
@synthesize tableView = _tableView;
@synthesize selected = _selected;
@synthesize popup = _popup;
@synthesize actionButton = _actionButton;
@synthesize menuView = _menuView;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setTitleLable:nil];
    [self setData:nil];
    [self setHelpLable:nil];
    [self setSelected:nil];
    [self setMenuView:nil];
    [self setActionButton:nil];
    [self setTableView:nil];
}

- (id)initWithNote:(Note *)note forType:(TopicSelectType)type
{
    self = [super initWithNibName:@"TopicManagementViewController" bundle:nil];
    
    if (self) {
        [self setNote:note];
        [self setTopicSelectType:type];
        [self setSelected:[[NSMutableArray alloc] init]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSPredicate *p = [NSPredicate predicateWithFormat:@"title != %@", [[[self note] topic] title]];
    switch ([self topicSelectType]) {
        case ChangeMainTopic:
            [[self titleLable] setText:@"Change Topic"];
            [[self helpLable] setText:@"Select topic for note."];
            [[self actionButton] setTitle:@"Cancel" forState:UIControlStateNormal];
            [[self tableView] setAllowsMultipleSelection:NO];
            break;
            
        case AssociateTopic:
            [[self titleLable] setText:@"Associated Topics"];
            [[self helpLable] setText:@"Highlight topics to add."];
            [[self tableView] setAllowsMultipleSelection:YES];
            [[self actionButton] setTitle:@"Done" forState:UIControlStateNormal];
            break;
            
        case CopyToTopic:
            [[self titleLable] setText:@"Copy to Topic"];
            [[self helpLable] setText:@"Select topic for note."];
            [[self tableView] setAllowsMultipleSelection:NO];
            [[self actionButton] setTitle:@"Cancel" forState:UIControlStateNormal];
            p = [NSPredicate predicateWithValue:YES];
            break;
            
        default:
            break;
    }
    
    NSMutableArray *data = [[[BNoteReader instance] allTopics] mutableCopy];
    [data filterUsingPredicate:p];
    [self setData:data];
    
//    [LayerFormater addShadowToView:[self menuView]];
    [LayerFormater setBorderWidth:1 forView:[self menuView]];
}

- (IBAction)done:(id)sender
{
    [[self popup] dismissPopoverAnimated:YES];
    
    if ([self topicSelectType] == AssociateTopic) {
        [[BNoteWriter instance] associateTopics:[self selected] toNote:[self note]];
        [[NSNotificationCenter defaultCenter] postNotificationName:TopicUpdated object:[[self note] topic]];
    }
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
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        if ([self topicSelectType] == AssociateTopic) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
    }

    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[topic title]];
    
    if ([self topicSelectType] == AssociateTopic) {
        if ([[[self note] associatedTopics] containsObject:topic]) {
            [[self selected] addObject:topic];
            [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
        }
    }

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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Topic *topic = [[self data] objectAtIndex:[indexPath row]];
    switch ([self topicSelectType]) {
        case ChangeMainTopic:
        {
            [[self popup] dismissPopoverAnimated:YES];
            
            Topic *currentTopic = [[self note] topic];
            
            [[BNoteWriter instance] moveNote:[self note] toTopic:topic];
            [[NSNotificationCenter defaultCenter] postNotificationName:TopicUpdated object:currentTopic];
        }
            break;
        case AssociateTopic:
        {
            UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
            if ([cell accessoryType] == UITableViewCellAccessoryNone) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
                [[self selected] addObject:topic];
            } else {
                [cell setAccessoryType:UITableViewCellAccessoryNone];
                [[self selected] removeObject:topic];
            }
        }
            break;
        
        case CopyToTopic:
        {
            [[self popup] dismissPopoverAnimated:YES];
            
            Topic *currentTopic = [[self note] topic];

            [BNoteFactory copyNote:[self note] toTopic:topic];

            [[NSNotificationCenter defaultCenter] postNotificationName:TopicUpdated object:currentTopic];
        }
            break;

        default:
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
