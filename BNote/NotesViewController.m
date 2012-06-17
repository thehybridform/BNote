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
#import "DetailViewController.h"

@implementation NotesViewController
@synthesize topic = _topic;
@synthesize detailViewController = _detailViewController;

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self setTopic:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LayerFormater roundCornersForView:[self view]];
    
    [self reload];
}

- (void)reload
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
        [scrollView addSubview:noteView];
        [noteView setDetailViewController:[self detailViewController]];
    }
    
    items = [[[self topic] associatedNotes] objectEnumerator];
    while (note = [items nextObject]) {
        x += width + 10;
        NoteView *noteView = [[NoteView alloc] initWithFrame:CGRectMake(x, 11, 100, 100)];
        [noteView setNote:note];
        [scrollView addSubview:noteView];
        [noteView setDetailViewController:[self detailViewController]];
    }
    
    width = x + 110;

    if (width > 0) {
        [scrollView setContentSize:CGSizeMake(width, [scrollView bounds].size.height)];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
