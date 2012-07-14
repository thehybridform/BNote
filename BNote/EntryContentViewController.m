//
//  EntryContentViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryContentViewController.h"
#import "QuickWordsViewController.h"
#import "LayerFormater.h"
#import "BNoteFactory.h"

@interface EntryContentViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UITextView *mainTextView;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
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
@synthesize selectedTextView = _selectedTextView;

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];            
}

- (CGFloat)height
{
    float height = [[self mainTextView] contentSize].height;

    return MAX(100, height);
}

- (CGFloat)width
{
    CGFloat width = 1000;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation)) {
        width = 600;
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

    [[self mainTextView] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    [[self detailTextView] setFont:[BNoteConstants font:RobotoRegular andSize:12]];

    [self handleImageIcon:NO];
    [self showMainText];
    [self showDetailText];
        
    if (![[self entry] isKindOfClass:[Attendants class]]) {
        QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithCell:self];
        [self setQuickWordsViewController:quick];
        [[self mainTextView] setInputAccessoryView:[quick view]];
    }

    [self updateCellFrame];
}

- (void)updateCellFrame
{
    float height = [self height];
    float width = [self width];
    float x = 0;
    float y = 0;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [[self view] setFrame:frame];
    
    frame = CGRectMake(x + 110, y, width - 110, height);
    [[self mainTextView] setFrame:frame];
    [[self mainTextView] setContentSize:CGSizeMake(width, height)];
    
    [[self view] setNeedsDisplay];
}

- (void)showMainText
{
    [[self mainTextView] setText:[[self entry] text]];
}

- (void)showDetailText
{
    [[self detailTextView] setText:[self detail]];
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
    if ([notification object] == [self mainTextView] || [notification object] == [self detailTextView]) {
        [self handleImageIcon:YES];
        [self setSelectedTextView:[self mainTextView]];
        [[self quickWordsViewController] selectFirstButton];
    }
}

- (void)stoppedEditingText:(NSNotification *)notification
{
    if ([notification object] == [self mainTextView] || [notification object] == [self detailTextView]) {
        [self handleImageIcon:NO];
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

- (void)updateDetail
{
    // handled by sub class
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    // handled by sub class
}

@end
