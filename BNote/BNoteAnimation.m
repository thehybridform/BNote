//
//  BNoteAnimation.m
//  BNote
//
//  Created by Young Kristin on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteAnimation.h"

@implementation BNoteAnimation

+ (void)winkInView:(NSArray *)views withDuration:(float)duration andDelay:(float)delay andDelayIncrement:(float)increment spark:(BOOL)spark
{
    for (UIView *view in views) {
        [self winkInView:view withDuration:duration andDelay:delay += increment spark:spark];
    }
}

+ (void)winkInView:(UIView *)view withDuration:(float)duration andDelay:(float)delay spark:(BOOL)spark
{
    CGRect frame = [view frame];
    CGRect initialFrame = CGRectMake(frame.origin.x, frame.origin.y + frame.size.height / 2.0, frame.size.width, 0);
    [view setFrame:initialFrame];
    float alpha = [view alpha];
    
    [view setAlpha:0];
    
    if (spark) {
        UIView *sparkView = [[UIView alloc] initWithFrame:frame];
        [[sparkView layer] setCornerRadius:15];
        [sparkView setBackgroundColor:[BNoteConstants appColor1]];
        [sparkView setAlpha:0.5];
        [[view superview] addSubview:sparkView];
    
        CGRect finalSparkFrame = CGRectMake(frame.origin.x + frame.size.width / 2, frame.origin.y + frame.size.height / 2.0, 0, 0);
    
        [UIView animateWithDuration:0.8
                              delay:delay * 2 / 3
                            options:(UIViewAnimationOptionCurveEaseOut)
                         animations:^(void) {
                             [sparkView setAlpha:0];
                             [sparkView setFrame:finalSparkFrame];
                         }
                         completion:^(BOOL finished) {
                             [sparkView removeFromSuperview];
                         }
         ];
    }
    
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

@end
