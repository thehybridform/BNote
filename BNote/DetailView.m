//
//  DetailView.m
//  BeNote
//
//  Created by Young Kristin on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailView.h"

@implementation DetailView

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat height = [self bounds].size.height;
    
	CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    CGContextSetLineWidth(context, 1.0);
	CGContextMoveToPoint(context, 0, 0.0);
	CGContextAddLineToPoint(context, 0, height);
	CGContextStrokePath(context);
}

@end
