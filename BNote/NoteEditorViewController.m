//
//  NoteEditorViewController.m
//  BNote
//
//  Created by Young Kristin on 5/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoteEditorViewController.h"
#import "LayerFormater.h"
#import "Topic.h"

@interface NoteEditorViewController ()
@property (strong, nonatomic) Note *note;
@property (assign, nonatomic) id<NoteEditorViewControllerDelegate> delegate;
@end

@implementation NoteEditorViewController
@synthesize dateView = _dateView;
@synthesize subjectView = _subjectView;
@synthesize scrollView = _scrollView;
@synthesize date = _date;
@synthesize time = _time;
@synthesize subject = _subject;
@synthesize note = _note;
@synthesize delegate = _delegate;

- (id)initWithNote:(Note *)note andDelegate:(id<NoteEditorViewControllerDelegate>)delegate
{
    self = [super initWithNibName:@"NoteEditorViewController" bundle:nil];
    if (self) {
        [self setNote:note];
        [self setDelegate:delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Note *note = [self note];
    if ([note subject] && [[note subject] length] > 0) {
        [[self subject] setText:[note subject]];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[note created]];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];

    [format setDateFormat:@"MMMM dd, YYYY"];
    NSString *dateString = [format stringFromDate:date];
    
    [format setDateFormat:@"hh:mm aaa"];
    NSString *timeString = [format stringFromDate:date];

    [[self date] setText:dateString];
    [[self time] setText:timeString];
    
    [[self view] setBackgroundColor:UIColorFromRGB([[note topic] color])];
                                    
    [LayerFormater roundCornersForView:[self dateView]];
    [LayerFormater roundCornersForView:[self subjectView]];
    [LayerFormater roundCornersForView:[self scrollView]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)done:(id)sender
{
    [[self note] setSubject:[[self subject] text]];
    [[self delegate] didFinish:self];
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
    [[self delegate] didCancel:self];
    [self dismissModalViewControllerAnimated:YES];
}

@end
