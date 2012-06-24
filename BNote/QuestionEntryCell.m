//
//  QuestionEntryCell.m
//  BeNote
//
//  Created by Young Kristin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionEntryCell.h"
#import "BNoteSessionData.h"

@interface QuestionEntryCell()
@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation QuestionEntryCell
@synthesize actionSheet = _actionSheet;

static NSString *answer = @"Answer";
static NSString *updateAnswer = @"Update Answer";
static NSString *clearAnswer = @"Clear Answer";

- (Question *)question
{
    return (Question *) [self entry];
}

- (void)setup
{
    [super setup];
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showQuestionOptions:)];
    [self addGestureRecognizer:tap];
}

- (void)showQuestionOptions:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self];
    if (location.x < 120) {
        [self handleTouch];
    } else {
        [[self textView] becomeFirstResponder];
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

        } else if (title == clearAnswer) {
            [[self question] setAnswer:nil];
        } else if (title == updateAnswer) {

        }
    }

    [self setActionSheet:nil];
    [self handleImageIcon:NO];
}

- (void)updateDetail
{
    Question *question = (Question *) [self entry];
    [[self detail] setText:[question answer]];
}

@end
