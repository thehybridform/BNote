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

@interface EntryContentViewController ()

@end

@implementation EntryContentViewController
@synthesize entry = _entry;
@synthesize quickWordsViewController = _quickWordsViewController;
@synthesize parentController = _parentController;
@synthesize selectedTextView = _selectedTextView;
@synthesize mainTextView = _mainTextView;
@synthesize iconView = _iconView;

- (id)initWithEntry:(Entry *)entry
{
    self = [super initWithNibName:[self localNibName] bundle:nil];
    
    if (self) {
        [self setEntry:entry];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewMode:)
                                                     name:ReviewingNote object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingNote:)
                                                     name:EditingNote object:nil];

        UITableViewCell *cell = (UITableViewCell *) [self view];
        [cell setEditingAccessoryType:UITableViewCellEditingStyleNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [self handleImageIcon:NO];
        
        UITextView *view = [self mainTextView];
        if (view) {
            [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
            [view setTextColor:UIColorFromRGB(0x444444)];
            [view setClipsToBounds:YES];
            [view setScrollEnabled:NO];
            
            QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntryContent:self];
            [self setQuickWordsViewController:quick];
            [view setInputAccessoryView:[quick view]];

            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:)
                                                         name:UITextViewTextDidChangeNotification object:view];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedEditingText:)
                                                         name:UITextViewTextDidBeginEditingNotification object:view];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stoppedEditingText:)
                                                         name:UITextViewTextDidEndEditingNotification object:view];
            
            [self setSelectedTextView:view];
            [[self mainTextView] setText:[[self entry] text]];
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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setMainTextView:nil];
    [self setIconView:nil];
}

- (float)height
{
    UITextView *view = [[UITextView alloc] init];
    [view setText:[[self entry] text]];
    [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
    [view setFrame:CGRectMake(0, 0, [self width] - 100, 50)];
    
    return MAX(40, [view contentSize].height + 10);
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

- (void)startedEditingText:(NSNotification *)notification
{
    if ([notification object] == [self mainTextView]) {
//        [[self mainTextView] setClipsToBounds:NO];
        [[self mainTextView] setScrollEnabled:YES];
        [self handleImageIcon:YES];
        [self setSelectedTextView:[self mainTextView]];
        [[self quickWordsViewController] selectFirstButton];
    }
}

- (void)stoppedEditingText:(NSNotification *)notification
{
    if ([notification object] == [self mainTextView]) {
//        [[self mainTextView] setClipsToBounds:YES];
        [[self mainTextView] setScrollEnabled:NO];
        [self handleImageIcon:NO];
    }
}

- (void)updateText:(NSNotification *)notification
{
    if ([notification object] == [self mainTextView]) {
        NSString *text = [[self mainTextView] text];
        if ([BNoteStringUtils nilOrEmpty:text]) {
            [[self entry] setText:nil];
        } else {
            [[self entry] setText:text];
        }
    }
}

- (UITableViewCell *)cell
{
    return (UITableViewCell *) [self view];
}

- (void)reviewMode:(NSNotification *)notification
{
    [[self mainTextView] resignFirstResponder];
    [[self mainTextView] setEditable:NO];
}

- (void)editingNote:(NSNotification *)notification
{
    [[self mainTextView] setEditable:YES];

    [[self view] setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];            
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
