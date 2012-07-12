//
//  LayerFormater.m
//  BNote
//
//  Created by Young Kristin on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LayerFormater.h"

@implementation LayerFormater

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
    [LayerFormater roundCornersForLayer:layer to:5.0];
}

+ (void)roundCornersForLayer:(CALayer *)layer to:(float)radius
{
    [layer setCornerRadius:radius];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
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
    [view.layer setShadowOpacity:0.8];
    [view.layer setShadowRadius:size];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];    
}

+ (void)addShadowToView:(UIView *)view
{
    [view.layer setMasksToBounds:NO];
    [view.layer setShadowColor:[UIColor blackColor].CGColor];
    [view.layer setShadowOpacity:0.8];
    [view.layer setShadowRadius:7.0];
    [view.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
}

+ (void)removeShadowFromView:(UIView *)view
{
    [view.layer setMasksToBounds:YES];
    [view.layer setShadowColor:[UIColor clearColor].CGColor];
    [view.layer setShadowRadius:0];
    [view.layer setShadowOpacity:0];
    [view.layer setShadowOffset:CGSizeMake(0, 0)];
}

@end
