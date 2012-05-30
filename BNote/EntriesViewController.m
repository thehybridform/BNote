//
//  EntriesViewController.m
//  BNote
//
//  Created by Young Kristin on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntriesViewController.h"
#import "LayerFormater.h"
#import "BNoteSessionData.h"
#import "BNoteWriter.h"
#import "BNoteAnimation.h"

@interface EntriesViewController ()
@property (strong, nonatomic) NSMutableArray *entryReviewViewControllers;
@property (assign, nonatomic) CGPoint currentScrollViewOffset;
@property (strong, nonatomic) QuickWordsViewController *quickWorkdsController;

@end

@implementation EntriesViewController
@synthesize entryReviewViewControllers = _entryReviewViewControllers;
@synthesize note = _note;
@synthesize maskView = _maskView;
@synthesize currentScrollViewOffset = _currentScrollViewOffset;
@synthesize quickWorkdsController = _quickWorkdsController;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setEntryReviewViewControllers:nil];
    [self setNote:nil];
    [self setMaskView:nil];
    [self setQuickWorkdsController:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self maskView] setHidden:YES];
    
    UITapGestureRecognizer *tap = 
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishedEntryMoveDelete:)];
    [[self maskView] addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification object:[[self view] window]];

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setEntryReviewViewControllers:[[NSMutableArray alloc] init]];
    }
    
    return self;
}

- (void)update
{       
    NSEnumerator *items = [[[self note] entries] objectEnumerator];
    Entry *entry;
    while (entry = [items nextObject]) {
        [self addEntry:entry];
    }
}

- (void)addEntry:(Entry *)entry
{
    if (![self isDeletingAnEntry]) {
        EntryReviewViewController *controller = [[EntryReviewViewController alloc] initWithEntry:entry];
        [controller setEntryReviewViewControllerDelegate:self];
    
        UIView *view = [controller view];
        [view setFrame:CGRectMake(0, [self yPosition], [view bounds].size.width, [view bounds].size.height)];

        [[self view] addSubview:view];
        
        [[self entryReviewViewControllers] addObject:controller];
        [self updateScrollViewSize];
    }
}

- (void)startEditingEntry:(Entry *)entry
{
    NSEnumerator *items = [[self entryReviewViewControllers] objectEnumerator];
    EntryReviewViewController *controller;
    while (controller = [items nextObject]) {
        if ([controller entry] == entry) {
            [controller startEditing];
        }
    }
}

- (float)yPosition
{
    float height = 0.0;
    NSEnumerator *items = [[self entryReviewViewControllers] objectEnumerator];
    EntryReviewViewController *controller;
    while (controller = [items nextObject]) {
        height += [[controller view] bounds].size.height;
    }
    
    return height;
}

- (void) updateScrollViewSize
{    
    UIScrollView *scrollView = (UIScrollView *) [self view];
    
    float width = [scrollView bounds].size.width;
    [scrollView setContentSize:CGSizeMake(width, [self yPosition])];
}


- (void)updateScrollView
{
    UIScrollView *scrollView = (UIScrollView *) [self view];
    [self setCurrentScrollViewOffset:[scrollView contentOffset]];

    [[self maskView] setHidden:YES];

    float delay = 0.1 * [[self entryReviewViewControllers] count];
    float lastY = 0.0;
    NSEnumerator *items = [[self entryReviewViewControllers] objectEnumerator];
    EntryReviewViewController *controller;
    while (controller = [items nextObject]) {
        [controller setupForReviewing];
        UIView *view = [controller view];
            
        float currentY = [view frame].origin.y;
        float deltaY = lastY - currentY;
            
        [BNoteAnimation moveEntryView:view xPixels:0 yPixels:deltaY withDelay:(delay -= 0.1)];
        lastY = [view frame].origin.y + [view bounds].size.height;
            
        [controller storeCurrentTransform];
    }
    
    float width = [scrollView bounds].size.width;
    [scrollView setContentSize:CGSizeMake(width, [self yPosition])];
    [scrollView setScrollEnabled:YES];
    [scrollView setContentOffset:[self currentScrollViewOffset] animated:YES];

}

- (void)setupForReviewing
{
    NSEnumerator *items = [[self entryReviewViewControllers] objectEnumerator];
    EntryReviewViewController *controller;
    while (controller = [items nextObject]) {
        [controller setupForReviewing];
    }
}

