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
#import "NoteViewController.h"
#import "BNoteFactory.h"

@interface NotesViewController()
@property (strong, nonatomic) NSMutableArray *noteControllers;

@end

@implementation NotesViewController
@synthesize topic = _topic;
@synthesize noteControllers = _noteControllers;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setNoteControllers:[[NSMutableArray alloc] init]];
    }
    
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    [self setNoteControllers:[[NSMutableArray alloc] init]];
    [self reload];
}

- (void)reload
{   
    float space = 130;
    
    UIScrollView *scrollView = (UIScrollView *) [self view];
    for (UIView *view in [scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    float x = 10 - space;
    
    for (Note *note in [[self topic] notes]) {
        [self addNote:note atX:x += space];
    }
    
    for (Note *note in [[self topic] associatedNotes]) {
        [self addNote:note atX:x += space];
    }
    
    x += space;
    NoteView *noteView = [[NoteView alloc] initWithFrame:CGRectMake(x < 10 ? 10 : x, 10, 120, 96)];
    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalPressTap:)];
    [noteView addGestureRecognizer:tap];

    [scrollView addSubview:noteView];
    
    float width = x + space;
    if (width > 0) {
        [scrollView setContentSize:CGSizeMake(width, [scrollView bounds].size.height)];
    }
}

- (void)addNote:(Note *)note atX:(float)x
{
    float y = 10;

    NoteViewController *controller = [[NoteViewController alloc] initWithNote:note];
    [[self noteControllers] addObject:controller];
    
    UIView *view = [controller view];
    float width = [view bounds].size.width;
    float height = [view bounds].size.height;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [view setFrame:frame];
    
    UIScrollView *scrollView = (UIScrollView *) [self view];
    [scrollView addSubview:view];
}

- (void)normalPressTap:(id)sender
{
    Note *note = [BNoteFactory createNote:[self topic]];
    [[NSNotificationCenter defaultCenter] postNotificationName:NoteSelected object:note];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
