//
//  DrawingView.m
//  BeNote
//
//  Created by Young Kristin on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawingView.h"
#import "ColorPath.h"

@interface DrawingView()
@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) NSMutableArray *paths;

@end

@implementation DrawingView
@synthesize path = _path;
@synthesize strokeColor = _strokeColor;
@synthesize strokeWidth = _strokeWidth;
@synthesize paths = _paths;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setPaths:[[NSMutableArray alloc] init]];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSEnumerator *items = [touches objectEnumerator];
    UITouch *touch;
    if (touch = [items nextObject]) {
        [self setPath:[UIBezierPath bezierPath]];
        [[self path] setLineCapStyle:kCGLineJoinRound];
        [[self path] setLineWidth:[self strokeWidth]];
        [[self path] moveToPoint:[touch locationInView:self]];

        ColorPath *path = [[ColorPath alloc] init];
        [path setColor:[self strokeColor]];
        [path setPath:[self path]];
        
        [[self paths] addObject:path];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSEnumerator *items = [touches objectEnumerator];
    UITouch *touch;
    if (touch = [items nextObject]) {
        [[self path] addLineToPoint:[touch locationInView:self]];
        [self setNeedsDisplay];
    }
}

- (void)undoLast
{
    [[self paths] removeLastObject];
    [self setNeedsDisplay];
}

- (void)reset
{
    [[self paths] removeAllObjects];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    for (ColorPath *path in [self paths]) {
        [[path color] set];
        [[path path] stroke];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{

}

@end
