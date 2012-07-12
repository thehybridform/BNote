//
//  BNoteLabel.m
//  BeNote
//
//  Created by Young Kristin on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteLabel.h"

@implementation BNoteLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setUserInteractionEnabled:YES];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];

    float width = [self bounds].size.width;

    CGContextRef context = UIGraphicsGetCurrentContext();

    UIColor *color = [BNoteConstants appHighlightColor1];

    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, width - 10, 7);
    CGContextAddLineToPoint(context, width - 5, 17);
    CGContextAddLineToPoint(context, width, 7);
    CGContextClosePath(context);
    CGContextFillPath(context);
    CGContextStrokePath(context);

}

@end
