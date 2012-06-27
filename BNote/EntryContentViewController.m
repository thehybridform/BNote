//
//  EntryContentViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryContentViewController.h"
#import "LayerFormater.h"
#import "QuickWordsViewController.h"
#import "BNoteFactory.h"

@interface EntryContentViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *mainTextView;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) QuickWordsViewController *quickWordsViewController;
@property (assign, nonatomic) Entry *entry;

@end

@implementation EntryContentViewController
@synthesize mainTextView = _mainTextView;
@synthesize detailTextView = _detailTextView;
@synthesize entry = _entry;
@synthesize quickWordsViewController = _quickWordsViewController;
@synthesize imageView = _imageView;
@synthesize scrollView = _scrollView;
@synthesize parentController = _parentController;

- (id)initWithEntry:(Entry *)entry
{
    self = [super initWithNibName:@"EntryContentViewController" bundle:nil];
    if (self) {
        [self setEntry:entry];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(updateText:)
         name:UITextViewTextDidChangeNotification object:[[self mainTextView] window]];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(startedEditingText:)
         name:UITextViewTextDidBeginEditingNotification object:[[self mainTextView] window]];
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(stoppedEditingText:)
         name:UITextViewTextDidEndEditingNotification object:[[self mainTextView] window]];

        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [[self view] addGestureRecognizer:tap];
    }
    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    // handled by sub class
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];            
}

- (Entry *)entry
{
    return _entry;
}

- (CGFloat)height
{
    float height = 0;
    if (![[self mainTextView] isHidden]) {
        height += [[self mainTextView] contentSize].height;
    }
    
    if (![[self detailTextView] isHidden]) {
        height += [[self detailTextView] contentSize].height;
    }
    
    return MAX(100, height);
}

- (CGFloat)width
{
    CGFloat width = 700;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (orientation & (UIDeviceOrientationPortrait | UIDeviceOrientationPortraitUpsideDown)) {
        width = 470;
    }
    
    return width;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self view] setBackgroundColor:[UIColor clearColor]];
    [[self mainTextView] setBackgroundColor:[UIColor clearColor]];
    [[self detailTextView] setBackgroundColor:[UIColor clearColor]];
    [[self scrollView] setBackgroundColor:[UIColor clearColor]];

    [self handleImageIcon:NO];
    [[self mainTextView] setText:[[self entry] text]];
    [[self detailTextView] setText:[self detail]];
    
    CGFloat width = [[self view] frame].size.width;
    CGFloat height = [self height];
    CGRect rect = CGRectMake(0, 0, width, height);
    [[self view] setFrame:rect];
    
    QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithCell:self];
    [self setQuickWordsViewController:quick];
    [[self mainTextView] setInputAccessoryView:[quick view]];
}

- (void)handleImageIcon:(BOOL)active
{
    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:active];
    [[self imageView] setImage:[imageView image]];
}

- (NSString *)detail
{
    return nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setMainTextView:nil];
    [self setDetailTextView:nil];
    [self setImageView:nil];
    [self setQuickWordsViewController:nil];
}

- (void)startedEditingText:(NSNotification *)notification
{
    if ([notification object] == [self mainTextView]) {
        [[self quickWordsViewController] selectFirstButton];
    }
}

- (void)stoppedEditingText:(NSNotification *)notification
{
    if ([notification object] == [self mainTextView]) {
    }
}

- (void)updateText:(NSNotification *)notification
{
    if ([notification object] == [self mainTextView]) {
        NSString *text = [[self mainTextView] text];
        if (![BNoteStringUtils nilOrEmpty:text]) {
            [[self entry] setText:text];
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
