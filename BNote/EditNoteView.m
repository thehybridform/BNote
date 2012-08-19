//
//  EditNoteView.m
//  BeNote
//
//  Created by Young Kristin on 7/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EditNoteView.h"

@implementation EditNoteView
@synthesize note = _note;

const static float x1 = 20;
const static float x2 = x1 + 17;
const static float x3 = x2 + 17;
const static float h1 = 60;
const static float h2 = h1 - 10;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setBackgroundColor:[BNoteConstants appColor1]];
    }
        
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor *color = UIColorFromRGB([[self note] color]);
    
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, x1, 0.0);
    CGContextAddLineToPoint(context, x1, h1);
    CGContextAddLineToPoint(context, x2, h2);
    CGContextAddLineToPoint(context, x3, h1);
    CGContextAddLineToPoint(context, x3, 0);
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGContextStrokePath(context);
}

@end
