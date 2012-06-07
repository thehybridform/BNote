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
#import "BNoteWriter.h"
#import "PhotoViewController.h"
#import "EntriesViewController.h"

@interface EntryTableViewCell()
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@end

@implementation EntryTableViewCell
@synthesize entry = _entry;
@synthesize textView = _textView;
@synthesize subTextView = _subTextView;
@synthesize targetTextView = _targetTextView;
@synthesize parentController = _parentController;
@synthesize actionSheet = _actionSheet;
@synthesize longPress = _longPress;

const float x = 100;
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
        [LayerFormater setBorderColor:UIColorFromRGB(AnswerColor) forView:[self subTextView]];
        [[self contentView] addSubview:[self subTextView]];
        [[self subTextView] setFont:[UIFont systemFontOfSize:15]];
        [[self subTextView] setHidden:YES];

        [[self textLabel] setFont:[UIFont systemFontOfSize:15]];
        [[self textLabel] setLineBreakMode:UILineBreakModeWordWrap];
        [[self textLabel] setHighlightedTextColor:[UIColor blackColor]];
        
        [[self detailTextLabel] setTextColor:UIColorFromRGB(AnswerColor)];
        [[self detailTextLabel] setHighlightedTextColor:UIColorFromRGB(AnswerColor)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:)
                                                     name:UITextViewTextDidEndEditingNotification object:[[self textView] window]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateText:)
                                                     name:UITextViewTextDidChangeNotification object:[[self textView] window]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSubText:)
                                                     name:UITextViewTextDidEndEditingNotification object:[[self subTextView] window]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSubText:)
                                                     name:UITextViewTextDidChangeNotification object:[[self subTextView] window]];
}
    
    return self;
}

- (void)setEntry:(Entry *)entry
{
    _entry = entry;
    
    [[self textView] setText:[entry text]];
    [[self textLabel] setText:[entry text]];
    
    [self handleQuestionType:entry];
    [self handleActionItemType:entry];
    [self handleImageIcon:entry active:NO];
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:[[self contentView] frame]];
    [backgroundView setBackgroundColor:[UIColor whiteColor]];
    [self setSelectedBackgroundView:backgroundView];

    [[self textLabel] setNumberOfLines:[BNoteStringUtils lineCount:[entry text]]];

    [self setNeedsDisplay];
}

- (void)edit
{
    [self handleImageIcon:[self entry] active:YES];

    [[self textLabel] setHidden:YES];
    [[self detailTextLabel] setHidden:YES];

    [[self textView] setText:[[self entry] text]];
    [[self textView] setHidden:NO];
    
    float width = [[self contentView] frame].size.width - x - 20;
    float hieght = [[self contentView] frame].size.height - 10;
    
    [[self textView] setFrame:CGRectMake(x, y, width, hieght)];
    
    [self setTargetTextView:[self textView]];
    
    [[self textView] becomeFirstResponder];
}

- (void)finishedEdit
{
    [[self textView] resignFirstResponder];
    [self handleImageIcon:[self entry] active:NO];

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
    
    if ([BNoteStringUtils nilOrEmpty:text]) {
        text = nil;
    }
    
    [[self entry] setText:text];
    [[self textLabel] setText:text];    
}

- (void)updateSubText:(id)sender
{
    if ([[self entry] isKindOfClass:[Question class]]) {
        Question *question = (Question *) [self entry];
        NSString *text = [BNoteStringUtils trim:[[self subTextView] text]];
        
        if ([BNoteStringUtils nilOrEmpty:text]) {
            text = nil;
        }

        [question setAnswer:text];
        [[self detailTextLabel] setText:text];
    }
}

- (void)handleQuestionType:(Entry *)entry
{
    if ([entry isKindOfClass:[Question class]]) {
        Question *question = (Question *) entry;
        
        NSString *detail = [BNoteEntryUtils formatDetailTextForQuestion:question];
        
        if (detail) {
            [[self detailTextLabel] setText:detail];
        } else {
            [[self detailTextLabel] setText:nil];
        }
    }
}

- (void)handleActionItemType:(Entry *)entry
{
    if ([entry isKindOfClass:[ActionItem class]]) {
        ActionItem *actionItem = (ActionItem *) entry;
        
        NSString *detail = [BNoteEntryUtils formatDetailTextForActionItem:actionItem];
        
        if ([BNoteStringUtils nilOrEmpty:detail]) {
            [[self detailTextLabel] setText:nil];
        } else {
            [[self detailTextLabel] setText:detail];
        }
    }
}

- (void)handleImageIcon:(Entry *)entry active:(BOOL)active
{
    if ([entry isKindOfClass:[KeyPoint class]]) {
        KeyPoint *keyPoint = (KeyPoint *) entry;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageView:) name:KeyPointPhotoUpdated object:keyPoint];

        if ([keyPoint photo]) {
            [[self imageView] setImage:[self keyImage:[keyPoint photo]]];
            
            UILongPressGestureRecognizer *longPress =
            [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTap:)];
            [self addGestureRecognizer:longPress];
            [self setLongPress:longPress];
            
            return;
        }
    }
    
    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:active];
    [[self imageView] setImage:[imageView image]];
}

- (void)longPressTap:(id)sender
{
    if (![self actionSheet]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Key Point" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Photo" otherButtonTitles:@"View Photo Full Screen", nil];
        [self setActionSheet:actionSheet];
    
        CGRect rect = [self bounds];
        [actionSheet showFromRect:rect inView:self animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self removePhotos];
            break;
        case 1:    
            [self showPhoto];
            break;
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setActionSheet:nil];
}

- (void)removePhotos
{
    KeyPoint *keyPoint = (KeyPoint *) [self entry];
    [[BNoteWriter instance] removePhoto:[keyPoint photo]];
    [self updateImageViewForKeyPoint:keyPoint];
}

- (void)updateImageView:(id)object
{
    NSNotification *notification = (NSNotification *) object;
    KeyPoint *keyPoint = (KeyPoint *) [notification object];
    [self updateImageViewForKeyPoint:keyPoint];
}

- (void)updateImageViewForKeyPoint:(KeyPoint *)keyPoint
{
    if ([keyPoint photo]) {
        [[self imageView] setImage:[self keyImage:[keyPoint photo]]];
    } else {
        [self removeGestureRecognizer:[self longPress]];
        [self setLongPress:nil];
        UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:NO];
        [[self imageView] setImage:[imageView image]];
    }
}

- (UIImage *)keyImage:(Photo *)photo
{
    return [UIImage imageWithData:[photo thumbnail]];
}

- (void)showPhoto
{
    KeyPoint *keyPoint = (KeyPoint *) [self entry];
    Photo *photo = [keyPoint photo];
    
    UIImage *image = [UIImage imageWithData:[photo original]];
    PhotoViewController *controller = [[PhotoViewController alloc] initWithImage:image];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [[[self parentController] parentController] presentModalViewController:controller animated:YES];
}

+ (int)cellHieght:(Entry *)entry
{
    return MAX(4, [BNoteStringUtils lineCount:[entry text]]) * 25;
}


@end
