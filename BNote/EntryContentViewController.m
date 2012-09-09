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

const int kDefaultCellHeight = 60;

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
            
            textView.frame = CGRectMake(104, 5, 600, 90);
            [[self cell].contentView addSubview:textView];
            
            textView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

            [self setSelectedTextView:textView];
            [textView setText:[[self entry] text]];
            
            [textView setFont:[BNoteConstants font:RobotoRegular andSize:16]];
            [textView setTextColor:UIColorFromRGB(0x444444)];
            [textView setClipsToBounds:YES];
            [textView setScrollEnabled:NO];
            textView.delegate = self;
            
            QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntryContent:self];
            quick.delegate = self;
            self.quickWordsViewController = quick;
            self.mainTextView.inputAccessoryView = quick.view;
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
    
    [[BNoteWriter instance] update];
}

- (UITableViewCell *)cell
{
    return (UITableViewCell *) [self view];
}

- (void)reviewMode:(NSNotification *)notification
{
    [[self mainTextView] resignFirstResponder];
}

- (void)editingNote:(NSNotification *)notification
{

}

- (void)showEntryOptions:(id)sender
{
    [[EntryConverterHelper instance] handleConvertion:[self entry] withinView:[self entryMarginView]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSArray *)quickActionButtons
{
    return nil;
}

- (void)detachFromNotificationCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
