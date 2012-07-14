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

@implementation EntrySummaryTableViewCell
@synthesize entry = _entry;

- (id)initWithIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [[self textLabel] setFont:[UIFont systemFontOfSize:14]];
        [[self textLabel] setBackgroundColor:[UIColor clearColor]];

        [[self detailTextLabel] setTextColor:UIColorFromRGB(0x336633)];
        [self setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 1.0);
	CGContextMoveToPoint(context, 44, 0.0);
	CGContextAddLineToPoint(context, 44, [self bounds].size.height);
	CGContextMoveToPoint(context, 47, 0.0);
	CGContextAddLineToPoint(context, 47, [self bounds].size.height);
	CGContextStrokePath(context);
    
}

- (void)setEntry:(Entry *)entry
{
    _entry = entry;
    
    [[self textLabel] setText:[entry text]];

    [self handleQuestionType:entry];
    [self handleActionItemType:entry];  
    [self handleIcon:entry];
    
    UIColor *color = UIColorFromRGB([[[entry note] topic] color]);
    [self setSelectedBackgroundView:[BNoteFactory createHighlight:color]];

    [[self imageView] setBackgroundColor:color];
    
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
