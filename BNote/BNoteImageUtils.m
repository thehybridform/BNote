//
//  BNoteImageUtils.m
//  BNote
//
//  Created by Young Kristin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteImageUtils.h"

@implementation BNoteImageUtils

+ (UIImage *)copyImage:(UIImage *)image
{
    return [UIImage imageWithCGImage:image.CGImage];
}

+ (UIImage *)image:(UIImage *)image scaleAspectToMaxSize:(CGFloat)newSize
{
    CGSize size = [image size];
    CGFloat ratio;
    if (size.width > size.height) {
        ratio = newSize / size.width;
    } else {
        ratio = newSize / size.height;
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, ratio * size.width, ratio * size.height);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    return scaledImage;
}

+ (UIImage *)image:(UIImage *)image scaleAndCropToMaxSize:(CGSize)newSize
{
    CGFloat largestSize = (newSize.width > newSize.height) ? newSize.width : newSize.height;
    CGSize imageSize = [image size];
    
    CGFloat ratio;
    if (imageSize.width > imageSize.height) {
        ratio = largestSize / imageSize.height;
    } else {
        ratio = largestSize / imageSize.width;
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, ratio * imageSize.width, ratio * imageSize.height);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    CGFloat offsetX = 0;
    CGFloat offsetY = 0;
    imageSize = [scaledImage size];
    if (imageSize.width < imageSize.height) {
        offsetY = (imageSize.height / 2) - (imageSize.width / 2);
    } else {
        offsetX = (imageSize.width / 2) - (imageSize.height / 2);
    }
    
    CGRect cropRect = CGRectMake(offsetX, offsetY,
                                 imageSize.width - (offsetX * 2),
                                 imageSize.height - (offsetY * 2));
    
    CGImageRef croppedImageRef = CGImageCreateWithImageInRect([scaledImage CGImage], cropRect);
    UIImage *newImage = [UIImage imageWithCGImage:croppedImageRef];
    CGImageRelease(croppedImageRef);
    
    return newImage;
}

@end
