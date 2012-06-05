//
//  NoteView.m
//  BNote
//
//  Created by Young Kristin on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NoteView.h"
#import "Topic.h"
#import "LayerFormater.h"
#import "NoteEditorViewController.h"

@interface NoteView()
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UILabel *time;

@end

@implementation NoteView
@synthesize title = _title;
@synthesize date = _date;
@synthesize time = _time;
@synthesize actionSheet = _actionSheet;
@synthesize note = _note;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        UILabel *date = [[UILabel alloc] init];
        [date setFrame:CGRectMake(0, 0, 100, 25)];
        [date setTextAlignment:UITextAlignmentCenter];
        [date setFont:[UIFont systemFontOfSize:14]];
        [self setDate:date];
        
        UILabel *time = [[UILabel alloc] init];
        [time setFrame:CGRectMake(0, 75, 100, 25)];
        [time setTextAlignment:UITextAlignmentRight];
        [time setFont:[UIFont systemFontOfSize:14]];
        [self setTime:time];
        
        UILabel *title = [[UILabel alloc] init];
        [title setFrame:CGRectMake(0, 33, 100, 30)];
        [title setTextAlignment:UITextAlignmentCenter];
        [title setFont:[UIFont systemFontOfSize:16]];
        [title setNumberOfLines:2];
        [title setBackgroundColor:UIColorFromRGB(0xf5f3e6)];
        [self setTitle:title];
        
        [LayerFormater setBorderWidth:1 forView:self];
        [LayerFormater setBorderColor:[UIColor blackColor] forView:self];
        [LayerFormater roundCornersForView:self];
        
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTap:)];
        [self addGestureRecognizer:longPress];
        
        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalPressTap:)];
        [self addGestureRecognizer:tap];
        
        [self addSubview:date];
        [self addSubview:time];
        [self addSubview:title];
    }
    
    return self;
}

- (void)setNote:(Note *)note
{
    _note = note;
    
    [[self date] setBackgroundColor:UIColorFromRGB([[note topic] color])]; 
    [[self time] setBackgroundColor:UIColorFromRGB([[note topic] color])]; 
    
    if ([note subject]) {
        [[self title] setText:[note subject]];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[note created]];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    [format setDateFormat:@"MMMM dd, YYYY"];
    NSString *dateString = [format stringFromDate:date];
    [[self date] setText:dateString];
    
    [format setDateFormat:@"hh:mm aaa"];
    NSString *timeString = [format stringFromDate:date];
    [[self time] setText:timeString];
}

-(void)longPressTap:(id)sender
{
    if (![self actionSheet]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Note" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove" otherButtonTitles:nil];
        [self setActionSheet:actionSheet];
    
        CGRect rect = [self bounds];
        [actionSheet showFromRect:rect inView:self animated:YES];
    }
}

-(void)normalPressTap:(id)sender
{
    NoteEditorViewController *controller = [[NoteEditorViewController alloc] initWithNote:[self note]];
    [controller setDelegate:(id<NoteEditorViewControllerDelegate>) [self delegate]];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];

    UIViewController *parent = (UIViewController *) [self delegate];
    [parent presentModalViewController:controller animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[self delegate] deleteNote:[self note]];
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setActionSheet:nil];
}

@end