- (void)selectedController
{
    EntryReviewViewController *selected = [[BNoteSessionData instance] currentEntryReviewViewController];
    NSEnumerator *items = [[self entryReviewViewControllers] objectEnumerator];
    EntryReviewViewController *controller;
    while (controller = [items nextObject]) {
        if (controller != selected) {
            [controller setupForReviewing];
        }
    }
}

- (void)deletedEntry:(EntryReviewViewController *)controller
{
    UIView *view = [controller view];

    [view removeFromSuperview];
    [[BNoteWriter instance] removeEntry:[controller entry]];
    [[self entryReviewViewControllers] removeObject:controller];
    [self updateScrollView];    
}

- (void)deleteCandidate:(EntryReviewViewController *)c
{
    NSEnumerator *items = [[self entryReviewViewControllers] objectEnumerator];
    EntryReviewViewController *controller;
    while (controller = [items nextObject]) {
        if (controller == c) {
            [controller setupForDelete];
        } else {
            [controller setupForReviewing];
        }
    }
    
    [self showMaskView:c];
}

- (void)editCandidate:(EntryReviewViewController *)controller
{
    UIScrollView *view = (UIScrollView *) [self view];
    [self setCurrentScrollViewOffset:[view contentOffset]];
    
    [view setContentOffset:[[controller view] frame].origin animated:YES];
    [self showQuickView:controller];
}

- (void)showQuickView:(EntryReviewViewController *)controller
{
    QuickWordsViewController *currentQuick = [self quickWorkdsController];
    
    QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntry:[controller entry]];
    [self setQuickWorkdsController:quick];
    [quick setListener:self];
    [quick setTargetTextView:[controller textView]];
    
    float x = 12;
    float width = [[quick view] bounds].size.width;
    float height = [[quick view] bounds].size.height;
    float y = 156 - height + 44;
    [[quick view] setFrame:CGRectMake(x, y, width, height)];
    [[[self view] superview] addSubview:[quick view]];
    
    if (currentQuick) {
        [[currentQuick view] removeFromSuperview];
        [[[self view] superview] addSubview:[quick view]];
        [quick detail:nil]; 
        [quick checkDisableDetailButton];
    } else {
        [quick presentView:[[self view] superview]];
    }
}

- (void)finishedEntryMoveDelete:(id)sender
{
    [[self maskView] setHidden:YES];
    NSEnumerator *items = [[self entryReviewViewControllers] objectEnumerator];
    EntryReviewViewController *controller;
    while (controller = [items nextObject]) {
        [controller setupForReviewing];
    }
    [self updateScrollView];    
}

- (void)keyboardDidHide:(NSNotification *)notification
{
    if (![self isEditingAnEntry]) {
        UIScrollView *view = (UIScrollView *) [self view];
        [view setContentOffset:[self currentScrollViewOffset] animated:YES];
        [self didFinishFromQuickWords];
    }
}

- (BOOL)isEditingAnEntry
{
    NSEnumerator *items = [[self entryReviewViewControllers] objectEnumerator];
    EntryReviewViewController *controller;
    while (controller = [items nextObject]) {
        if ([controller isEditingEntry]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)isDeletingAnEntry
{
    NSEnumerator *items = [[self entryReviewViewControllers] objectEnumerator];
    EntryReviewViewController *controller;
    while (controller = [items nextObject]) {
        if ([controller isDeletingEntry]) {
            return YES;
        }
    }
    
    return NO;
}

- (void)showMaskView:(EntryReviewViewController *)c
{
    UIScrollView *view = (UIScrollView *) [self view];
    [view setScrollEnabled:NO];
    float width = [view bounds].size.width;
    float cHeight = [view contentSize].height;
    float fHeight = [view frame].size.height;
    float bHeight = [view bounds].size.height;
    
    [[self maskView] setHidden:NO];
    [[self maskView] setFrame:CGRectMake(0, -2000, width, MAX(MAX(cHeight, fHeight), bHeight) + 2000)];
    [view bringSubviewToFront:[self maskView]];
    [view bringSubviewToFront:[c view]];
}

- (void)didFinishFromQuickWords
{
    [[self quickWorkdsController] hideView];
    [self setQuickWorkdsController:nil];
    [self setupForReviewing];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
