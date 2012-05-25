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

+ (void)roundCornersForLayer:(CALayer *)layer
{
    [layer setCornerRadius:7.0];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
}

+ (void)setBorderWidth:(int)thickness forView:(UIView *)view
{
    [[view layer] setBorderWidth:thickness];
}

+ (void)setBorderColor:(UIColor *)color forView:(UIView *)view
{
    [[view layer] setBorderColor:[color CGColor]];
}
@end
