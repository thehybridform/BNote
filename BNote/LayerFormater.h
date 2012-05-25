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
+ (void)roundCornersForLayer:(CALayer *)layer;
+ (void)setBorderWidth:(int)thickness forView:(UIView *)view;
+ (void)setBorderColor:(UIColor *)color forView:(UIView *)view;


@end
