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
#import "LayerFormater.h"

@interface TopicManagementViewController ()
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
@property (strong, nonatomic) IBOutlet UILabel *helpLable;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *menuView;
@property (strong, nonatomic) NSArray *data;
@property (strong, nonatomic) Note *note;
@property (assign, nonatomic) TopicSelectType topicSelectType;

@end

@implementation TopicManagementViewController
@synthesize titleLable = _titleLable;
@synthesize helpLable = _helpLable;
@synthesize data = _data;
@synthesize note = _note;
@synthesize topicSelectType = _topicSelectType;
@synthesize tableView = _tableView;
@synthesize delegate = _delegate;
@synthesize menuView = _menuView;

static NSString *cancelText;
static NSString *doneText;
static NSString *changeTopicText;
static NSString *selectTopicText;
static NSString *associateTopic;
static NSString *copyTopicText;
static NSString *highligtTopicText;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setTitleLable:nil];
    [self setData:nil];
    [self setHelpLable:nil];
    [self setTableView:nil];
    self.menuView = nil;
}

- (id)initWithNote:(Note *)note forType:(TopicSelectType)type
{
    self = [super initWithNibName:@"TopicManagementViewController" bundle:nil];
    
    if (self) {
        [self setNote:note];
        [self setTopicSelectType:type];
    }
    
    cancelText = NSLocalizedString(@"Cancel", @"Cancel");
    doneText = NSLocalizedString(@"Done", @"Done");
    changeTopicText = NSLocalizedString(@"Change Topic", @"Change the note topic owner");
    selectTopicText = NSLocalizedString(@"Select topic for note.", @"Select topic for this note");
    associateTopic = NSLocalizedString(@"Associated Topics", @"Topics associated to with this note");
    copyTopicText = NSLocalizedString(@"Copy to Topic", @"Copy to a differernt topic");
    highligtTopicText = NSLocalizedString(@"Highlight topics to add.", @"Highlight the topics to add to this note");
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.titleLable.font = [BNoteConstants font:RobotoBold andSize:20];
    self.titleLable.textColor = [BNoteConstants appHighlightColor1];
    
    self.helpLable.font = [BNoteConstants font:RobotoRegular andSize:18];
    self.helpLable.textColor = [BNoteConstants appHighlightColor1];
        
    NSPredicate *p = [NSPredicate predicateWithFormat:@"title != %@", [[[self note] topic] title]];
    switch ([self topicSelectType]) {
        case ChangeMainTopic:
            [[self titleLable] setText:changeTopicText];
            [[self helpLable] setText:selectTopicText];
            [[self tableView] setAllowsMultipleSelection:NO];
            break;
            
        case AssociateTopic:
            [[self titleLable] setText:associateTopic];
            [[self helpLable] setText:highligtTopicText];
            [[self tableView] setAllowsMultipleSelection:YES];
            
            break;
            
        case CopyToTopic:
            [[self titleLable] setText:copyTopicText];
            [[self helpLable] setText:selectTopicText];
            [[self tableView] setAllowsMultipleSelection:NO];
            p = [NSPredicate predicateWithValue:YES];
            break;
            
        default:
            break;
    }
    
    NSMutableArray *data = [[[BNoteReader instance] allTopics] mutableCopy];
    [data filterUsingPredicate:p];

    [data sortUsingComparator:^NSComparisonResult(Topic *topic1, Topic *topic2) {
        return [topic1.title compare:topic2.title];
    }];
    
    [self setData:data];
    
    [LayerFormater roundCornersForView:self.tableView];
    [LayerFormater setBorderColor:[BNoteConstants appHighlightColor1] forView:self.tableView];
    [LayerFormater setBorderWidth:1 forView:self.tableView];

    [LayerFormater setBorderWidth:1 forView:self.menuView];
    [LayerFormater setBorderColor:[BNoteConstants darkGray] forView:self.menuView];
    [LayerFormater addShadowToView:self.menuView];
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
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.textLabel.font = [BNoteConstants font:RobotoRegular andSize:16];
        cell.textLabel.textColor = [BNoteConstants appHighlightColor1];
    }

    Topic *topic = [[self data] objectAtIndex:(NSUInteger) [indexPath row]];
    [[cell textLabel] setText:[@"  " stringByAppendingString:[topic title]]];
    
    [cell addSubview:[BNoteFactory createHighlightSliver:UIColorFromRGB([topic color])]];
    [cell setSelectedBackgroundView:[BNoteFactory createHighlight:UIColorFromRGB([topic color])]];

    if ([self topicSelectType] == AssociateTopic) {
        if ([[[self note] associatedTopics] containsObject:topic]) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:tableView didSelectRowAtIndexPath:indexPath];
        }
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Topic *topic = [[self data] objectAtIndex:(NSUInteger) [indexPath row]];
    switch ([self topicSelectType]) {
        case ChangeMainTopic:
        {
            [[BNoteWriter instance] moveNote:[self note] toTopic:topic];
            
            [[BNoteWriter instance] update];
            [self.delegate finishedWithTopic:topic];
        }
            break;
        case AssociateTopic:
            [[BNoteWriter instance] associateNote:self.note toTopic:topic];
            break;
        
        case CopyToTopic:
        {
            [BNoteFactory copyNote:[self note] toTopic:topic];

            [[BNoteWriter instance] update];
            [self.delegate finishedWithTopic:topic];
        }
            break;

        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Topic *topic = [[self data] objectAtIndex:(NSUInteger) [indexPath row]];
    [[BNoteWriter instance] disassociateNote:self.note toTopic:topic];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
