//
//  EntrySummaryTableViewCellController.m
//  BeNote
//
//  Created by Young Kristin on 7/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntrySummaryTableViewCellController.h"
#import "LayerFormater.h"
#import "KeyPoint.h"
#import "Photo.h"
#import "ActionItem.h"
#import "Question.h"
#import "BNoteFactory.h"

@interface EntrySummaryTableViewCellController ()
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UILabel *questionLabel;
@property (strong, nonatomic) IBOutlet UILabel *answerLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLable;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (assign, nonatomic) Entry *entry;

@end

@implementation EntrySummaryTableViewCellController
@synthesize textLabel = _textLabel;
@synthesize detailLable = _detailLable;
@synthesize imageView = _imageView;
@synthesize entry = _entry;
@synthesize questionLabel = _questionLabel;
@synthesize answerLabel = _answerLabel;

- (id)initWithEntry:(Entry *)entry
{
    self = [super initWithNibName:@"EntrySummaryTableViewCell" bundle:nil];
    if (self) {
        [self setEntry:entry];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    Entry *entry = [self entry];
    UITableViewCell *cell = (UITableViewCell *)[self view];
    UIColor *color = UIColorFromRGB([[entry note] color]);
    [cell setSelectedBackgroundView:[BNoteFactory createHighlight:color]];
    
    
    [[self textLabel] setText:[entry text]];
    
    [[self textLabel] setFont:[BNoteConstants font:RobotoLight andSize:13]];
    [[self textLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    [[self questionLabel] setFont:[BNoteConstants font:RobotoLight andSize:13]];
    [[self questionLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    [[self answerLabel] setFont:[BNoteConstants font:RobotoLight andSize:13]];
    [[self answerLabel] setTextColor:[BNoteConstants appHighlightColor1]];

    [[self detailLable] setFont:[BNoteConstants font:RobotoLight andSize:10]];
    [[self detailLable] setBackgroundColor:[BNoteConstants appHighlightColor1]];
    [[self detailLable] setTextColor:[UIColor whiteColor]];

    [LayerFormater roundCornersForView:[self imageView]];
    [LayerFormater roundCornersForView:[self detailLable]];
    [LayerFormater setBorderWidth:0 forView:[self detailLable]];

    [self handleIcon];
    [self handleActionItem];
    [self handleQuestion];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setTextLabel:nil];
    [self setDetailLable:nil];
    [self setQuestionLabel:nil];
    [self setAnswerLabel:nil];
    [self setImageView:nil];
}

- (void)handleIcon
{
    Entry *entry = [self entry];
    if ([entry isKindOfClass:[KeyPoint class]]) {
        KeyPoint *keyPoint = (KeyPoint *) entry;
        if ([keyPoint photo]) {
            UIImage *image = [UIImage imageWithData:[[keyPoint photo] small]];
            [[self imageView] setImage:image];
            
            return;
        }
    }
    
    [[self imageView] setHidden:YES];
}

- (void)handleActionItem
{
    Entry *entry = [self entry];
    if ([entry isKindOfClass:[ActionItem class]]) {
        ActionItem *actionItem = (ActionItem *) entry;
        if ([actionItem completed]) {
            [[self detailLable] setText:@"COMPLETE"];
            return;
        } else if ([actionItem dueDate]) {
            NSDate *dueDate = [NSDate dateWithTimeIntervalSinceReferenceDate:[actionItem dueDate]]; 
            [[self detailLable] setText:[BNoteStringUtils dateToString:dueDate]];
            return;
        }
    }

    [[self detailLable] setHidden:YES];
}

- (void)handleQuestion
{
    Entry *entry = [self entry];
    if ([entry isKindOfClass:[Question class]]) {
        Question *question = (Question *) entry;
        if ([question answer]) {
            [[self questionLabel] setText:[question text]];
            [[self answerLabel] setText:[question answer]];
            [[self textLabel] setHidden:YES];
            
            return;
        }
    }   
    
    [[self questionLabel] setHidden:YES];
    [[self answerLabel] setHidden:YES];
}

- (UITableViewCell *)cell
{
    return (UITableViewCell *)[self view];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
