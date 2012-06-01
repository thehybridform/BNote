//
//  EntrySummaryTableViewCell.m
//  BNote
//
//  Created by Young Kristin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntrySummaryTableViewCell.h"
#import "LayerFormater.h"
#import "Topic.h"
#import "Note.h"
#import "Question.h"
#import "ActionItem.h"
#import "KeyPoint.h"
#import "Decision.h"
#import "Attendant.h"
#import "BNoteFactory.h"
#import "BNoteStringUtils.h"

@implementation EntrySummaryTableViewCell
@synthesize entry = _entry;

- (id)initWithIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {

        [[self textLabel] setFont:[UIFont systemFontOfSize:14]];

    
        [[self detailTextLabel] setTextColor:UIColorFromRGB(0x336633)];

    }
    
    return self;
}

- (void)setEntry:(Entry *)entry
{
    _entry = entry;
    
    [[self textLabel] setText:[entry text]];

    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:NO];
    [[self imageView] setImage:[imageView image]];
    
    [self handleQuestionType:entry];
    [self handleActionItemType:entry];    
    
    UIView *backgroudView = [[UIView alloc] initWithFrame:[[self contentView] frame]];
    [backgroudView setBackgroundColor:[UIColor whiteColor]];
    [self setSelectedBackgroundView:backgroudView];
    
    [self setNeedsDisplay];
}

- (void)handleQuestionType:(Entry *)entry
{
    if ([entry isKindOfClass:[Question class]]) {
        Question *question = (Question *) entry;
        if ([question answer]) {
            NSString *answer = [@"Answer: " stringByAppendingString:[question answer]];
            [[self detailTextLabel] setText:answer];
        } else {
            [[self detailTextLabel] setText:nil];
        }
    }
}

- (void)handleActionItemType:(Entry *)entry
{
    if ([entry isKindOfClass:[ActionItem class]]) {
        ActionItem *actionItem = (ActionItem *) entry;
        if ([actionItem completed]) {
            NSDate *completed = [NSDate dateWithTimeIntervalSinceReferenceDate:[actionItem completed]]; 
            NSString *date = [@"Completed on " stringByAppendingString:[BNoteStringUtils dateToString:completed]];
            [[self detailTextLabel] setText:date];
        } else {
            [[self detailTextLabel] setText:nil];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
