//
//  BNoteImageUtils.h
//  BNote
//
//  Created by Young Kristin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNoteImageUtils : NSObject

+ (UIImage *)image:(UIImage *)image scaleAspectToMaxSize:(CGFloat)newSize;
+ (UIImage *)image:(UIImage *)image scaleAndCropToMaxSize:(CGSize)newSize;
+ (UIImage *)copyImage:(UIImage *)image;

@end
