//
//  BNoteButton.m
//  BeNote
//
//  Created by Young Kristin on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteButton.h"
#import "LayerFormater.h"
#import "TopicGroup.h"

@implementation BNoteButton
@synthesize icon = _icon;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setTitleColor:[BNoteConstants colorFor:BNoteColorHighlight]
                   forState:(UIControlStateNormal|UIControlStateHighlighted)];
        [self setTitleColor:[UIColor whiteColor]
                   forState:(UIControlStateNormal|UIControlStateDisabled)];
        [self setBackgroundColor:[BNoteConstants colorFor:BNoteColorMain]];
        [self setShowsTouchWhenHighlighted:YES];
        [[self titleLabel] setFont:[BNoteConstants font:RobotoBold andSize:15]];
        
        [self setBackgroundColor:[UIColor clearColor]];
        [LayerFormater setBorderWidth:0 forView:self];
    }
    
    return self;
}

- (void)setIcon:(UIImageView *)icon
{
    [[self icon] removeFromSuperview];
    
    _icon = icon;
    [self addSubview:icon];
    
    float x = 0;
    float y = [self frame].size.height / 2.0 - [icon frame].size.height / 2.0 - 3;
    float width = [icon frame].size.width;
    float height = [icon frame].size.height;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [icon setFrame:frame];
}

- (void)updateTitle:(NSNotification *)notification
{
    NSString *title;
    TopicGroup *group = [notification object];
    
    if ([[group name] isEqualToString:@"All"]) {
        title = @"All Topics";
    } else {
        title = [group name];
    }
    
    [self setTitle:title forState:UIControlStateNormal];
    
    int width = [title length] * 10;
    width = MIN(500, width);
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height)];
}

@end
