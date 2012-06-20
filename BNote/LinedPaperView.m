//
//  LinedPaperView.m
//  BeNote
//
//  Created by Young Kristin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LinedPaperView.h"
#import "BNoteConstants.h"

@interface LinedPaperView()
@property (assign, nonatomic) float x;
@property (assign, nonatomic) float height;

@end

@implementation LinedPaperView
@synthesize x = _x;
@synthesize height = _height;

- (id)initWithLineAtX:(float)x withHeight:(float)height
{
    self = [super init];
    if (self) {
        [self setBackgroundColor:[BNoteConstants appColor1]];
        [self setX:x];
        [self setHeight:height];
    }
        
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
	CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetLineWidth(context, 1.0);
	CGContextMoveToPoint(context, [self x], 0.0);
	CGContextAddLineToPoint(context, [self x], [self height]);
	CGContextMoveToPoint(context, [self x] + 3, 0.0);
	CGContextAddLineToPoint(context, [self x] + 3, [self height]);
	CGContextStrokePath(context);

}

@end
