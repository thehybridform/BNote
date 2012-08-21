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

@interface BNoteButton()

@end

@implementation BNoteButton
@synthesize icon = _icon;
@synthesize highColor = _highColor;
@synthesize lowColor = _lowColor;
@synthesize gradientLayer = _gradientLayer;;

- (void)awakeFromNib
{
    [self setGradientLayer:[self setupGradient]];
    [self setPressedGradientLayer:[self setupGradient]];
        
    [[self layer] insertSublayer:[self pressedGradientLayer] atIndex:0];
    [[self layer] insertSublayer:[self gradientLayer] atIndex:0];
    
    [[self layer] setCornerRadius:5];
    [[self layer] setMasksToBounds:YES];
    [[self layer] setBorderWidth:1.0f];
    [[self layer] setBorderColor:[UIColorFromRGB(0xbbbbbb) CGColor]];
    
    [self setHighColor:UIColorFromRGB(0xeeeeee)];
    [self setLowColor:UIColorFromRGB(0xc0c0c0)];
}

- (CAGradientLayer *)setupGradient
{
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    
    // Set its bounds to be the same of its parent
    CGRect bounds = CGRectMake(0, 0, 500, [self bounds].size.height);
    [gradientLayer setBounds:bounds];
    
    // Center the layer inside the parent layer
    [gradientLayer setPosition:
     CGPointMake([self bounds].size.width/2,
                 [self bounds].size.height/2)];
    
    return gradientLayer;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (id)init
{
    self = [super init];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    [self setShowsTouchWhenHighlighted:YES];
    [[self titleLabel] setFont:[BNoteConstants font:RobotoBold andSize:15]];
    
    [self setBackgroundColor:[UIColor clearColor]];
    [LayerFormater setBorderWidth:0 forView:self];
}

- (void)setIcon:(UIImageView *)icon
{
    [[self icon] removeFromSuperview];
    _icon = icon;

    [LayerFormater roundCornersForView:icon];
    [LayerFormater setBorderWidth:0 forView:icon];
    
    [self addSubview:icon];
    
    float x = 0;
    float y = [self frame].size.height / 2.0 - [icon frame].size.height / 2.0;
    float width = [icon frame].size.width;
    float height = [icon frame].size.height;
    
    CGRect frame = CGRectMake(x, y, width, height);
    [icon setFrame:frame];
}

- (void)updateTitle:(NSString *)title
{
    while ([title length] < 6) {
        title = [BNoteStringUtils append:@" ", title, @" ", nil];
    }
    
    [self setTitle:title forState:UIControlStateNormal];
    
    int width = [title length] * 10;
    width = MIN(300, width);
    CGRect frame = [self frame];
    [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height)];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        [[self icon] setBackgroundColor:[BNoteConstants appHighlightColor1]];
    } else {
        [[self icon] setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)drawRect:(CGRect)rect;
{
    if ([self highColor] && [self lowColor]) {
        // Set the colors for the gradient to the
        // two colors specified for high and low
        [[self gradientLayer] setColors:
            [NSArray arrayWithObjects:
             (id)[[self highColor] CGColor],
             (id)[[self lowColor] CGColor],
             nil]];

        [[self pressedGradientLayer] setColors:
            [NSArray arrayWithObjects:
             (id)[[self lowColor] CGColor],
             (id)[[self highColor] CGColor],
             nil]];
        
        [[self pressedGradientLayer] setHidden:YES];
    }
    
    [super drawRect:rect];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self pressedGradientLayer] setHidden:NO];
    
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self pressedGradientLayer] setHidden:YES];
    
    [super touchesCancelled:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self pressedGradientLayer] setHidden:YES];
    
    [super touchesEnded:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[self pressedGradientLayer] setHidden:YES];
    
    [super touchesMoved:touches withEvent:event];
}

@end
