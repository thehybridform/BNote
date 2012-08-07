//
//  BNoteAnimation.h
//  BNote
//
//  Created by Young Kristin on 5/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


@interface BNoteAnimation : NSObject

+ (void)winkInView:(UIView *)view withDuration:(float)duration andDelay:(float)delay;
+ (void)winkOutView:(UIView *)view withDuration:(float)duration andDelay:(float)delay;

+ (void)winkInView:(NSArray *)views withDuration:(float)duration andDelay:(float)delay andDelayIncrement:(float)increment;
+ (void)winkOutView:(NSArray *)views withDuration:(float)duration andDelay:(float)delay andDelayIncrement:(float)increment;

@end
