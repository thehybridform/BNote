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
#import "BNoteSessionData.h"
#import "BNoteAnimation.h"

@interface EntryReviewViewController ()
@property (strong, nonatomic) Entry *entry;
@property (assign, nonatomic) CGAffineTransform currentTransform;
@end

@implementation EntryReviewViewController
@synthesize entry = _entry;
@synthesize imageView = _imageView;
@synthesize imageViewParent = _imageViewParent;
@synthesize textLable = _textLable;
@synthesize entryReviewViewControllerDelegate = _entryReviewViewControllerDelegate;
@synthesize textView = _textView;
@synthesize deleteButton = _deleteButton;
@synthesize currentTransform = _currentTransform;
@synthesize deleteMaskView = _deleteMaskView;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setEntry:nil];
    [self setImageView:nil];
    [self setImageViewParent:nil];
    [self setTextLable:nil];
    [self setEntryReviewViewControllerDelegate:nil];
    [self setDeleteButton:nil];
    [self setDeleteMaskView:nil];
}

- (id)initWithEntry:(Entry *)entry
{
    self = [super initWithNibName:@"EntryReviewViewController" bundle:nil];
    if (self) {
        [self setEntry:entry];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self storeCurrentTransform];
    [self setupForReviewing];
    
    [[self imageViewParent] setBackgroundColor:UIColorFromRGB([[[[self entry] note] topic] color])];

    [LayerFormater setBorderWidth:1 forView:[self view]];
    [LayerFormater roundCornersForView:[self view]];
    [LayerFormater roundCornersForView:[self textView]];
    [LayerFormater setBorderColor:[UIColor blackColor] forView:[self view]];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishedTextEntry:)
                                                 name:UITextViewTextDidEndEditingNotification object:[[self textView] window]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatedTextEntry:)
                                                 name:UITextViewTextDidChangeNotification object:[[self textView] window]];
}

- (void)storeCurrentTransform
{
    [self setCurrentTransform:[[self view] transform]];
}

- (void)normalPressTap:(id)sender
{
    if ([self isEditingEntry]) {
        [self setupForReviewing];
    } else {
        [[BNoteSessionData instance] setCurrentEntryReviewViewController:self];
        [[self entryReviewViewControllerDelegate] selectedController];
        [[self imageView] setImage:[[BNoteFactory createIcon:[self entry] active:YES] image]];
        
        [[self textLable] setHidden:YES];
        
        UITextView *textView = [self textView];
        [textView setText:[[self entry] text]];
        [textView setHidden:NO];
        [textView becomeFirstResponder];
        
        [[self entryReviewViewControllerDelegate] editCandidate:self];
    }
}

-(void)longPressTap:(id)sender
{
    if (![self isDeletingEntry]) {
        [[BNoteSessionData instance] setCurrentEntryReviewViewController:self];
        [[self entryReviewViewControllerDelegate] deleteCandidate:self];
    }
}

- (void)setupForDelete
{
    [BNoteAnimation startWobble:[self view]];
    [[self deleteMaskView] setHidden:NO];
    [[self deleteButton] setHidden:NO];
    [[self deleteButton] becomeFirstResponder];
    
    [[self textView] resignFirstResponder];
}

- (void)setupForReviewing
{
    [[self deleteButton] setHidden:YES];
    [[self deleteMaskView] setHidden:YES];
    
    [[self textView] setHidden:YES];
    [[self textView] setText:[[self entry] text]];
    [[self textView] resignFirstResponder];
    
    [[self textLable] setHidden:NO];
    [[self textLable] setText:[[self entry] text]];
    
    [[self imageView] setImage:[[BNoteFactory createIcon:[self entry] active:NO] image]];
    
    [[self view] setTransform:[self currentTransform]];
    [[[self view] layer] removeAllAnimations];

    UITapGestureRecognizer *normalTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalPressTap:)];
    [[self imageViewParent] addGestureRecognizer:normalTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTap:)];
    [[self view] addGestureRecognizer:longPress];
}

- (IBAction)deleteEntry:(id)sender
{
    [[self entryReviewViewControllerDelegate] deletedEntry:self];
}

- (void)finishedTextEntry:(NSNotification *)notification
{
    UITextView *textView = [self textView];
    [[self entry] setText:[textView text]];
    [[self textLable] setText:[[self entry] text]];
    [self setupForReviewing];
}
- (void)updatedTextEntry:(NSNotification *)notification
{
    UITextView *textView = [self textView];
    [[self entry] setText:[textView text]];
    [[self textLable] setText:[[self entry] text]];
}

- (BOOL)isEditingEntry
{
    return ![[self textView] isHidden];
}

- (BOOL)isDeletingEntry
{
    return ![[self deleteButton] isHidden];
}

- (void)startEditing
{
    [self normalPressTap:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
