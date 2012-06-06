//
//  NoteScrollViewController.m
//  BNote
//
//  Created by Young Kristin on 5/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotesViewController.h"
#import "LayerFormater.h"
#import "BNoteAnimation.h"
#import "BNoteWriter.h"
#import "NoteView.h"
#import "Note.h"

@interface NotesViewController ()

@end

@implementation NotesViewController
@synthesize topic = _topic;
@synthesize entrySummariesTableViewController = _entrySummariesTableViewController;

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setTopic:nil];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {

    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LayerFormater roundCornersForView:[self view]];
    
    [self update];
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    [self update];
}

- (void)update
{    
    NSEnumerator *views = [[[self view] subviews] objectEnumerator];
    UIView *view;
    while (view = [views nextObject]) {
        [view setHidden:YES];
    }
    
    UIScrollView *scrollView = (UIScrollView *) [self view];
    
    float x = -100;
    float width = 100;
    
    NSOrderedSet *notes = [[self topic] notes];
    NSEnumerator *items = [notes objectEnumerator];
    Note *note;
    while (note = [items nextObject]) {
        x += width + 10;
        NoteView *noteView = [[NoteView alloc] initWithFrame:CGRectMake(x, 11, 100, 100)];
        [noteView setNote:note];
        [noteView setDelegate:self];
        [scrollView addSubview:noteView];
    }
    
    width = x + 110;

    if (width > 0) {
        [scrollView setContentSize:CGSizeMake(width, [view bounds].size.height)];
    }
    
    [[self entrySummariesTableViewController] reload]; 
}

- (void)deleteNote:(Note *)note
{
    [[BNoteWriter instance] removeNote:note];

    [self setTopic:[self topic]];
}

- (void)didFinishEditingNote:(Note *)note
{
    [[BNoteWriter instance] update];
    
    [self setTopic:[self topic]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
