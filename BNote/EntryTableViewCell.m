//
//  EntryTableViewCell.m
//  BNote
//
//  Created by Young Kristin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryTableViewCell.h"
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

@interface EntryTableViewCell()

@end

@implementation EntryTableViewCell
@synthesize entry = _entry;
@synthesize textView = _textView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setTextView:[[UITextView alloc] init]];
        [[self textView] setAutoresizingMask:[[self textLabel] autoresizingMask]];
        [LayerFormater roundCornersForView:[self textView]];
        [[self contentView] addSubview:[self textView]];
        [[self textView] setHidden:YES];
        
        [[self textView] setFont:[UIFont systemFontOfSize:15]];
        [[self textLabel] setFont:[UIFont systemFontOfSize:15]];
        [[self textLabel] setLineBreakMode:UILineBreakModeWordWrap];

        [[self imageView] setAutoresizingMask:UIViewAutoresizingNone];
        
        [[self detailTextLabel] setTextColor:UIColorFromRGB(0x336633)];
    }
    
    return self;
}

- (void)setEntry:(Entry *)entry
{
    _entry = entry;
    
    [[self textView] setText:[entry text]];
    [[self textLabel] setText:[entry text]];
    
    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:NO];
    [[self imageView] setImage:[imageView image]];
                              
    [self handleQuestionType:entry];
    [self handleActionItemType:entry];    
    
    UIView *backgroudView = [[UIView alloc] initWithFrame:[[self contentView] frame]];
    [backgroudView setBackgroundColor:[UIColor whiteColor]];
    [self setSelectedBackgroundView:backgroudView];

    
    [[self textLabel] setNumberOfLines:[BNoteStringUtils lineCount:[entry text]]];

    [self setNeedsDisplay];
}

- (void)edit
{
    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:YES];
    [[self imageView] setImage:[imageView image]];

    [[self textLabel] setHidden:YES];
    [[self detailTextLabel] setHidden:YES];

    [[self textView] setText:[[self entry] text]];
    [[self textView] setHidden:NO];
    
    float x = 45;
    float y = 5;
    float width = [[self contentView] frame].size.width - 50;
    float hieght = [[self contentView] frame].size.height - 10;
    
    [[self textView] setFrame:CGRectMake(x, y, width, hieght)];
    [[self textView] becomeFirstResponder];
}

- (void)finishedEdit
{
    [[self textView] resignFirstResponder];

    UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:NO];
    [[self imageView] setImage:[imageView image]];

    NSString *text = [BNoteStringUtils trim:[[self textView] text]];
    [[self entry] setText:text];
    [[self textLabel] setText:text];
    [[self textView] setHidden:YES];
    [[self textLabel] setHidden:NO];
    [[self detailTextLabel] setHidden:NO];
    
    float x = [[self textLabel] frame].origin.x;
    float y = [[self textLabel] frame].origin.y;
    float height = [[self textLabel] frame].size.height;
    float width = [[self textView] frame].size.width;
    
    [[self textLabel] setFrame:CGRectMake(x, y, width, height)];
    
    [[self textLabel] setNumberOfLines:[BNoteStringUtils lineCount:[[self entry] text]]];
    [self handleQuestionType:[self entry]];
    [self handleActionItemType:[self entry]];    

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
            [[self detailTextLabel] setText:@"Completed"];
        } else {
            [[self detailTextLabel] setText:nil];
        }
    }
    
}

@end
