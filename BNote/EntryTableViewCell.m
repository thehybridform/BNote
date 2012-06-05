//
//  EntryTableViewCell.m
//  BNote
//
//  Created by Young Kristin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryTableViewCell.h"
#import "LayerFormater.h"
#import "Topic.h"
#import "Note.h"
#import "Question.h"
#import "ActionItem.h"
#import "KeyPoint.h"
#import "Decision.h"
#import "Attendant.h"
#import "BNoteFactory.h"
#import "BNoteStringUtils.h"

@interface EntryTableViewCell()

@end

@implementation EntryTableViewCell
@synthesize entry = _entry;
@synthesize textView = _textView;
@synthesize subTextView = _subTextView;
@synthesize photosScrollView = _photosScrollView;
@synthesize targetTextView = _targetTextView;

const float x = 65;
const float y = 5;

- (id)initWithIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setTextView:[[UITextView alloc] init]];
        [[self textView] setAutoresizingMask:[[self textLabel] autoresizingMask]];
        [LayerFormater roundCornersForView:[self textView]];
        [[self contentView] addSubview:[self textView]];
        [[self textView] setFont:[UIFont systemFontOfSize:15]];
        [[self textView] setHidden:YES];

        [self setSubTextView:[[UITextView alloc] init]];
        [[self subTextView] setAutoresizingMask:[[self subTextView] autoresizingMask]];
        [LayerFormater roundCornersForView:[self subTextView]];
        [LayerFormater setBorderWidth:5 forView:[self subTextView]];
        [LayerFormater setBorderColor:UIColorFromRGB(0x336633) forView:[self subTextView]];
        [[self contentView] addSubview:[self subTextView]];
        [[self subTextView] setFont:[UIFont systemFontOfSize:15]];
        [[self subTextView] setHidden:YES];

        [[self textLabel] setFont:[UIFont systemFontOfSize:15]];
        [[self textLabel] setLineBreakMode:UILineBreakModeWordWrap];
        [[self textLabel] setHighlightedTextColor:[UIColor blackColor]];
        
        [[self detailTextLabel] setTextColor:UIColorFromRGB(0x336633)];
        [[self detailTextLabel] setHighlightedTextColor:UIColorFromRGB(0x336633)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:)
                                                     name:UITextViewTextDidEndEditingNotification object:[[self textView] window]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:)
                                                     name:UITextViewTextDidChangeNotification object:[[self textView] window]];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSubText:)
                                                     name:UITextViewTextDidEndEditingNotification object:[[self subTextView] window]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSubText:)
                                                     name:UITextViewTextDidChangeNotification object:[[self subTextView] window]];

        [self setPhotosScrollView:[[UIScrollView alloc] init]];
        
    }
    
    return self;
}

- (void)setEntry:(Entry *)entry
{
    _entry = entry;
    
    [[self textView] setText:[entry text]];
    [[self textLabel] setText:[entry text]];
    
    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:NO];
    [[self imageView] setImage:[imageView image]];
                              
    [self handleQuestionType:entry];
    [self handleActionItemType:entry];    
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[self contentView] frame]];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self setSelectedBackgroundView:backgroundView];

    [[self textLabel] setNumberOfLines:[BNoteStringUtils lineCount:[entry text]]];

    [self setNeedsDisplay];
}

- (void)edit
{
    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:YES];
    [[self imageView] setImage:[imageView image]];

    [[self textLabel] setHidden:YES];
    [[self detailTextLabel] setHidden:YES];

    [[self textView] setText:[[self entry] text]];
    [[self textView] setHidden:NO];
    
    float width = [[self contentView] frame].size.width - 70;
    float hieght = [[self contentView] frame].size.height - 10;
    
    [[self textView] setFrame:CGRectMake(x, y, width, hieght)];
    
    [self setTargetTextView:[self textView]];
    
    [[self textView] becomeFirstResponder];
}

- (void)finishedEdit
{
    [[self textView] resignFirstResponder];

    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:NO];
    [[self imageView] setImage:[imageView image]];

    [[self textView] setHidden:YES];
    [[self textLabel] setHidden:NO];
    [[self detailTextLabel] setHidden:NO];
    
    float x = [[self textLabel] frame].origin.x;
    float y = [[self textLabel] frame].origin.y;
    float height = [[self textLabel] frame].size.height;
    float width = [[self textView] frame].size.width;
    
    [[self textLabel] setFrame:CGRectMake(x, y, width, height)];
    
    [[self textLabel] setNumberOfLines:[BNoteStringUtils lineCount:[[self entry] text]]];
    [self handleQuestionType:[self entry]];
    [self handleActionItemType:[self entry]];    

    [self setNeedsDisplay];
}

- (void)updateText:(id)sender
{
    NSString *text = [BNoteStringUtils trim:[[self textView] text]];
    [[self entry] setText:text];
    [[self textLabel] setText:text];    
}

- (void)updateSubText:(id)sender
{
    if ([[self entry] isKindOfClass:[Question class]]) {
        Question *question = (Question *) [self entry];
        NSString *text = [BNoteStringUtils trim:[[self subTextView] text]];
        [question setAnswer:text];
        [[self detailTextLabel] setText:text];
    }
}

- (void)handleQuestionType:(Entry *)entry
{
    if ([entry isKindOfClass:[Question class]]) {
        Question *question = (Question *) entry;
        if ([question answer]) {
            [[self detailTextLabel] setText:[question answer]];
        } else {
            [[self detailTextLabel] setText:nil];
        }
    }
}

- (void)handleActionItemType:(Entry *)entry
{
    if ([entry isKindOfClass:[ActionItem class]]) {
        ActionItem *actionItem = (ActionItem *) entry;
        if ([actionItem completed]) {
            NSDate *completed = [NSDate dateWithTimeIntervalSinceReferenceDate:[actionItem completed]]; 
            NSString *date = [@"Completed on " stringByAppendingString:[BNoteStringUtils dateToString:completed]];
            [[self detailTextLabel] setText:date];
        } else {
            [[self detailTextLabel] setText:nil];
        }
    }
    
}

@end
