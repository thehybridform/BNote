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
@property (strong, nonatomic) IBOutlet UITextView *answerTextView;
@property (strong, nonatomic) IBOutlet UILabel *answerLabel;
@property (strong, nonatomic) QuickWordsViewController *answerQuickWordsViewController;

@end

@implementation QuestionContentViewController
@synthesize answerLabel = _answerLabel;
@synthesize answerTextView = _answerTextView;
@synthesize answerQuickWordsViewController = _answerQuickWordsViewController;

- (Question *)question
{
    return (Question *) [self entry];
}

- (NSString *)localNibName
{
    return @"QuestionContentView";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self answerLabel] setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    
    UITextView *view = [self answerTextView];
    [view setFont:[BNoteConstants font:RobotoRegular andSize:12]];
    
    QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntryContent:self];
    [self setAnswerQuickWordsViewController:quick];
    [view setInputAccessoryView:[quick view]];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(updateAnswerText:)
     name:UITextViewTextDidChangeNotification object:view];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(startedEditingAnswerText:)
     name:UITextViewTextDidBeginEditingNotification object:view];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(stoppedEditingAnswerText:)
     name:UITextViewTextDidEndEditingNotification object:view];

    [[self answerTextView] setText:[[self question] answer]];
    
    [LayerFormater roundCornersForView:[self answerTextView]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setAnswerLabel:nil];
    [self setAnswerTextView:nil];
    [self setAnswerQuickWordsViewController:nil];
}

- (float)heights
{
    float questionHeight = [super height];

    NSString *text = [[self question] answer];
    UITextView *view = [[UITextView alloc] init];
    [view setText:text];
    [view setFrame:CGRectMake(0, 0, [self width] - 110, 200)];
    float answerHeight = [view contentSize].height + 10;

    return MAX(MAX(45, questionHeight), answerHeight);
}

- (void)startedEditingAnswerText:(NSNotification *)notification
{
    if ([notification object] == [self answerTextView]) {
        [self handleImageIcon:YES];
        [self setSelectedTextView:[self answerTextView]];
        [[self answerQuickWordsViewController] selectFirstButton];
    }
}

- (void)stoppedEditingAnswerText:(NSNotification *)notification
{
    [self handleImageIcon:NO];
}

- (void)updateAnswerText:(NSNotification *)notification
{
    NSString *text = [BNoteStringUtils trim:[[self answerTextView] text]];
    if (![BNoteStringUtils nilOrEmpty:text]) {
        Question *question = [self question];
        [question setAnswer:text];
    }
}

@end
