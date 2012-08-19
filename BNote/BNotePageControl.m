//
//  BNotePageControl.m
//  BeNote
//
//  Created by kristin young on 7/28/12.
//
//

#import "BNotePageControl.h"

@implementation BNotePageControl
@synthesize activePageColor = _activePageColor;
@synthesize inactivePageColor = _inactivePageColor;

const float dotSize = 5.0;
const float dotsWidth = 7.5;

- (void)drawRect:(CGRect)rect
{
    if ([self hidesForSinglePage] == NO || [self numberOfPages] > 1) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        float offset = (self.frame.size.width - dotsWidth) / 2;
        
        for (NSInteger i = 0; i < [self numberOfPages]; i++) {
            if (i == [self currentPage]) {
                CGContextSetFillColorWithColor(context, [[self activePageColor] CGColor]);
            } else {
                CGContextSetFillColorWithColor(context, [[self inactivePageColor] CGColor]);
            }
            
            CGContextFillEllipseInRect(context,
                                       CGRectMake(offset + (dotSize + 10) * i, (self.frame.size.height / 2) - (dotSize / 2), dotSize, dotSize));
        }
    }
}

- (UIColor *)activePageColor
{
    if (_activePageColor == nil) {
        _activePageColor = [BNoteConstants appHighlightColor1];
    }
    
    return _activePageColor;
}

- (UIColor *)inactivePageColor
{
    if (_inactivePageColor == nil) {
        _inactivePageColor = UIColorFromRGB(0xc0c0c0);
    }
    
    return _inactivePageColor;
}

@end
