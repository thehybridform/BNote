//
//  LayerFormater.m
//  BNote
//
//  Created by Young Kristin on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LayerFormater.h"

@implementation LayerFormater

static float shadowOffset = 0.5;
static float shadowRadius = 5.0;
static float shawdowOpacity = 0.5;

+ (void)roundCornersForView:(UIView *)view
{
    [LayerFormater roundCornersForLayer:[view layer]];
}

+ (void)roundCornersForView:(UIView *)view to:(float)radius
{
    [LayerFormater roundCornersForLayer:[view layer] to:radius];
}

+ (void)roundCornersForLayer:(CALayer *)layer
{
    [LayerFormater roundCornersForLayer:layer to:7.0];
}

+ (void)roundCornersForLayer:(CALayer *)layer to:(float)radius
{
    [layer setCornerRadius:radius];
    [layer setMasksToBounds:YES];
}

+ (void)setBorderWidth:(CGFloat)thickness forView:(UIView *)view
{
    [[view layer] setBorderWidth:thickness];
}

+ (void)setBorderColor:(UIColor *)color forView:(UIView *)view
{
    [[view layer] setBorderColor:[color CGColor]];
}

+ (void)setBorderColorWithInt:(int)color forView:(UIView *)view
{
    [LayerFormater setBorderColor:UIColorFromRGB(color) forView:view];
}

+ (void)addShadowToView:(UIView *)view ofSize:(float)size
{
    [view.layer setMasksToBounds:NO];
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:shawdowOpacity];
    [view.layer setShadowRadius:size];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];    
}

+ (void)addShadowToView:(UIView *)view
{
    [view.layer setMasksToBounds:NO];
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:shawdowOpacity];
    [view.layer setShadowRadius:shadowRadius];
    [view.layer setShadowOffset:CGSizeMake(shadowOffset, shadowOffset)];
}

@end
