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

@interface NoteViewController ()
@property (strong, nonatomic) Note *note;
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (assign, nonatomic) id<NoteViewControllerDelegate> delegate;
@end

@implementation NoteViewController

@synthesize date = _date;
@synthesize time = _time;
@synthesize subject = _subject;
@synthesize note = _note;
@synthesize actionSheet = _actionSheet;
@synthesize delegate = _delegate;

- (id)initWithNote:(Note *)note andDelegate:(id<NoteViewControllerDelegate>)delegate
{
    self = [super initWithNibName:@"NoteViewController" bundle:nil];
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

    [LayerFormater roundCornersForView:[self view]];

    UILongPressGestureRecognizer *longPress =
    [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTap:)];
    [[self view] addGestureRecognizer:longPress];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalPressTap:)];
    [[self view]  addGestureRecognizer:tap];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    UIActionSheet *sheet = [self actionSheet];
    [sheet dismissWithClickedButtonIndex:-1 animated:YES];
}

-(void)longPressTap:(id)sender
{
    if (![self actionSheet]) {
        UIGestureRecognizer *gesture = (UIGestureRecognizer *) sender;
        if(UIGestureRecognizerStateBegan == [gesture state]) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
            [actionSheet setDelegate:self];
            [actionSheet addButtonWithTitle:@"Delete Note"];
            [actionSheet addButtonWithTitle:@"Cancel"];
            
            UIView *view = [self view];
            CGRect rect = [view bounds];
            [actionSheet showFromRect:rect inView:view animated:YES];
            
            [self setActionSheet:actionSheet];
        }
    }
}

-(void)normalPressTap:(id)sender
{
    NoteEditorViewController *controller = [[NoteEditorViewController alloc] initWithNote:[self note] andDelegate:self];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    [self presentModalViewController:controller animated:YES];
}

#pragma mark - UIActionSheetDelegate Methods

- (void)actionSheet:(UIActionSheet *)actionSheet 
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[self view] removeFromSuperview];
            [[BNoteWriter instance] removeNote:[self note]];
            [[self delegate] noteDeleted:self];
            break;
        case 1:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setActionSheet:nil];
}

#pragma mark NoteEditorViewController

- (void)didFinish:(NoteEditorViewController *)controller
{
    [[self subject] setText:[[self note] subject]];
    [[BNoteWriter instance] update];
    [[self delegate] noteUpdated:self];
}

- (void)didCancel:(NoteEditorViewController *)controller
{
    
}


@end
