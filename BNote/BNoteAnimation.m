//
//  BNoteAnimation.m
//  BNote
//
//  Created by Young Kristin on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteAnimation.h"

@implementation BNoteAnimation

+ (void)winkInView:(NSArray *)views withDuration:(float)duration andDelay:(float)delay andDelayIncrement:(float)increment
{
    for (UIView *view in views) {
        [self winkInView:view withDuration:duration andDelay:delay += increment];
    }
}

+ (void)winkOutView:(NSArray *)views withDuration:(float)duration andDelay:(float)delay andDelayIncrement:(float)increment
{
    for (UIView *view in views) {
        [self winkOutView:view withDuration:duration andDelay:delay += increment];
    }
}

+ (void)winkInView:(UIView *)view withDuration:(float)duration andDelay:(float)delay
{
    CGRect frame = [view frame];
    CGRect initialFrame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height / 2.0, frame.size.width, 0);
    [view setFrame:initialFrame];
    float alpha = [view alpha];
    
    [view setAlpha:0];
    
    [UIView animateWithDuration:duration
                          delay:delay
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^(void) {
                         [view setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                     }
     ];
    
    
    [UIView animateWithDuration:0.1
                          delay:delay
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^(void) {
                         [view setAlpha:alpha];
                     }
                     completion:^(BOOL finished) {
                     }
     ];
}

+ (void)winkOutView:(UIView *)view withDuration:(float)duration andDelay:(float)delay
{
    CGRect initialFrame = [view frame];
    CGRect frame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height / 2.0, frame.size.width, 0);
    [view setFrame:initialFrame];

    [UIView animateWithDuration:duration
                          delay:delay
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^(void) {
                         [view setFrame:frame];
                     }
                     completion:^(BOOL finished) {
                     }
     ];
    
    
    [UIView animateWithDuration:0.1
                          delay:delay
                        options:(UIViewAnimationOptionCurveEaseOut)
                     animations:^(void) {
                         [view setAlpha:0];
                     }
                     completion:^(BOOL finished) {
                     }];
}

@end
