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
static float shadowOpacity = 0.5;

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
    layer.cornerRadius = radius;
    layer.masksToBounds = YES;
}

+ (void)setBorderWidth:(CGFloat)thickness forView:(UIView *)view
{
    view.layer.borderWidth = thickness;
}

+ (void)setBorderColor:(UIColor *)color forView:(UIView *)view
{
    view.layer.borderColor = color.CGColor;
}

+ (void)setBorderColorWithInt:(int)color forView:(UIView *)view
{
    [LayerFormater setBorderColor:UIColorFromRGB(color) forView:view];
}

+ (void)addShadowToView:(UIView *)view ofSize:(float)size
{
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = shadowOpacity;
    view.layer.shadowRadius = size;
    view.layer.shadowOffset = CGSizeMake(2.0, 2.0);
}

+ (void)addShadowToView:(UIView *)view
{
    view.layer.masksToBounds = NO;
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = shadowOpacity;
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset);
}

+ (void)removeShadowFromView:(UIView *)view
{
    view.layer.masksToBounds = YES;
    view.layer.shadowColor = [UIColor clearColor].CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 0);
}

@end
