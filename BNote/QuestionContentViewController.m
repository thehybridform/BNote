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
@property (strong, nonatomic) QuickWordsViewController *answerQuickWordsViewController;
@property (strong, nonatomic) UIButton *answerButton;

@end

@implementation QuestionContentViewController
@synthesize answerTextView = _answerTextView;
@synthesize answerQuickWordsViewController = _answerQuickWordsViewController;
@synthesize answerButton = _answerButton;

static NSString *kAnswerText;

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
        UITextView *answerTextView = [[UITextView alloc] init];
        self.answerTextView = answerTextView;
        answerTextView.frame = self.mainTextView.frame;
        answerTextView.font = [BNoteConstants font:RobotoItalic andSize:16];
        answerTextView.textColor = [BNoteConstants appHighlightColor1];
        answerTextView.clipsToBounds = YES;
        answerTextView.scrollEnabled = YES;
        answerTextView.delegate = self;

        [[self cell].contentView addSubview:answerTextView];

        [self reset];
    }

    kAnswerText = NSLocalizedString(@"Answer", @"The answer to the question");

    [self handleAnswerFrame];

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (float)height
{
    [self handleAnswerFrame];

    if (self.answerTextView.hidden) {
        return [super height];
    } else {
        float mainHeight = MAX(kDefaultCellHeight, self.mainTextView.contentSize.height);
        float answerHeight = MAX(kDefaultCellHeight, self.answerTextView.contentSize.height);

        return MAX(kDefaultCellHeight, mainHeight + answerHeight);
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

- (void)handleAnswer:(id)sender
{
    if (![self question].answer) {
        [self question].answer = [kAnswerText stringByAppendingString:@": "];
    }

    [self handleAnswerFrame];
    [self.answerTextView becomeFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if (textView == self.answerTextView) {
        [textView setScrollEnabled:YES];
        [self handleImageIcon:YES];
        [self setSelectedTextView:textView];
        [self.answerQuickWordsViewController selectFirstButton];
    } else {
        [super textViewDidBeginEditing:textView];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == self.answerTextView) {
        [self question].answer = textView.text;
    } else {
        [super textViewDidChange:textView];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.answerTextView) {
        [textView setScrollEnabled:NO];
        [self handleImageIcon:NO];

        NSString *text = [BNoteStringUtils trim:textView.text];
        if ([BNoteStringUtils nilOrEmpty:text]) {
            [self question].answer = nil;
            self.answerTextView.text = nil;
        } else {
            [self question].answer = text;
            self.answerTextView.text = text;
        }

        [self handleAnswerFrame];

        [[BNoteWriter instance] update];

    } else {
        [super textViewDidEndEditing:textView];
    }
}

- (void)handleAnswerFrame
{
    if ([BNoteStringUtils nilOrEmpty:[self question].answer]) {
        self.answerTextView.hidden = YES;
        return;
    }

    self.answerTextView.hidden = NO;
    self.answerTextView.text = [self question].answer;

    float height = MAX(kDefaultCellHeight, self.answerTextView.contentSize.height);
    float y = self.mainTextView.frame.origin.y + self.mainTextView.frame.size.height;

    self.answerTextView.frame = CGRectMake(self.answerTextView.frame.origin.x, y, self.answerTextView.frame.size.width, height);
}

- (void)resign
{
    [super resign];
    [self.answerTextView resignFirstResponder];
}

- (void)reset
{
    [super reset];
    [self resign];

    QuickWordsViewController *quick = [[QuickWordsViewController alloc] initWithEntryContent:self];
    self.answerQuickWordsViewController = quick;
    self.answerTextView.inputAccessoryView = quick.view;
}

@end
