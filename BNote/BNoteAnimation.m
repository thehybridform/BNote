//
//  BNoteAnimation.m
//  BNote
//
//  Created by Young Kristin on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteAnimation.h"

@implementation BNoteAnimation

+ (void)startWobble:(UIView *)view
{
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse | UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         CGAffineTransform scale = CGAffineTransformScale([view transform], 1.02, 1.02);
                         [view setTransform:scale];
                     }
                     completion:^(BOOL finished) {
                     }
     ];
}

+ (void)moveEntryView:(UIView *)view xPixels:(float)x yPixels:(float)y withDelay:(float)delay
{
    [UIView animateWithDuration:0.3
                          delay:delay
                        options:(UIViewAnimationOptionCurveEaseIn)
                     animations:^(void) {
                         CGAffineTransform move = CGAffineTransformTranslate([view transform], x, y);
                         [view setTransform:move];
                     }
                     completion:^(BOOL finished) {
                     }
    ];
}

@end
