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

+ (void)startWobble:(UIView *)view;
+ (void)moveEntryView:(UIView *)view xPixels:(float)x yPixels:(float)y withDelay:(float)delay;


@end
