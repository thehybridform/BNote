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
#import "BNoteWriter.h"
#import "EntryConverterHelper.h"

const float kDefaultCellHeight = 50;

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
        
        if (![entry isKindOfClass:[Attendants class]]) {
            UITextView *textView = [[UITextView alloc] init];
            self.mainTextView = textView;

            [self setSelectedTextView:textView];
            [textView setText:[[self entry] text]];

            [textView setFont:[BNoteConstants font:RobotoRegular andSize:16]];
            [textView setTextColor:UIColorFromRGB(0x444444)];
            [textView setClipsToBounds:YES];
            [textView setScrollEnabled:NO];
            textView.delegate = self;

            textView.frame = CGRectMake(104, 0, 600, 90);
            [[self cell].contentView addSubview:textView];

            [self reset];
        }
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

    [LayerFormater setBorderWidth:0 forView:self.view];
    [LayerFormater setBorderColorWithInt:0xcccccc forView:self.view];
    
    self.mainTextView.frame = [self makeFrame:self.mainTextView];
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
    return MAX(kDefaultCellHeight, self.mainTextView.contentSize.height);
}

- (float)width
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsPortrait(orientation)) {
        return 600;
    }
    
    return 900;
}

- (void)handleImageIcon:(BOOL)active
{
    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:active];
    [[self iconView] setImage:[imageView image]];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    [[[self cell] superview] bringSubviewToFront:[self cell]];

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

    NSString *text = [BNoteStringUtils trim:textView.text];
    if ([BNoteStringUtils nilOrEmpty:text]) {
        [[self entry] setText:nil];
        textView.text = nil;
    } else {
        [[self entry] setText:text];
        textView.text = text;
    }

    textView.frame = [self makeFrame:textView];

    [[BNoteWriter instance] update];
}

- (CGRect)makeFrame:(UITextView *)textView
{
    float height;
    if ([BNoteStringUtils nilOrEmpty:textView.text]) {
        height = kDefaultCellHeight;
    } else {
        height = MAX(kDefaultCellHeight, textView.contentSize.height);
    }

    return CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.contentSize.width, height);
}

- (UITableViewCell *)cell
{
    return (UITableViewCell *) [self view];
}

- (void)showEntryOptions:(id)sender
{
    [self resign];

    EntryConverterHelper *helper = [[EntryConverterHelper alloc] init];
    [helper handleConvertion:[self entry] withinView:[self entryMarginView]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)reset
{
    [self resign];

    QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntryContent:self];
    quick.delegate = self;
    self.quickWordsViewController = quick;
    self.mainTextView.inputAccessoryView = quick.view;
}

- (NSArray *)quickActionButtons
{
    return nil;
}

- (void)detachFromNotificationCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)resign
{
    [self.mainTextView resignFirstResponder];
}

@end
