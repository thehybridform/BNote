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
#import "NoteViewController.h"
#import "BNoteFactory.h"

@interface NotesViewController()
@property (strong, nonatomic) NSMutableArray *noteControllers;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControlNotes;

@end

@implementation NotesViewController
@synthesize topic = _topic;
@synthesize noteControllers = _noteControllers;
@synthesize pageControlNotes = _pageControlNotes;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setPageControlNotes:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)setTopic:(Topic *)topic
{
    _topic = topic;
    
    [self setNoteControllers:[[NSMutableArray alloc] init]];
    [self setSearchText];
}

- (void)setSearchText
{
    [self reload];
}

- (void)reset
{
    UIScrollView *view = (UIScrollView *)[self view];
    CGRect frame;
    frame.origin.x = 10;
    frame.origin.y = 10;
    frame.size = CGSizeMake(10, 10);
    [view scrollRectToVisible:frame animated:YES];
    
    [[self pageControlNotes] setCurrentPage:0];
}

- (void)reload
{   
    UIScrollView *scrollView = (UIScrollView *) [self view];
    for (UIView *view in [scrollView subviews]) {
        [view removeFromSuperview];
    }
    
    float delay = 0;
    float delayIncrement = 0.1;
    float space = 110;
    int notes = 0;

    int visibleNotes = 7;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation) || scrollView.frame.size.width < 600) {
        visibleNotes = 4;
        space = 130;
    }    

    float x = 10 - space;
    
    for (Note *note in [[self topic] notes]) {
        [self addNote:note atX:x += space withDelay:delay += delayIncrement isAssociated:NO];
        notes++;
    }
    
    for (Note *note in [[self topic] associatedNotes]) {
        [self addNote:note atX:x += space withDelay:delay += delayIncrement isAssociated:YES];
        notes++;
    }
    
    if ([[self topic] color] != kFilterColor) {
        x += space;
        NoteView *noteView = [[NoteView alloc] initWithFrame:CGRectMake(x < 10 ? 10 : x + 2, 9, 96, 106)];
        UITapGestureRecognizer *tap =
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalPressTap:)];
        [noteView addGestureRecognizer:tap];

        [scrollView addSubview:noteView];
        notes++;
    }

    int count = notes / visibleNotes;
    if (notes % visibleNotes) {
        count++;
    }

    float width = space * count * visibleNotes;
    if (width > 0) {
        [scrollView setContentSize:CGSizeMake(width, [scrollView bounds].size.height)];
    }
    
    [[self pageControlNotes] setNumberOfPages:count];
    [[self pageControlNotes] setNeedsDisplay];
}

- (void)addNote:(Note *)note atX:(float)x withDelay:(float)delay isAssociated:(BOOL)associated
{
    float y = 7;

    NoteViewController *controller = [[NoteViewController alloc] initWithNote:note isAssociated:associated];
    [[self noteControllers] addObject:controller];
        
    NoteView *view = (NoteView *)[controller view];
    float width = [view bounds].size.width;
    float height = [view bounds].size.height;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [view setFrame:frame];
    
    UIView *shadowView = [[UIView alloc] initWithFrame:CGRectMake(x + 2, y + 2, width - 4, height - 4)];
    [LayerFormater addShadowToView:shadowView];
    [LayerFormater setBorderColorWithInt:1 forView:shadowView];
    shadowView.backgroundColor = [BNoteConstants appColor1];

    UIScrollView *scrollView = (UIScrollView *) [self view];
    [scrollView addSubview:shadowView];
    [scrollView addSubview:view];
    
    NSArray *views = [[NSArray alloc]
                      initWithObjects:
                      view,
                      shadowView,
                      nil];
    [BNoteAnimation winkInView:views withDuration:0.05 andDelay:delay andDelayIncrement:0 spark:NO];
}

- (IBAction)pageChanged:(UIPageControl *)pageControl
{
    UIScrollView *view = (UIScrollView *)[self view];
    CGRect frame;
    frame.origin.x = [view frame].size.width * [pageControl currentPage];
    frame.origin.y = 0;
    frame.size = [view frame].size;
    [view scrollRectToVisible:frame animated:YES];
    
    [[self pageControlNotes] setNeedsDisplay];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    UIScrollView *view = (UIScrollView *)[self view];
    
    CGFloat pageWidth = [view frame].size.width;
    double page = floor((view.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    [[self pageControlNotes] setCurrentPage:(NSInteger) page];

    [[self pageControlNotes] setNeedsDisplay];
}

- (void)normalPressTap:(id)sender
{
#ifdef LITE
    if ([[[self topic] notes] count] > kMaxNotes) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"More Notes Not Supported", nil)
                              message:nil
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                              otherButtonTitles:nil];

        [alert show];
        return;
    }
    
#endif
    Note *note = [BNoteFactory createNote:[self topic]];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoteSelected object:note];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
