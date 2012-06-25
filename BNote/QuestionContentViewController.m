//
//  QuestionContentViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionContentViewController.h"
#import "BNoteSessionData.h"

@interface QuestionContentViewController()
@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation QuestionContentViewController
@synthesize actionSheet = _actionSheet;

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
//    Question *question = (Question *) [self entry];
//    [[self detail] setText:[question answer]];
}

@end
