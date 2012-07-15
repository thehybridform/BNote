//
//  LayerFormater.h
//  BNote
//
//  Created by Young Kristin on 5/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

@interface LayerFormater : NSObject

+ (void)roundCornersForView:(UIView *)view;
+ (void)roundCornersForView:(UIView *)view to:(float)radius;
+ (void)roundCornersForLayer:(CALayer *)layer;
+ (void)roundCornersForLayer:(CALayer *)layer to:(float)radius;
+ (void)setBorderWidth:(CGFloat)thickness forView:(UIView *)view;
+ (void)setBorderColor:(UIColor *)color forView:(UIView *)view;
+ (void)setBorderColorWithInt:(int)color forView:(UIView *)view;
+ (void)addShadowToView:(UIView *)view;
+ (void)addShadowToView:(UIView *)view withColor:(UIColor *)color;
+ (void)addShadowToView:(UIView *)view ofSize:(float)size;
//+ (void)removeShadowFromView:(UIView *)view;


@end
