//
//  QuestionContentViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionContentViewController.h"
#import "QuickWordsViewController.h"
#import "LayerFormater.h"
#import "BNoteButton.h"
#import "BNoteWriter.h"

@interface QuestionContentViewController()
@property (strong, nonatomic) UITextView *answerTextView;
@property (strong, nonatomic) UIView *answerView;
@property (strong, nonatomic) UILabel *answerLabel;
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

- (id)initWithEntry:(Entry *)entry
{
    self = [super initWithEntry:entry];
    
    if (self) {
        self.mainTextView.frame = CGRectMake(104, 5, 650, 65);
        self.mainTextView.autoresizingMask =
            UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;

        UIView *answerView = [[UIView alloc] init];
        self.answerView = answerView;
        answerView.autoresizingMask =
            UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
        
        answerView.frame = CGRectMake(104, 70, 650, 28);
        [[self cell].contentView addSubview:answerView];
        
        UILabel *answerLabel = [[UILabel alloc] init];
        self.answerLabel = answerLabel;
        answerLabel.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
        answerLabel.frame = CGRectMake(5, 5, 100, 25);
        answerLabel.font = [BNoteConstants font:RobotoItalic andSize:12];
        answerLabel.textColor = [BNoteConstants appHighlightColor1];
        [answerView addSubview:answerLabel];
        
        UITextView *answerTextView = [[UITextView alloc] init];
        self.answerTextView = answerTextView;
        answerTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        answerTextView.frame = CGRectMake(105, 0, 550, 28);
        answerTextView.font = [BNoteConstants font:RobotoItalic andSize:16];
        answerTextView.textColor = [BNoteConstants appHighlightColor1];
        answerTextView.clipsToBounds = YES;
        answerTextView.scrollEnabled = YES;
        answerTextView.text = [self question].answer;
        [answerView addSubview:answerTextView];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedEditingAnswerText:)
                                                     name:UITextViewTextDidBeginEditingNotification object:answerTextView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stoppedEditingAnswerText:)
                                                     name:UITextViewTextDidEndEditingNotification object:answerTextView];

        QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntryContent:self];
        [self setAnswerQuickWordsViewController:quick];
        [answerTextView setInputAccessoryView:[quick view]];
    }

    self.answerLabel.text = NSLocalizedString(@"Answer", @"The answer to the question");
    self.answerLabel.font = [BNoteConstants font:RobotoBold andSize:16];
    self.answerLabel.textColor = [BNoteConstants appHighlightColor1];
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (float)height
{
    [self updateDetail];
    return MAX(kDefaultCellHeight, self.mainTextView.contentSize.height + self.answerTextView.contentSize.height + 25);
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
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:1];
    
    UIButton *button = [[BNoteButton alloc] init];
    self.answerButton = button;
    [button setTitle:NSLocalizedString(@"Answer", @"The answer to the question") forState:UIControlStateNormal];
    button.titleLabel.font = [BNoteConstants font:RobotoRegular andSize:15];
    [LayerFormater roundCornersForView:button];

    float width = MAX([[[button titleLabel] text] length] * 10, 40);
    
    button.frame = CGRectMake(0, 0, width, 35);
    button.backgroundColor = [BNoteConstants appHighlightColor1];
    
    [button addTarget:self action:@selector(handleAnswer:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
        
    return buttons;
}

- (void)updateDetail
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

        NSString *text = [BNoteStringUtils trim:[[self answerTextView] text]];
        Question *question = [self question];
        if ([BNoteStringUtils nilOrEmpty:text]) {
            question.answer = nil;
            self.answerTextView.text = nil;
        } else {
            question.answer = text;
            self.answerTextView.text = text;
        }

        [[BNoteWriter instance] update];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
