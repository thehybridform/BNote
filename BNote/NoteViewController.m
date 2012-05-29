//
//  NoteViewController.m
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoteViewController.h"
#import "Topic.h"
#import "BNoteWriter.h"
#import "NoteEditorViewController.h"
#import "LayerFormater.h"
#import "BNoteSessionData.h"
#import "BNoteAnimation.h"

@interface NoteViewController ()
@property (strong, nonatomic) Note *note;
@property (assign, nonatomic) BOOL deleting;
@property (assign, nonatomic) CGAffineTransform currentTransform;

@end

@implementation NoteViewController

@synthesize date = _date;
@synthesize time = _time;
@synthesize subject = _subject;
@synthesize note = _note;
@synthesize noteViewControllerDelegate = _noteViewControllerDelegate;
@synthesize currentTransform = _currentTransform;
@synthesize deleteMask = _deleteMask;
@synthesize deleting = _deleting;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setDate:nil];
    [self setTime:nil];
    [self setSubject:nil];
    [self setNote:nil];
    [self setNoteViewControllerDelegate:nil];
    [self setDeleteMask:nil];
}


- (id)initWithNote:(Note *)note
{
    self = [super initWithNibName:@"NoteViewController" bundle:nil];
    if (self) {
        [self setNote:note];
        [self setDeleting:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self storeCurrentTransform];

    [self reset];
    
    [[self view] setBackgroundColor:UIColorFromRGB(0xFFFCF7)];
    
    Note *note = [self note];

    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[note created]];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"MMMM dd, YYYY"];
    NSString *dateString = [format stringFromDate:date];
    [[self date] setText:dateString];
    [[self date] setBackgroundColor:UIColorFromRGB([[note topic] color])];
     
    [format setDateFormat:@"hh:mm aaa"];
    NSString *timeString = [format stringFromDate:date];
    [[self time] setText:timeString];

    [LayerFormater setBorderWidth:1 forView:[self view]];
    [LayerFormater setBorderColor:[UIColor blackColor] forView:[self view]];
    [LayerFormater roundCornersForView:[self view]];

    UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTap:)];
    [[self view] addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalPressTap:)];
    [[self view]  addGestureRecognizer:tap];
}

- (void)reset
{
    [[self deleteMask] setHidden:YES];
    [[self subject] setText:[[self note] subject]];
    [self setDeleting:NO];
    [[self view] setTransform:[self currentTransform]];
    [[[self view] layer] removeAllAnimations];
}

- (void)storeCurrentTransform
{
    [self setCurrentTransform:[[self view] transform]];
}

- (void)show
{
    [self normalPressTap:nil];
}

-(void)longPressTap:(id)sender
{
    [self setDeleting:YES];
    
    [[BNoteSessionData instance] setCurrentNoteViewController:self];
    
    [[self deleteMask] setHidden:NO];
    
    [[self view] bringSubviewToFront:[self deleteMask]];
    [[self view] bringSubviewToFront:[self subject]];
    [[self subject] setText:@"Delete"];
    
    [BNoteAnimation startWobble:[self view]];
    [[self noteViewControllerDelegate] setupForDeleteMove:self];
}

-(void)normalPressTap:(id)sender
{
    if ([self deleting]) {
        [[self view] removeFromSuperview];
        [[self noteViewControllerDelegate] noteDeleted:self];
    } else {
        [[BNoteSessionData instance] setCurrentNoteViewController:self];
        
        NoteEditorViewController *controller = [[NoteEditorViewController alloc] initWithNote:[self note]];
        [controller setListener:self];
        [controller setModalPresentationStyle:UIModalPresentationPageSheet];
        [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
        [self presentModalViewController:controller animated:YES];
    }
}

#pragma mark NoteEditorViewController

- (void)didFinish
{
    [[self subject] setText:[[self note] subject]];
    [[self noteViewControllerDelegate] noteUpdated:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
