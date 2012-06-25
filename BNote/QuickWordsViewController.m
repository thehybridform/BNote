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
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *attendantToolbar;
@property (strong, nonatomic) IBOutlet UIToolbar *decisionToolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *detailButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *datesButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *keyWordsButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (assign, nonatomic) EntryContentViewController *entryContentController;

@end

@implementation QuickWordsViewController
@synthesize toolbar = _toolbar;
@synthesize attendantToolbar = _attendantToolbar;
@synthesize decisionToolbar = _decisionToolbar;
@synthesize detailButton = _detailButton;
@synthesize datesButton = _datesButton;
@synthesize keyWordsButton = _keyWordsButton;
@synthesize doneButton = _doneButton;
@synthesize scrollView = _scrollView;
@synthesize entryContentController = _entryContentController;

static float spacing = 10;

- (id)initWithCell:(EntryContentViewController *)entryContentController
{
    self = [super initWithNibName:@"QuickWordsViewController" bundle:nil];
    if (self) {
        [self setEntryContentController:entryContentController];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[[self entryContentController] entry] isKindOfClass:[Decision class]]) {
        [[self toolbar] setHidden:YES];
        [[self attendantToolbar] setHidden:YES];
    } else {
        [[self attendantToolbar] setHidden:YES];
        [[self decisionToolbar] setHidden:YES];
    }
    
    [[self detailButton] setTitle:[BNoteStringUtils nameForEntry:[[self entryContentController] entry]]];
    
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
}

- (IBAction)detail:(id)sender
{
    [self buildButtons:[self enumeratorForEntry:[[self entryContentController] entry]]];
}

- (IBAction)dates:(id)sender
{
    NSEnumerator *items = [[QuickWordsFactory buildDateButtonsForEntryContentViewController:[self entryContentController]] objectEnumerator];
    [self buildButtons:items];
}

- (IBAction)keyWords:(id)sender
{
    NSEnumerator *items = [[QuickWordsFactory buildDateButtonsForEntryContentViewController:[self entryContentController]] objectEnumerator];
    [self buildButtons:items];
}

- (void)buildButtons:(NSEnumerator *)items
{
    [self clearScrollView];
    
    float next = spacing;
    float y = [[self scrollView] bounds].size.height / 2.0;
    
    UIView *view;
    while (view = [items nextObject]) {
        float width = [view bounds].size.width;
        
        [view setCenter:CGPointMake(next + width/2.0, y)];
        [[self scrollView] addSubview:view];
        
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
    if ([[[self entryContentController] entry] isKindOfClass:[Decision class]]) {
        [self dates:nil]; 
    } else {
        [self detail:nil]; 
    }
}

- (NSEnumerator *)enumeratorForEntry:(Entry *)entry
{
    if ([entry isKindOfClass:[ActionItem class]]) {
        return [[QuickWordsFactory buildButtionsForEntryContentViewController:[self entryContentController] andActionItem:(ActionItem *)entry] objectEnumerator];
    } else if ([entry isKindOfClass:[KeyPoint class]]) {
        return [[QuickWordsFactory buildButtionsForEntryContentViewController:[self entryContentController] andKeyPoint:(KeyPoint *)entry] objectEnumerator];
    } else if ([entry isKindOfClass:[Question class]]) {
        return [[QuickWordsFactory buildButtionsForEntryContentViewController:[self entryContentController] andQuestion:(Question *)entry] objectEnumerator];
    }
    
    return nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
