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
#import "BNoteButton.h"

@interface QuestionContentViewController()
@property (strong, nonatomic) IBOutlet UITextView *answerTextView;
@property (strong, nonatomic) IBOutlet UIView *answerView;
@property (strong, nonatomic) IBOutlet UILabel *answerLabel;
@property (strong, nonatomic) QuickWordsViewController *answerQuickWordsViewController;
@property (strong, nonatomic) UIButton *answerButton;

@end

@implementation QuestionContentViewController
@synthesize answerLabel = _answerLabel;
@synthesize answerTextView = _answerTextView;
@synthesize answerQuickWordsViewController = _answerQuickWordsViewController;
@synthesize answerView = _answerView;
@synthesize answerButton = _answerButton;

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
    self.answerLabel.font = [BNoteConstants font:RobotoBold andSize:16];
    self.answerLabel.textColor = [BNoteConstants appHighlightColor1];

    UITextView *view = [self answerTextView];
    [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
    [view setTextColor:UIColorFromRGB(0x444444)];
    
    QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntryContent:self];
    [self setAnswerQuickWordsViewController:quick];
    [view setInputAccessoryView:[quick view]];

    [self setupDetail];

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
    self.answerView = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)doNotResizeActionButton
{
    return YES;
}

- (NSArray *)quickActionButtons
{
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIButton *button = [[BNoteButton alloc] init];
    self.answerButton = button;
    [button setTitle:self.answerLabel.text forState:UIControlStateNormal];
    button.titleLabel.font = [BNoteConstants font:RobotoRegular andSize:15];
    [LayerFormater roundCornersForView:button];

    float width = MAX([[[button titleLabel] text] length] * 10, 40);
    
    button.frame = CGRectMake(0, 0, width, 35);
    button.backgroundColor = [BNoteConstants appHighlightColor1];
    
    [button addTarget:self action:@selector(handleAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
        
    return buttons;
}

- (void)setupDetail
{
    if ([BNoteStringUtils nilOrEmpty:[self question].answer]) {
        self.answerView.hidden = YES;
    } else {
        self.answerView.hidden = NO;
    }
}

- (void)handleAnswer:(id)sender
{
    self.answerView.hidden = NO;
    
    float height = self.answerTextView.contentSize.height;
    CGRect frame = self.answerView.frame;
    self.answerView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    
    [self.answerTextView becomeFirstResponder];
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
    if ([notification object] == [self answerTextView]) {
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
