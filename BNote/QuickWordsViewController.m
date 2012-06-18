//
//  QuickWordsViewController.m
//  BNote
//
//  Created by Young Kristin on 5/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuickWordsViewController.h"
#import "LayerFormater.h"
#import "BNoteStringUtils.h"
#import "QuickWordsFactory.h"
#import "QuickWordButton.h"

#import "Question.h"
#import "ActionItem.h"
#import "KeyPoint.h"
#import "Decision.h"
#import "Attendant.h"

@interface QuickWordsViewController ()
@property (strong, nonatomic) EntryTableViewCell *entryViewCell;

@end

@implementation QuickWordsViewController
@synthesize toolbar = _toolbar;
@synthesize attendantToolbar = _attendantToolbar;
@synthesize decisionToolbar = _decisionToolbar;
@synthesize detailButton = _detailButton;
@synthesize datesButton = _datesButton;
@synthesize keyWordsButton = _keyWordsButton;
@synthesize doneButton = _doneButton;
@synthesize listener = _listener;
@synthesize entryViewCell = _entryViewCell;
@synthesize scrollView = _scrollView;

static float spacing = 10;

- (id)initWithCell:(EntryTableViewCell *)cell
{
    self = [super initWithNibName:@"QuickWordsViewController" bundle:nil];
    if (self) {
        [self setEntryViewCell:cell];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[self entryViewCell] entry] isKindOfClass:[Decision class]]) {
        [[self toolbar] setHidden:YES];
        [[self attendantToolbar] setHidden:YES];
    } else {
        [[self attendantToolbar] setHidden:YES];
        [[self decisionToolbar] setHidden:YES];
    }
    
    [[self detailButton] setTitle:[BNoteStringUtils nameForEntry:[[self entryViewCell] entry]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyWords:)
                                                 name:KeyWordsUpdated object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setDetailButton:nil];
    [self setDatesButton:nil];
    [self setKeyWordsButton:nil];
    [self setScrollView:nil];
    [self setAttendantToolbar:nil];
    [self setDecisionToolbar:nil];
    [self setEntryViewCell:nil];
}

- (IBAction)detail:(id)sender
{
    [self buildButtons:[self enumeratorForEntry:[[self entryViewCell] entry]]];
}

- (IBAction)dates:(id)sender
{
    NSEnumerator *items = [[QuickWordsFactory buildDateButtonsForEntryCellView:[self entryViewCell]] objectEnumerator];
    [self buildButtons:items];
}

- (IBAction)keyWords:(id)sender
{
    NSEnumerator *items = [[QuickWordsFactory buildKeyWordButtionsForEntryCellView:[self entryViewCell]] objectEnumerator];
    [self buildButtons:items];
}

- (void)buildButtons:(NSEnumerator *)items
{
    [self clearScrollView];
    
    float next = spacing;
    float y = [[self scrollView] bounds].size.height / 2.0;
    
    QuickWordButton *button;
    while (button = [items nextObject]) {
        float width = [button bounds].size.width;
        
        [button setCenter:CGPointMake(next + width/2.0, y)];
        [[self scrollView] addSubview:button];
        
        next += width + spacing;
    }   
    
    [[self scrollView] setContentSize:CGSizeMake(next, [[self scrollView] bounds].size.height)];
}

- (void)clearScrollView
{
    NSEnumerator *items = [[[self scrollView] subviews] objectEnumerator];
    UIView *view;
    while (view = [items nextObject]) {
        [view setHidden:YES];
    }
}

- (void)selectFirstButton
{
    if ([[[self entryViewCell] entry] isKindOfClass:[Decision class]]) {
        [self dates:nil]; 
    } else {
        [self detail:nil]; 
    }
}

- (NSEnumerator *)enumeratorForEntry:(Entry *)entry
{
    if ([entry isKindOfClass:[ActionItem class]]) {
        return [[QuickWordsFactory buildButtionsForEntryCellView:[self entryViewCell] andActionItem:(ActionItem *)entry] objectEnumerator];
    } else if ([entry isKindOfClass:[KeyPoint class]]) {
        return [[QuickWordsFactory buildButtionsForEntryCellView:[self entryViewCell] andKeyPoint:(KeyPoint *)entry] objectEnumerator];
    } else if ([entry isKindOfClass:[Question class]]) {
        return [[QuickWordsFactory buildButtionsForEntryCellView:[self entryViewCell] andQuestion:(Question *)entry] objectEnumerator];
    }
    
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
