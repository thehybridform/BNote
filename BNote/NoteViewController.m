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

@interface NoteViewController ()
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation NoteViewController

@synthesize date = _date;
@synthesize time = _time;
@synthesize subject = _subject;
@synthesize note = _note;
@synthesize actionSheet = _actionSheet;
@synthesize noteViewControllerDelegate = _noteViewControllerDelegate;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setDate:nil];
    [self setTime:nil];
    [self setSubject:nil];
    [self setNote:nil];
    [self setActionSheet:nil];
    [self setNoteViewControllerDelegate:nil];
}


- (id)initWithNote:(Note *)note
{
    self = [super initWithNibName:@"NoteViewController" bundle:nil];
    if (self) {
        [self setNote:note];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    Note *note = [self note];
    Topic *topic = [note topic];
    int x = [[topic notes] indexOfObject:note];
    
    [[self view] setFrame:CGRectMake(x * 120 + 130, 25, 100, 100)];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[note created]];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"MMMM dd, YYYY"];
    NSString *dateString = [format stringFromDate:date];
    [[self date] setText:dateString];
    [[self date] setBackgroundColor:UIColorFromRGB([[note topic] color])];
     
    [format setDateFormat:@"hh:mm aaa"];
    NSString *timeString = [format stringFromDate:date];
    [[self time] setText:timeString];
    
    [[self subject] setText:[note subject]];

    [LayerFormater setBorderWidth:1 forView:[self view]];
    [LayerFormater setBorderColor:[UIColor blackColor] forView:[self view]];
    [LayerFormater roundCornersForView:[self view]];

    UITapGestureRecognizer *doubleTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doublePressTap:)];      
    [doubleTap setNumberOfTapsRequired:2];
    [[self view] addGestureRecognizer:doubleTap];

    UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTap:)];
    [[self view] addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalPressTap:)];
    [tap requireGestureRecognizerToFail:doubleTap];
    [[self view]  addGestureRecognizer:tap];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if ([self actionSheet]) {
        [[self actionSheet] dismissWithClickedButtonIndex:-1 animated:YES];
    }
}

- (void)doublePressTap:(id)sender
{
    [[BNoteSessionData instance] setCurrentNoteViewController:self];
    
    UIGestureRecognizer *gesture = (UIGestureRecognizer *) sender;
    CGPoint location = [gesture locationInView:[self view]];
    CGRect rect = CGRectMake(location.x, location.y, 1, 1);
    [[self noteViewControllerDelegate] presentActionSheetForController:rect];
}

-(void)longPressTap:(id)sender
{
}

-(void)normalPressTap:(id)sender
{
    NoteEditorViewController *controller = [[NoteEditorViewController alloc] initWithNote:[self note]];
    [controller setListener:self];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentModalViewController:controller animated:YES];
}

#pragma mark NoteEditorViewController

- (void)didFinish
{
    [[self subject] setText:[[self note] subject]];
    [[BNoteWriter instance] update];
    [[self noteViewControllerDelegate] noteUpdated:self];
}

@end
