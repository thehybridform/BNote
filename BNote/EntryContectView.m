//
//  EntryContectView.m
//  BeNote
//
//  Created by Young Kristin on 6/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EntryContectView.h"

@implementation EntryContectView

static const float x = 100.0;

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 1.0);
	CGContextMoveToPoint(context, x, 0.0);
	CGContextAddLineToPoint(context, x, [self bounds].size.height);
	CGContextMoveToPoint(context, x + 2, 0.0);
	CGContextAddLineToPoint(context, x + 2, [self bounds].size.height);
	CGContextStrokePath(context);
    
}

@end
