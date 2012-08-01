//
//  KeyWordButton.m
//  BNote
//
//  Created by Young Kristin on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyWordButton.h"
#import "BNoteWriter.h"

@interface KeyWordButton()
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) UIActionSheet *actionSheet;

@end

@implementation KeyWordButton
@synthesize longPress = _longPress;
@synthesize keyWord = _keyWord;
@synthesize actionSheet = _actionSheet;

- (void)execute:(id)sender
{
    UITextView *textView = [[self entryContent] selectedTextView];
    NSRange cursorPosition = [textView selectedRange];
    
    NSString *keyWord = [BNoteStringUtils append:@" ", [[self titleLabel] text], @" ", nil];
    
    NSMutableString *text = [[NSMutableString alloc] initWithString:[textView text]];
    [text replaceCharactersInRange:cursorPosition withString:keyWord];
    [textView setText:text];
}

- (void)initCommon
{
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTap:)];
    [self addGestureRecognizer:longPress];
    [self setLongPress:longPress];
}

- (void)longPressTap:(id)sender
{
    if (![self actionSheet]) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Key Words" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove" otherButtonTitles:nil];
        [self setActionSheet:sheet];
    
        CGRect rect = [self bounds];
        [sheet showFromRect:rect inView:self animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self deleteKeyWord];
            break;
            
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setActionSheet:nil];
}

- (void)deleteKeyWord
{
    [[BNoteWriter instance] removeKeyWord:[self keyWord]];
    [[NSNotificationCenter defaultCenter] postNotificationName:KeyWordsUpdated object:nil];
}

@end
