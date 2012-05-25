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

@interface EntriesViewController ()
@property (strong, nonatomic) NSMutableArray *entryReviewViewControllers;
@property (assign, nonatomic) float yPosition;
@property (assign, nonatomic) float xPosition;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation EntriesViewController
@synthesize entryReviewViewControllers = _entryReviewViewControllers;
@synthesize note = _note;
@synthesize xPosition = _xPosition;
@synthesize yPosition = _yPosition;
@synthesize actionSheet = _actionSheet;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setEntryReviewViewControllers:nil];
    [self setNote:nil];
    [self setActionSheet:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *parent = [self view];
    [self setXPosition:[parent bounds].size.width / 2.0];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setEntryReviewViewControllers:[[NSMutableArray alloc] init]];
        [self setYPosition:0];
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
    EntryReviewViewController *controller = [[EntryReviewViewController alloc] initWithEntry:entry];
    [[self entryReviewViewControllers] addObject:controller];
    [controller setEntryReviewViewControllerDelegate:self];
    
    UIView *view = [controller view];
    float height = [view bounds].size.height;
    [self setYPosition:([self yPosition] + height / 2.0)];
    
    [view setCenter:CGPointMake([self xPosition], [self yPosition])];
    [[self view] addSubview:view];
    
    [self setYPosition:([self yPosition] + height / 2.0)];
    
    [self updateScrollViewSize];
}

- (void) updateScrollViewSize
{
    float height = 0.0;
    
    UIScrollView *scrollView = (UIScrollView *) [self view];
    
    NSEnumerator *items = [[scrollView subviews] objectEnumerator];
    UIView *view;
    while (view = [items nextObject]) {
        height += [view bounds].size.height;
    }
    
    float width = [scrollView bounds].size.width;
    [scrollView setContentSize:CGSizeMake(width, height)];
}


- (void)updateScrollView
{
    float delay = 0.1 * [[self entryReviewViewControllers] count];
    float lastY = 0.0;
    NSEnumerator *items = [[self entryReviewViewControllers] objectEnumerator];
    EntryReviewViewController *controller;
    while (controller = [items nextObject]) {
        UIView *view = [controller view];
            
        float currentY = [view frame].origin.y;
        float deltaY = lastY - currentY;
            
        [self moveEntryView:[controller view] yPixels:deltaY withDelay:(delay -= 0.1)];
        lastY = [view frame].origin.y + [view bounds].size.height;
            
        [self setYPosition:lastY];
    }
    
    UIScrollView *scrollView = (UIScrollView *) [self view];
    float width = [scrollView bounds].size.width;
    [scrollView setContentSize:CGSizeMake(width, [self yPosition])];

}

- (void)moveEntryView:(UIView *)view yPixels:(float)y withDelay:(float)delay
{
    if (y != 0) {
        CGAffineTransform move = CGAffineTransformTranslate([view transform], 0, y);
        [UIView animateWithDuration:0.3
                              delay:delay
                            options:(UIViewAnimationOptionCurveEaseIn)
                         animations:^(void) {
                             [view setTransform:move];
                         }
                         completion:^(BOOL finished) {
                         }
         ];
    }
}

- (void)setupForReviewing
{
    NSEnumerator *items = [[self entryReviewViewControllers] objectEnumerator];
    EntryReviewViewController *controller;
    while (controller = [items nextObject]) {
        [controller setupForReviewing];
    }
}

- (void)presentActionSheetForController:(CGRect)rect
{
    EntryReviewViewController *controller = [[BNoteSessionData instance] currentEntryReviewViewController];

    UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
    [actionSheet setDelegate:self];
    [actionSheet addButtonWithTitle:@"Delete Entry"];
    [actionSheet addButtonWithTitle:@"Cancel"];
    
    [actionSheet showFromRect:rect inView:[controller view] animated:YES];
    
    [LayerFormater setBorderWidth:5 forView:[controller view]];
    [LayerFormater setBorderColor:[UIColor redColor] forView:[controller view]];
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    EntryReviewViewController *controller = [[BNoteSessionData instance] currentEntryReviewViewController];
    UIView *view = [controller view];
    
    switch (buttonIndex) {
        case 0:
            [view removeFromSuperview];
            [[BNoteWriter instance] removeEntry:[controller entry]];
            [[self entryReviewViewControllers] removeObject:controller];
            [self updateScrollView];
            break;
        case 1:
            [LayerFormater setBorderWidth:1 forView:view];
            [LayerFormater setBorderColor:[UIColor blackColor] forView:view];
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    EntryReviewViewController *controller = [[BNoteSessionData instance] currentEntryReviewViewController];
    UIView *view = [controller view];
    [LayerFormater setBorderWidth:1 forView:view];
    [LayerFormater setBorderColor:[UIColor blackColor] forView:view];
    [self setActionSheet:nil];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
