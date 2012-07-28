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

- (id)initWithEntry:(Entry *)entry
{
    self = [super initWithEntry:entry];
    
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewMode:)
                                                    name:ReviewingNote object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingNote:)
                                                    name:EditingNote object:nil];
        
        UITextView *view = [self answerTextView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAnswerText:)
                                                     name:UITextViewTextDidChangeNotification object:view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startedEditingAnswerText:)
                                                     name:UITextViewTextDidBeginEditingNotification object:view];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stoppedEditingAnswerText:)
                                                     name:UITextViewTextDidEndEditingNotification object:view];
    }
    
    return self;
}

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
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setAnswerLabel:nil];
    [self setAnswerTextView:nil];
    [self setAnswerQuickWordsViewController:nil];
}

- (float)height
{
    float questionHeight = [super height];

    UITextView *view = [[UITextView alloc] init];
    [view setText:[[self question] answer]];
    [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
    [view setFrame:CGRectMake(0, 0, 110, 50)];
    float answerHeight = [view contentSize].height + 20;

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
