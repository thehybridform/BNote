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
#import "Topic.h"

@interface TopicManagementViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *helpLable;
@property (strong, nonatomic) NSArray *data;
@property (assign, nonatomic) Note *note;
@property (assign, nonatomic) TopicSelectType topicSelectType;
@property (strong, nonatomic) IBOutlet UIToolbar *associationToolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *selectToolbar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *selected;

@end

@implementation TopicManagementViewController
@synthesize titleLable = _titleLable;
@synthesize helpLable = _helpLable;
@synthesize data = _data;
@synthesize note = _note;
@synthesize listener = _listener;
@synthesize topicSelectType = _topicSelectType;
@synthesize associationToolbar = _associationToolbar;
@synthesize selectToolbar = _selectToolbar;
@synthesize tableView = _tableView;
@synthesize selected = _selected;

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

    switch ([self topicSelectType]) {
        case ChangeMainTopic:
            [[self titleLable] setText:@"Change Topic"];
            [[self helpLable] setText:@"Select new topic for note."];
            [[self associationToolbar] setHidden:YES];
            [[self tableView] setAllowsMultipleSelection:NO];
            break;
            
        case AssociateTopic:
            [[self titleLable] setText:@"Associated Topics"];
            [[self helpLable] setText:@"Highlight topics to add."];
            [[self selectToolbar] setHidden:YES];
            [[self tableView] setAllowsMultipleSelection:YES];
            break;
            
        default:
            break;
    }
    
    NSPredicate *p = [NSPredicate predicateWithFormat:@"title != %@", [[[self note] topic] title]];
    NSArray *data = [[[BNoteReader instance] allTopics] filteredArrayUsingPredicate:p];
    [self setData:data];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setTitleLable:nil];
    [self setData:nil];
    [self setNote:nil];
    [self setHelpLable:nil];
    [self setAssociationToolbar:nil];
    [self setSelectToolbar:nil];
    [self setSelected:nil];
}

- (IBAction)done:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
    [[self listener] selectedTopics:[self selected]];
}

- (IBAction)cancel:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
            [[self listener] changeTopic:topic];
            [self dismissModalViewControllerAnimated:YES];
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
        default:
            break;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
