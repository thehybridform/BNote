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
#import "PhotoSketchPath.h"

@interface DrawingView()
@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic) NSMutableArray *redoArray;
@property (strong, nonatomic) NSMutableArray *resetArray;

@end

@implementation DrawingView
@synthesize path = _path;
@synthesize strokeColor = _strokeColor;
@synthesize strokeWidth = _strokeWidth;
@synthesize photo = _photo;
@synthesize redoArray = _redoArray;
@synthesize resetArray = _resetArray;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setRedoArray:[[NSMutableArray alloc] init]];
    }
    
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        [self setPath:[UIBezierPath bezierPath]];
        [[self path] setLineCapStyle:(CGLineCap) kCGLineJoinRound];
        [[self path] setLineWidth:[self strokeWidth]];
        [[self path] moveToPoint:[touch locationInView:self]];
        
        [BNoteFactory addUIBezierPath:[self path] withColor:[self strokeColor] toPhoto:[self photo]];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        [[self path] addLineToPoint:[touch locationInView:self]];
        [self setNeedsDisplay];
    }
}

- (void)undoLast
{
    if ([self resetArray]) {
        for (PhotoSketchPath *path in [self resetArray]) {
            [BNoteFactory addUIBezierPath:[path bezierPath] withColor:[path pathColor] toPhoto:[self photo]];
        }
        [self setResetArray:nil];
    } else {
        SketchPath *path = [[[self photo] sketchPaths] lastObject];
    
        PhotoSketchPath *p = [[PhotoSketchPath alloc] init];
        [p setBezierPath:[path bezierPath]];
        [p setPathColor:[path pathColor]];
    
        [[self redoArray] addObject:p];
    
        [[BNoteWriter instance] removeSketchPath:path];
    }
    
    [self setNeedsDisplay];
}

- (void)redoLast
{
    if ([[self redoArray] count]) {
        PhotoSketchPath *path = [[self redoArray] lastObject];
        [[self redoArray] removeLastObject];
        
        [BNoteFactory addUIBezierPath:[path bezierPath] withColor:[path pathColor] toPhoto:[self photo]];
        [self setNeedsDisplay];
    }
}

- (void)reset
{
    [self setResetArray:[[NSMutableArray alloc] init]];

    for (SketchPath *path in [[self photo] sketchPaths]) {
        PhotoSketchPath *p = [[PhotoSketchPath alloc] init];
        [p setBezierPath:[path bezierPath]];
        [p setPathColor:[path pathColor]];
        
        [[self resetArray] addObject:p];
    }
    
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
    [self setRedoArray:[[NSMutableArray alloc] init]];
}

@end

