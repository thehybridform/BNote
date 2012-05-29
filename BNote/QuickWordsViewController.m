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

@interface QuickWordsViewController ()
@property (strong, nonatomic) Entry *entry;

@end

@implementation QuickWordsViewController
@synthesize detailButton = _detailButton;
@synthesize peopleButton = _peopleButton;
@synthesize datesButton = _datesButton;
@synthesize keyWordsButton = _keyWordsButton;
@synthesize doneButton = _doneButton;
@synthesize listener = _listener;
@synthesize entry = _entry;
@synthesize scrollView = _scrollView;
@synthesize targetTextView = _targetTextView;

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

    [LayerFormater roundCornersForView:[self view]];
    
    [[self detailButton] setTitle:[BNoteStringUtils nameForEntry:[self entry]]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setDetailButton:nil];
    [self setPeopleButton:nil];
    [self setDatesButton:nil];
    [self setKeyWordsButton:nil];
    [self setEntry:nil];
    [self setScrollView:nil];
}

- (IBAction)done:(id)sender
{
    [[self listener] didFinishFromQuickWords];
}

- (IBAction)detail:(id)sender
{
    [self clearScrollView];
    
}

- (IBAction)people:(id)sender
{
    [self clearScrollView];
    
}

- (IBAction)dates:(id)sender
{
    [self clearScrollView];

    float space = 10;
    float next = space;
    float y = [[self scrollView] bounds].size.height / 2.0;
    NSEnumerator *items = [[QuickWordsFactory buildDateButtonsForTextView:[self targetTextView]] objectEnumerator];
    QuickWordButton *button;
    while (button = [items nextObject]) {
        float width = [button bounds].size.width;
        
        [button setCenter:CGPointMake(next + width/2.0, y)];
        [[self scrollView] addSubview:button];
        
        next += width + space;
    }
}

- (IBAction)keyWords:(id)sender
{
    [self clearScrollView];
    
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
    UIView *view = [self view];
    CGRect rect = [view frame];
    
    float x = rect.origin.x;
    
    [view setFrame:CGRectMake(x-900, rect.origin.y, rect.size.width, rect.size.height)];
    [parent addSubview:view];
    
    [UIView animateWithDuration:.50
                          delay:0
                        options:(UIViewAnimationOptionCurveLinear)
                     animations:^(void) {
                         CGAffineTransform move = CGAffineTransformMakeTranslation(900, 0);
                         [view setTransform:move];
                     }
                     completion:^(BOOL finished) {
                     }
     ];
}

- (void)hideView
{
    UIView *view = [self view];
    [UIView animateWithDuration:.50
                          delay:0
                        options:(UIViewAnimationOptionCurveLinear)
                     animations:^(void) {
                         CGAffineTransform move = CGAffineTransformTranslate([view transform], 900, 0);
                         [view setTransform:move];
                     }
                     completion:^(BOOL finished) {
                         [[self view] removeFromSuperview];
                     }
     ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
