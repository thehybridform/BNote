//
//  BNoteButton.m
//  BeNote
//
//  Created by Young Kristin on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteButton.h"
#import "LayerFormater.h"

@implementation BNoteButton
@synthesize icon = _icon;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setTitleColor:[BNoteConstants colorFor:BNoteColorHighlight]
                   forState:(UIControlStateNormal|UIControlStateHighlighted)];
        [self setBackgroundColor:[BNoteConstants colorFor:BNoteColorMain]];
        [self setShowsTouchWhenHighlighted:YES];
        [LayerFormater roundCornersForView:self];
    }
    
    return self;
}

- (void)setIcon:(UIImageView *)icon
{
    _icon = icon;
    [self addSubview:icon];
    
    float x = [self frame].size.width - 5 - [icon frame].size.width;
    float y = [self frame].size.height / 2.0 - [icon frame].size.height / 2.0;
    float width = [icon frame].size.width;
    float height = [icon frame].size.height;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [icon setFrame:frame];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
