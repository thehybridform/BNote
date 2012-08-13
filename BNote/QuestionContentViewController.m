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
#import "BNoteAnimation.h"

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
    
    self.answerLabel.text = NSLocalizedString(@"Answer", @"The answer to the question");
    [[self answerLabel] setFont:[BNoteConstants font:RobotoRegular andSize:14]];
    [[self answerLabel] setTextColor:UIColorFromRGB(0x444444)];

    UITextView *view = [self answerTextView];
    [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
    [view setTextColor:UIColorFromRGB(0x444444)];
    
    QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntryContent:self];
    [self setAnswerQuickWordsViewController:quick];
    [view setInputAccessoryView:[quick view]];
    
    [[self answerTextView] setText:[[self question] answer]];
    
    [LayerFormater roundCornersForView:[self answerTextView]];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAnswerText:)
                                                 name:UITextViewTextDidChangeNotification object:view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedEditingAnswerText:)
                                                 name:UITextViewTextDidBeginEditingNotification object:view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stoppedEditingAnswerText:)
                                                 name:UITextViewTextDidEndEditingNotification object:view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setAnswerLabel:nil];
    [self setAnswerTextView:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (float)height
{
    UITextView *view = [[UITextView alloc] init];
    [view setText:[[self question] text]];
    [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
    [view setFrame:CGRectMake(0, 0, [self width] - 240, 60)];
    
    float questionHeight = MAX(60, [view contentSize].height + 10);

    [view setText:[[self question] answer]];
    [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
    [view setFrame:CGRectMake(0, 0, 110, 20)];
    float answerHeight = [view contentSize].height + 20;

    return MAX(MAX(45, questionHeight), answerHeight);
}

- (void)startedEditingAnswerText:(NSNotification *)notification
{
    if ([notification object] == [self answerTextView]) {
//        [[self answerTextView] setClipsToBounds:NO];
        [self handleImageIcon:YES];
        [self setSelectedTextView:[self answerTextView]];
        [[self answerQuickWordsViewController] selectFirstButton];
    }
}

- (void)stoppedEditingAnswerText:(NSNotification *)notification
{
    if ([notification object] == [self answerTextView]) {
//        [[self answerTextView] setClipsToBounds:YES];
        [self handleImageIcon:NO];
    }
}

- (void)updateAnswerText:(NSNotification *)notification
{
    if ([notification object] == [self answerTextView]) {
        NSString *text = [BNoteStringUtils trim:[[self answerTextView] text]];
        Question *question = [self question];
        if ([BNoteStringUtils nilOrEmpty:text]) {
            [question setAnswer:nil];
        } else {
            [question setAnswer:text];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
