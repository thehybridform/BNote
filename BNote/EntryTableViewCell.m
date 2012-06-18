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
#import "QuickWordsViewController.h"
#import "BNoteConstants.h"

@interface EntryTableViewCell()
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) QuickWordsViewController *quickWordsViewController;
@property (strong, nonatomic) DatePickerViewController *datePickerViewController;
@property (strong, nonatomic) UILabel *detail;
@end

@implementation EntryTableViewCell
@synthesize entry = _entry;
@synthesize textView = _textView;
@synthesize targetTextView = _targetTextView;
@synthesize parentController = _parentController;
@synthesize actionSheet = _actionSheet;
@synthesize longPress = _longPress;
@synthesize quickWordsViewController = _quickWordsViewController;
@synthesize popup = _popup;
@synthesize datePickerViewController = _datePickerViewController;
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

- (void)keyboardWillHide:(NSNotification *)notification
{
    if (![[self textView] isHidden]) {
        [self unfocus];
    }
}

- (UIView *)view
{
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

    float width = [[self contentView] frame].size.width - x - 75;

    CGRect rect = CGRectMake(x, y, width, 10);
    UILabel *detail = [[UILabel alloc] initWithFrame:rect];
    [detail setFont:[UIFont systemFontOfSize:12]];
    [self addSubview:detail];
    [detail setTextColor:UIColorFromRGB(0x336633)];
    [self setDetail:detail];
    [detail setBackgroundColor:[BNoteConstants appColor1]];
    [detail setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
//    [LayerFormater roundCornersForView:text];

    [self handleQuestionType];
    [self handleActionItemType];
    [self handleImageIcon:NO];
    
    float hieght = [BNoteStringUtils lineCount:[entry text]] * 15;
    
    [text setFrame:CGRectMake(x, y + 20, width, hieght)];
    [text setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin)];

    UIView *backgroundView = [[UIView alloc] initWithFrame:[[self contentView] frame]];
    [backgroundView setBackgroundColor:[BNoteConstants appColor1]];
    [self setSelectedBackgroundView:backgroundView];
    
    [self bringSubviewToFront:[self contentView]];
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

- (void)updateText:(NSNotification *)notification
{
    [self handleText];
}

- (void)handleText
{
    NSString *text = [BNoteStringUtils trim:[[self textView] text]];
    
    if ([BNoteStringUtils nilOrEmpty:text]) {
        text = nil;
    }

    [[self entry] setText:text];    
}

- (void)handleSubText
{
    if ([[self entry] isKindOfClass:[Question class]]) {
        Question *question = (Question *) [self entry];
/*        NSString *text = [BNoteStringUtils trim:[[self subTextView] text]];
        
        if ([BNoteStringUtils nilOrEmpty:text]) {
            text = nil;
        }
        
        [question setAnswer:text];
        [[self detailTextLabel] setNumberOfLines:[BNoteStringUtils lineCount:text]];
        [[self detailTextLabel] setText:text];
 */
    }
}

- (void)handleQuestionType
{
    if ([[self entry] isKindOfClass:[Question class]]) {
        Question *question = (Question *) [self entry];
        [[self detail] setText:[question answer]];
    }
}

- (void)handleActionItemType
{
    if ([[self entry] isKindOfClass:[ActionItem class]]) {
        ActionItem *actionItem = (ActionItem *) [self entry];
        NSString *detail = [BNoteEntryUtils formatDetailTextForActionItem:actionItem];
        
        if ([BNoteStringUtils nilOrEmpty:detail]) {
            [[self detail] setText:nil];
        } else {
            [[self detail] setText:detail];
        }
    }
}

- (void)handleImageIcon:(BOOL)active
{
    if ([[self entry] isKindOfClass:[KeyPoint class]]) {
        KeyPoint *keyPoint = (KeyPoint *) [self entry];

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
    NSNotification *notification = object;
    if ([notification object] == [self entry]) {
        KeyPoint *keyPoint = (KeyPoint *) [notification object];
        [self updateImageViewForKeyPoint:keyPoint];
    }
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

- (void)showDatePicker
{    
    if ([[self entry] isKindOfClass:[ActionItem class]]) {
        ActionItem *actionItem = (ActionItem *) [self entry];

        NSTimeInterval interval = [actionItem dueDate];
        NSDate *date;
        if (interval) {
            date = [NSDate dateWithTimeIntervalSinceReferenceDate:interval];
        } else {
            date = [[NSDate alloc] init];
        }
    
        DatePickerViewController *controller = [[DatePickerViewController alloc] initWithDate:date andMode:UIDatePickerModeDate];
        [controller setListener:self];
        [controller setTitleText:@"Due Date"];
        [[controller datePicker] setDatePickerMode:UIDatePickerModeDate];
        [self setDatePickerViewController:controller];

        UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self setPopup:popup];
        [popup setDelegate:self];
    
        [popup setPopoverContentSize:[[controller view] bounds].size];
    
        UIView *view = self;
        CGRect rect = [view bounds];
    
        [popup presentPopoverFromRect:rect inView:self
             permittedArrowDirections:UIPopoverArrowDirectionAny 
                             animated:YES];
    }
}

- (void)dateTimeUpdated:(NSDate *)date
{
    if ([[self entry] isKindOfClass:[ActionItem class]]) {
        ActionItem *actionItem = (ActionItem *) [self entry];
        [actionItem setDueDate:[date timeIntervalSinceReferenceDate]];
        [self handleActionItemType];
    }
}

- (void)selectedDatePickerViewDone
{
    [[self popup] dismissPopoverAnimated:YES];
    [self setPopup:nil];
    [self setDatePickerViewController:nil];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [self setPopup:nil];
    [self setDatePickerViewController:nil];
}

+ (int)cellHieght:(Entry *)entry
{
    return MAX(4, [BNoteStringUtils lineCount:[entry text]]) * 20;
}


@end
