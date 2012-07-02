//
//  DrawingView.m
//  BeNote
//
//  Created by Young Kristin on 6/29/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DrawingView.h"
#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "SketchPath.h"

@interface DrawingView()
@property (strong, nonatomic) UIBezierPath *path;

@end

@implementation DrawingView
@synthesize path = _path;
@synthesize strokeColor = _strokeColor;
@synthesize strokeWidth = _strokeWidth;
@synthesize photo = _photo;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
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

        [BNoteFactory addUIBezierPath:[self path] withColor:[self strokeColor] toPhoto:[self photo]];
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
    SketchPath *path = [[[self photo] sketchPaths] lastObject];
    [[BNoteWriter instance] removeSketchPath:path];
    [self setNeedsDisplay];
}

- (void)reset
{
    [[BNoteWriter instance] removeAllSketchPathFromPhoto:[self photo]];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    for (SketchPath *path in [[self photo] sketchPaths]) {
        [(UIColor *) [path pathColor] set];
        [(UIBezierPath *) [path bezierPath] stroke];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[BNoteWriter instance] update];
}

@end
