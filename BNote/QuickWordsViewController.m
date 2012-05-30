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
@property (strong, nonatomic) Entry *entry;

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
@synthesize entry = _entry;
@synthesize scrollView = _scrollView;
@synthesize targetTextView = _targetTextView;

static float spacing = 10;
static float speed = 0.40;

- (id)initWithEntry:(Entry *)entry;
{
    self = [super initWithNibName:@"QuickWordsViewController" bundle:nil];
    if (self) {
        [self setEntry:entry];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[self entry] isKindOfClass:[Attendant class]]) {
        [[self toolbar] setHidden:YES];
        [[self decisionToolbar] setHidden:YES];
    } else if ([[self entry] isKindOfClass:[Decision class]]) {
        [[self toolbar] setHidden:YES];
        [[self attendantToolbar] setHidden:YES];
    } else {
        [[self attendantToolbar] setHidden:YES];
        [[self decisionToolbar] setHidden:YES];
    }

    [LayerFormater roundCornersForView:[self view]];
    
    [[self detailButton] setTitle:[BNoteStringUtils nameForEntry:[self entry]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setDetailButton:nil];
    [self setDatesButton:nil];
    [self setKeyWordsButton:nil];
    [self setEntry:nil];
    [self setScrollView:nil];
    [self setAttendantToolbar:nil];
    [self setDecisionToolbar:nil];
}

- (IBAction)done:(id)sender
{
    [[self listener] didFinishFromQuickWords];
}

- (IBAction)detail:(id)sender
{
    [self buildButtons:[self enumeratorForEntry:[self entry]]];
}

- (IBAction)people:(id)sender
{
    [self clearScrollView];
    
}

- (IBAction)dates:(id)sender
{
    NSEnumerator *items = [[QuickWordsFactory buildDateButtonsForTextView:[self targetTextView]] objectEnumerator];
    [self buildButtons:items];
}

- (IBAction)keyWords:(id)sender
{
    [self clearScrollView];
    
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
}

- (void)clearScrollView
{
    NSEnumerator *items = [[[self scrollView] subviews] objectEnumerator];
    UIView *view;
    while (view = [items nextObject]) {
        [view removeFromSuperview];
    }
}

- (void)presentView:(UIView *)parent
{
    [self checkDisableDetailButton];
    
    UIView *view = [self view];
    CGRect rect = [view frame];
    
    float x = rect.origin.x;
    
    [view setFrame:CGRectMake(x-900, rect.origin.y, rect.size.width, rect.size.height)];
    [parent addSubview:view];
    
    [UIView animateWithDuration:speed
                          delay:0
                        options:(UIViewAnimationOptionCurveLinear)
                     animations:^(void) {
                         CGAffineTransform move = CGAffineTransformMakeTranslation(900, 0);
                         [view setTransform:move];
                     }
                     completion:^(BOOL finished) {
                         [self detail:nil]; 
                     }
     ];
}

- (void)hideView
{
    [UIView animateWithDuration:speed
                          delay:0
                        options:(UIViewAnimationOptionCurveLinear)
                     animations:^(void) {
                         CGAffineTransform move = CGAffineTransformTranslate([[self view] transform], 900, 0);
                         [[self view] setTransform:move];
                     }
                     completion:^(BOOL finished) {
                         [[self view] removeFromSuperview];
                     }
     ];
}

- (NSEnumerator *)enumeratorForEntry:(Entry *)entry
{
    if ([entry isKindOfClass:[ActionItem class]]) {
        return [[QuickWordsFactory buildButtionsForTextView:[self targetTextView] andActionItem:(ActionItem *)entry] objectEnumerator];
    } else if ([entry isKindOfClass:[Attendant class]]) {
        return [[QuickWordsFactory buildButtionsForTextView:[self targetTextView] andNote:[[self entry] note]] objectEnumerator];
    } else if ([entry isKindOfClass:[Decision class]]) {
        return nil;
    } else if ([entry isKindOfClass:[KeyPoint class]]) {
        return nil;
    } else if ([entry isKindOfClass:[Question class]]) {
        return [[QuickWordsFactory buildButtionsForTextView:[self targetTextView] andQuestion:(Question *)entry] objectEnumerator];
    }
    
    return nil;
}

- (void)checkDisableDetailButton
{
    if ([[self entry] isKindOfClass:[Decision class]]) {
//        [[self detailButton] setEnabled:NO];
//        [[self detailButton] setTitle:nil];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
