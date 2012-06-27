//
//  QuestionContentViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionContentViewController.h"
#import "BNoteSessionData.h"
#import "BNoteEntryUtils.h"
#import "QuickWordsViewController.h"
#import "LayerFormater.h"

@interface QuestionContentViewController()
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) QuickWordsViewController *answerQuick;

@end

@implementation QuestionContentViewController
@synthesize actionSheet = _actionSheet;
@synthesize answerQuick = _answerQuick;

static NSString *answer = @"Answer";
static NSString *updateAnswer = @"Update Answer";
static NSString *clearAnswer = @"Clear Answer";

- (Question *)question
{
    return (Question *) [self entry];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self scrollView] removeFromSuperview];
    
    QuickWordsViewController *answerQuick = [[QuickWordsViewController alloc] initWithCell:self];
    [self setAnswerQuick:answerQuick];
    [[self detailTextView] setInputAccessoryView:[answerQuick view]];
}

- (void)startedEditingText:(NSNotification *)notification
{
    if ([notification object] == [self mainTextView]) {
        [self handleImageIcon:YES];
        [self setSelectedTextView:[self mainTextView]];
        [[self quickWordsViewController] selectFirstButton];
    } else if ([notification object] == [self detailTextView]) {
        [self handleImageIcon:YES];
        [self setSelectedTextView:[self detailTextView]];
        [[self answerQuick] selectFirstButton];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:[self view]];
    if (location.x < 120) {
        [self handleTouch];
    } else {
        [[self mainTextView] becomeFirstResponder];
    }
}

- (void)handleTouch
{
    if (![[BNoteSessionData instance] keyboardVisible]) {
        [self handleImageIcon:YES];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setDelegate:self];
        
        Question *question = [self question];
        
        if ([question answer]) {
            [actionSheet addButtonWithTitle:updateAnswer];
            NSInteger index = [actionSheet addButtonWithTitle:clearAnswer];
            [actionSheet setDestructiveButtonIndex:index];
        } else {
            [actionSheet addButtonWithTitle:answer];
        }
        
        [actionSheet setTitle:@"Question"];
        [self setActionSheet:actionSheet];
        
        CGRect rect = [[self imageView] bounds];
        [actionSheet showFromRect:rect inView:[self imageView] animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (title == answer) {
            [[self detailTextView] becomeFirstResponder];
        } else if (title == clearAnswer) {
            [[self question] setAnswer:nil];
        } else if (title == updateAnswer) {
            [[self detailTextView] becomeFirstResponder];
        }
    }
    
    [self setActionSheet:nil];
    [self handleImageIcon:NO];
    [self updateDetail];
}

- (NSString *)detail
{
    return [BNoteEntryUtils formatDetailTextForQuestion:[self question]];
}

- (void)showDetailText
{
    [super showDetailText];
    
    [self updateDetail];
}

- (void)updateDetail
{
    UITextView *view = [self detailTextView];

    Question *question = (Question *) [self entry];
    NSString *answer = [question answer];
    
    if ([BNoteStringUtils nilOrEmpty:answer]) {
        [view setText:@"Answer: "];        
        [question setAnswer:nil];
    } else {
        [view setText:answer];
    }
}

- (void)updateText:(NSNotification *)notification
{
    if ([notification object] == [self mainTextView]) {
        NSString *text = [[self mainTextView] text];
        if (![BNoteStringUtils nilOrEmpty:text]) {
            [[self entry] setText:text];
        }
    } else if ([notification object] == [self detailTextView]) {
        NSString *text = [[self detailTextView] text];
        if (![BNoteStringUtils nilOrEmpty:text]) {
            Question *question = [self question];
            [question setAnswer:text];
        }
    }
}

@end
