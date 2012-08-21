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
#import "BNoteSessionData.h"
#import "BNoteWriter.h"
#import "EntryConverterHelper.h"
#import "BNoteAnimation.h"

@interface EntryContentViewController ()

@property (strong, nonatomic) IBOutlet UIView *entryMarginView;
@property (strong, nonatomic) QuickWordsViewController *quickWordsViewController;

@end

@implementation EntryContentViewController
@synthesize entry = _entry;
@synthesize quickWordsViewController = _quickWordsViewController;
@synthesize selectedTextView = _selectedTextView;
@synthesize mainTextView = _mainTextView;
@synthesize iconView = _iconView;
@synthesize entryMarginView = _entryMarginView;

- (id)initWithEntry:(Entry *)entry
{
    self = [super initWithNibName:[self localNibName] bundle:nil];
    
    if (self) {
        [self setEntry:entry];
    }
    
    return self;
}

- (NSString *)localNibName
{
    return nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self handleImageIcon:NO];
    
    if (![self.entry isKindOfClass:[Attendants class]]) {
        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showEntryOptions:)];
        [[self entryMarginView] addGestureRecognizer:tap];
    }

    if ([[BNoteSessionData instance] editingNote]) {
        [self showControls];
    } else {
        [self hideControls];
    }

    UITextView *view = [self mainTextView];
    if (view) {
        [self setSelectedTextView:view];
        [view setText:[[self entry] text]];
        
        [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
        [view setTextColor:UIColorFromRGB(0x444444)];
        [view setClipsToBounds:YES];
        [view setScrollEnabled:NO];
        view.delegate = self;
        
        QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntryContent:self];
        [self setQuickWordsViewController:quick];
        [[self mainTextView] setInputAccessoryView:[quick view]];
    }

    [LayerFormater setBorderWidth:0.5 forView:self.view];
    [LayerFormater setBorderColorWithInt:0xcccccc forView:self.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewMode:)
                                                 name:kReviewingNote object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingNote:)
                                                 name:kEditingNote object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setMainTextView:nil];
    [self setIconView:nil];
    [self setEntryMarginView:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (float)height
{
    UITextView *view = [[UITextView alloc] init];
    [view setText:[[self entry] text]];
    [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
    [view setFrame:CGRectMake(0, 0, [self width] - 100, 40)];
    
    return MAX(80, [view contentSize].height + 10);
}

- (float)width
{
    float width = 900;
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation)) {
        width = 600;
    }
    
    return width;
}

- (void)handleImageIcon:(BOOL)active
{
    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:active];
    [[self iconView] setImage:[imageView image]];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [textView setScrollEnabled:YES];
    [self handleImageIcon:YES];
    [self setSelectedTextView:textView];
    [[self quickWordsViewController] selectFirstButton];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [[self entry] setText:textView.text];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView setScrollEnabled:NO];
    [self handleImageIcon:NO];
    
    NSString *text = [textView text];
    if ([BNoteStringUtils nilOrEmpty:text]) {
        [[self entry] setText:nil];
    } else {
        [[self entry] setText:text];
    }
    
    [[BNoteWriter instance] update];
    
    [textView setInputAccessoryView:nil];
    [self setQuickWordsViewController:nil];
}

- (UITableViewCell *)cell
{
    return (UITableViewCell *) [self view];
}

- (void)reviewMode:(NSNotification *)notification
{
    [self hideControls];
    [[self mainTextView] resignFirstResponder];
}

- (void)editingNote:(NSNotification *)notification
{
    [self showControls];
}

- (void)showEntryOptions:(id)sender
{
    [[EntryConverterHelper instance] handleConvertion:[self entry] withinView:[self entryMarginView]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)hideControls
{
}

- (void)showControls
{
}

- (void)detatchFromNotificationCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
