//
//  EntryReviewViewController.m
//  BNote
//
//  Created by Young Kristin on 5/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryReviewViewController.h"
#import "LayerFormater.h"
#import "Note.h"
#import "Topic.h"
#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "BNoteSessionData.h"

@interface EntryReviewViewController ()
@property (strong, nonatomic) Entry *entry;
@property (assign, nonatomic) BOOL editingEntry;

@end

@implementation EntryReviewViewController
@synthesize entry = _entry;
@synthesize imageView = _imageView;
@synthesize imageViewParent = _imageViewParent;
@synthesize textLable = _textLable;
@synthesize entryReviewViewControllerDelegate = _entryReviewViewControllerDelegate;
@synthesize editingEntry = _editingEntry;
@synthesize textView = _textView;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setEntry:nil];
    [self setImageView:nil];
    [self setImageViewParent:nil];
    [self setTextLable:nil];
    [self setEntryReviewViewControllerDelegate:nil];
}

- (id)initWithEntry:(Entry *)entry
{
    self = [super initWithNibName:@"EntryReviewViewController" bundle:nil];
    if (self) {
        [self setEntry:entry];
        [self setEditingEntry:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self imageView] setImage:[[BNoteFactory createIcon:[self entry] active:NO] image]];
    [[self imageViewParent] setBackgroundColor:UIColorFromRGB([[[[self entry] note] topic] color])];
    [[self textLable] setText:[[self entry] text]];
    [[self textView] setText:[[self entry] text]];
    [[self textView] setHidden:YES];

    [LayerFormater setBorderWidth:1 forView:[self view]];
    [LayerFormater roundCornersForView:[self view]];
    [LayerFormater roundCornersForView:[self textView]];
    [LayerFormater setBorderColor:[UIColor blackColor] forView:[self view]];
    
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
    [[self view] addGestureRecognizer:tap];
}

- (void)doublePressTap:(id)sender
{
    [[BNoteSessionData instance] setCurrentEntryReviewViewController:self];

    UIGestureRecognizer *gesture = (UIGestureRecognizer *) sender;
    CGPoint location = [gesture locationInView:[self view]];
    CGRect rect = CGRectMake(location.x, location.y, 1, 1);
    [[self entryReviewViewControllerDelegate] presentActionSheetForController:rect];
}

- (void)normalPressTap:(id)sender
{
    if ([[BNoteSessionData instance] canEditEntry] && ![self editingEntry]) {
        [self setupForEditing];
    } else {
        [self setupForReviewing];
    }
}

-(void)longPressTap:(id)sender
{
    NSLog(@"longPressTap");
}

- (void)setupForEditing
{
    [[BNoteSessionData instance] setCurrentEntryReviewViewController:self];
    [[self entryReviewViewControllerDelegate] selectedController];

    [self setEditingEntry:YES];
    [[self textView] setHidden:NO];
    [[self textLable] setHidden:YES];
    [[self imageView] setImage:[[BNoteFactory createIcon:[self entry] active:YES] image]];
    
    [[self textView] setText:[[self entry] text]];
}

- (void)setupForReviewing
{
    [[self textView] resignFirstResponder];
    [self setEditingEntry:NO];
    [[self textView] setHidden:YES];
    [[self textLable] setHidden:NO];
    [[self imageView] setImage:[[BNoteFactory createIcon:[self entry] active:NO] image]];
    
    [[self textLable] setText:[[self textView] text]];
    [[self entry] setText:[[self textView] text]];
    [[BNoteWriter instance] update];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
