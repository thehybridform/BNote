//
//  EntryTableCellBasis.m
//  BeNote
//
//  Created by Young Kristin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryTableCellBasis.h"
#import "BNoteWriter.h"
#import "BNoteFactory.h"
#import "QuickWordsViewController.h"

@interface EntryTableCellBasis()
@property (strong, nonatomic) QuickWordsViewController *quickWordsViewController;

@end

@implementation EntryTableCellBasis
@synthesize entry = _entry;
@synthesize textView = _textView;
@synthesize targetTextView = _targetTextView;
@synthesize parentController = _parentController;
@synthesize quickWordsViewController = _quickWordsViewController;
@synthesize detail = _detail;

const float x = 100;
const float y = 10;

- (id)initWithIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [[NSNotificationCenter defaultCenter]
            addObserver:self selector:@selector(updateText:)
            name:UITextViewTextDidChangeNotification object:[[self textView] window]];
        
        [[NSNotificationCenter defaultCenter]
            addObserver:self selector:@selector(keyboardWillHide:)
            name:UIKeyboardWillHideNotification object:nil];

        [self setEditingAccessoryType:UITableViewCellAccessoryNone];
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return self;
}

- (void)setEntry:(Entry *)entry
{
    _entry = entry;
    
    UITextView *text = [[UITextView alloc] init];
    [self setTextView:text];
    [self addSubview:[self textView]];
    [text setText:[entry text]];
    [text setBackgroundColor:[BNoteConstants appColor1]];
    [text setShowsVerticalScrollIndicator:YES];
    [text setShowsHorizontalScrollIndicator:YES];
    [text setAlwaysBounceHorizontal:YES];
    [text setAlwaysBounceVertical:YES];
        
    [text setAutoresizingMask:(UIViewAutoresizingFlexibleRightMargin |
                               UIViewAutoresizingFlexibleBottomMargin |
                               UIViewAutoresizingFlexibleHeight |
                               UIViewAutoresizingFlexibleWidth)];
    
    float width = [[self contentView] frame].size.width - x - 75;
    
    CGRect rect = CGRectMake(x, y, width, 10);
    UILabel *detail = [[UILabel alloc] initWithFrame:rect];
    [detail setFont:[UIFont systemFontOfSize:12]];
//    [self addSubview:detail];
    [detail setTextColor:UIColorFromRGB(0x336633)];
    [self setDetail:detail];
    [detail setBackgroundColor:[BNoteConstants appColor1]];
    [detail setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
    [self updateDetail];
    [self handleImageIcon:NO];

    float hieght = [BNoteStringUtils textHieght:[entry text] inView:self];
    
    [text setFrame:CGRectMake(x, y, width, hieght)];
    [text setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin)];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[self contentView] frame]];
    [backgroundView setBackgroundColor:[BNoteConstants appColor1]];
    [self setSelectedBackgroundView:backgroundView];
    
    [[self textLabel] setBackgroundColor:[UIColor clearColor]];
    [[self textView] setBackgroundColor:[UIColor clearColor]];
    
    [self bringSubviewToFront:[self contentView]];
}

- (void)keyboardWillHide:(NSNotification *)notetification
{
    [self unfocus];
}

// width 839
- (void)updateText:(NSNotification *)notification
{
    UITextView *textView = [self textView];
    if ([notification object] == textView) {
        NSString *text = [BNoteStringUtils trim:[textView text]];
    
        if ([BNoteStringUtils nilOrEmpty:text]) {
            text = nil;
        }
    
        [[self entry] setText:text];
    
        UIView *cell = self;
        float x = [cell frame].origin.x;
        float y = [cell frame].origin.y;
        float width = [cell frame].size.width;
        float height = [textView contentSize].height + 10;
    
        CGRect rect = CGRectMake(x, y, width, height);
        [cell setFrame:CGRectMake(x, y, width, height)];
    
        x = [textView frame].origin.x;
        y = [textView frame].origin.y;
        width = [textView frame].size.width;
        rect = CGRectMake(x, y, width, height);
        [textView setFrame:rect];
    }
}

- (void)focus
{
    QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithCell:self];
    [self setQuickWordsViewController:quick];
    [[self textView] setInputAccessoryView:[quick view]];
    [quick selectFirstButton];
    
    [self handleImageIcon:YES];
    
    [self setTargetTextView:[self textView]];
    
    [self bringSubviewToFront:[self textView]];
    [[self textView] becomeFirstResponder];
}

- (void)unfocus
{
    [[BNoteWriter instance] update];
    [self handleImageIcon:NO];
    [self bringSubviewToFront:[self contentView]];
}

- (void)handleImageIcon:(BOOL)active
{
    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:active];
    [[self imageView] setImage:[imageView image]];
}

- (void)updateDetail
{
    // implemented by subclass
}

@end
