//
//  NoteScrollViewController.m
//  BNote
//
//  Created by Young Kristin on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotesViewController.h"
#import "NoteViewController.h"
#import "LayerFormater.h"
#import "BNoteAnimation.h"
#import "BNoteWriter.h"

@interface NotesViewController ()

@property (strong, nonatomic) NSMutableArray *noteViewControllers;

@end

@implementation NotesViewController
@synthesize noteViewControllers = _noteViewControllers;
@synthesize maskView = _maskView;
@synthesize listener = _listener;

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setNoteViewControllers:nil];
    [self setMaskView:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setNoteViewControllers:[[NSMutableArray alloc] init]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LayerFormater roundCornersForView:[self view]];
    [LayerFormater setBorderWidth:0 forView:[self view]];
    [[self maskView] setHidden:YES];
    
    UITapGestureRecognizer *tap = 
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(finishedEntryMoveDelete:)];
    [[self maskView] addGestureRecognizer:tap];

}

- (void)configureView:(Topic *)topic
{
    [self clearView];
    
    NSEnumerator *items = [[topic notes] objectEnumerator];
    Note *note;
    while (note = [items nextObject]) {
        [self addNoteToView:note];
    }
    
    [self updateScrollViewSize];
}

- (NoteViewController *)addNoteToView:(Note *)note
{
    NoteViewController *controller = [[NoteViewController alloc] initWithNote:note];
    [controller setNoteViewControllerDelegate:self];
    
    UIView *view = [controller view];
    [view setFrame:CGRectMake([self xPosition], 11, [view bounds].size.width, [view bounds].size.height)];
    [[self view] addSubview:view];
    
    [[self noteViewControllers] addObject:controller];
    
    return controller;
}

- (void)clearView
{
    NSEnumerator *items = [[self noteViewControllers] objectEnumerator];
    NoteViewController *controller;
    while (controller = [items nextObject]) {
        [[controller view] removeFromSuperview];
    }    
    
    [[self noteViewControllers] removeAllObjects];
    [[self maskView] setHidden:YES];

}

- (float)xPosition
{
    float width = 0.0;
    NSEnumerator *items = [[self noteViewControllers] objectEnumerator];
    NoteViewController *controller;
    while (controller = [items nextObject]) {
        width += [[controller view] bounds].size.width + 15;
    }

    return width;
}

- (void)updateScrollViewSize
{
    UIScrollView *scrollView = (UIScrollView *) [self view];
    
    float height = [scrollView bounds].size.height;
    [scrollView setContentSize:CGSizeMake([self xPosition], height)];
}

- (void)addNote:(Note *)note
{
    NoteViewController *controller = [self addNoteToView:note];
    [self updateScrollViewSize];
    
    [controller show];
}

- (void)noteDeleted:(NoteViewController *)c
{
    [self finishedEntryMoveDelete:nil];
    [[BNoteWriter instance] removeNote:[c note]];
    [[self noteViewControllers] removeObject:c];
    
    float delay = 0.1 * [[self noteViewControllers] count];
    float lastX = 0.0;
    NSEnumerator *items = [[self noteViewControllers] objectEnumerator];
    NoteViewController *controller;
    while (controller = [items nextObject]) {
        UIView *view = [controller view];
        
        float currentX = [view frame].origin.x - 15;
        float deltaX = lastX - currentX;

        [BNoteAnimation moveEntryView:view xPixels:deltaX yPixels:0 withDelay:(delay -= 0.1)];
         
        lastX = [view frame].origin.x + [view bounds].size.width;
        
        [controller storeCurrentTransform];
    }
    
    [self updateScrollViewSize];
    [[self listener] didFinish];
}

- (void)noteUpdated:(NoteViewController *)controller
{
    [[self listener] didFinish];
}

- (void)setupForDeleteMove:(NoteViewController *)controller
{
    [[self maskView] setHidden:NO];
    
    float width = [((UIScrollView *)[self view]) contentSize].width;
    float height = [((UIScrollView *)[self view]) contentSize].height;
    [[self maskView] setFrame:CGRectMake(0, 0, width, height)];
    
    [[self view] bringSubviewToFront:[self maskView]];
    [[self view] bringSubviewToFront:[controller view]];
}

- (void)finishedEntryMoveDelete:(id)sender
{
    [[self maskView] setHidden:YES];
    NSEnumerator *items = [[self noteViewControllers] objectEnumerator];
    NoteViewController *controller;
    while (controller = [items nextObject]) {
        [controller reset];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
