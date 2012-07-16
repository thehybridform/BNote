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
#import "Attendants.h"
#import "BNoteFactory.h"
#import "BNoteStringUtils.h"

@interface EntrySummaryTableViewCell()

@end

@implementation EntrySummaryTableViewCell
@synthesize entry = _entry;

- (id)initWithIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [[self textLabel] setFont:[BNoteConstants font:RobotoLight andSize:12]];
        [[self textLabel] setTextColor:[BNoteConstants appHighlightColor1]];

        [[self detailTextLabel] setTextColor:[BNoteConstants appHighlightColor1]];
        [[self detailTextLabel] setFont:[BNoteConstants font:RobotoLight andSize:10]];

        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)setEntry:(Entry *)entry
{
    _entry = entry;
    
    [[self textLabel] setText:[entry text]];
    [[self detailTextLabel] setText:nil];

    [self handleQuestionType:entry];
    [self handleActionItemType:entry];  
    [self handleIcon:entry];
    
    UIColor *color = UIColorFromRGB([[[entry note] topic] color]);
    [self setSelectedBackgroundView:[BNoteFactory createHighlight:color]];

    [self setNeedsDisplay];
}

- (void)handleIcon:(Entry *)entry
{
    if ([entry isKindOfClass:[KeyPoint class]]) {
        KeyPoint *keyPoint = (KeyPoint *) entry;
        if ([keyPoint photo]) {
            UIImage *image = [UIImage imageWithData:[[keyPoint photo] small]];
            [[self imageView] setImage:image];

            return;
        }
    }

    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:NO];
    [[self imageView] setImage:[imageView image]];
    
}

- (void)handleQuestionType:(Entry *)entry
{
    if ([entry isKindOfClass:[Question class]]) {
        Question *question = (Question *) entry;
        
        NSString *detail = [BNoteEntryUtils formatDetailTextForQuestion:question];
        
        if (detail) {
            [[self detailTextLabel] setText:detail];
        } else {
            [[self detailTextLabel] setText:nil];
        }
    }
}

- (void)handleActionItemType:(Entry *)entry
{
    if ([entry isKindOfClass:[ActionItem class]]) {
        ActionItem *actionItem = (ActionItem *) entry;
        NSString *detail = [BNoteEntryUtils formatDetailTextForActionItem:actionItem];
        
        if ([BNoteStringUtils nilOrEmpty:detail]) {
            [[self detailTextLabel] setText:nil];
        } else {
            [[self detailTextLabel] setText:detail];
        }
    }
    
}

@end
