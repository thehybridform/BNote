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
@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@end

@implementation BNoteButton
@synthesize icon = _icon;
@synthesize highColor = _highColor;
@synthesize lowColor = _lowColor;
@synthesize gradientLayer = _gradientLayer;;

- (void)awakeFromNib;
{
    // Initialize the gradient layer
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    [self setGradientLayer:gradientLayer];
        
    // Set its bounds to be the same of its parent
    CGRect bounds = CGRectMake(0, 0, 500, [self bounds].size.height);
    [gradientLayer setBounds:bounds];
    
    // Center the layer inside the parent layer
    [gradientLayer setPosition:
     CGPointMake([self bounds].size.width/2,
                 [self bounds].size.height/2)];
    
    // Insert the layer at position zero to make sure the
    // text of the button is not obscured
    [[self layer] insertSublayer:gradientLayer atIndex:0];
    
    // Set the layer's corner radius
    [[self layer] setCornerRadius:10.0f];
    
    // Turn on masking
    [[self layer] setMasksToBounds:YES];
    
    // Display a border around the button
    // with a 1.0 pixel width
    [[self layer] setBorderWidth:1.0f];
    [[self layer] setBorderColor:[UIColorFromRGB(0xbbbbbb) CGColor]];
    
    [self setHighColor:UIColorFromRGB(0xeeeeee)];
    [self setLowColor:UIColorFromRGB(0xc5c5c5)];
    
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
    [self setTitleColor:[BNoteConstants colorFor:BNoteColorHighlight]
               forState:(UIControlStateNormal|UIControlStateHighlighted)];
    [self setTitleColor:[UIColor whiteColor]
               forState:(UIControlStateSelected|UIControlStateDisabled)];
    [self setBackgroundColor:[BNoteConstants colorFor:BNoteColorMain]];
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

- (void)updateTitle:(NSNotification *)notification
{
    TopicGroup *group = [notification object];
    
    NSString *title = [group name];
    
    while ([title length] < 6) {
        title = [BNoteStringUtils append:@" ", title, @" ", nil];
    }
    
    [self setTitle:title forState:UIControlStateNormal];
    
    int width = [title length] * 10;
    width = MIN(500, width);
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
    }
    
    [super drawRect:rect];
}

@end
