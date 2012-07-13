//
//  PhotoCloner.m
//  BeNote
//
//  Created by Young Kristin on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoCloner.h"
#import "Photo.h"
#import "KeyPoint.h"
#import "BNoteFactory.h"
#import "BNoteImageUtils.h"
#import "ClonerFactory.h"

@implementation PhotoCloner

- (Photo *)clone:(Photo *)photo into:(KeyPoint *)keyPoint
{
    Photo *copy = [BNoteFactory createPhoto:keyPoint];
    [copy setOriginal:[self copyImage:[photo original]]];
    [copy setThumbnail:[self copyImage:[photo thumbnail]]];
    [copy setSmall:[self copyImage:[photo small]]];
    [copy setSketch:[self copyImage:[photo sketch]]];
    
    return copy;
}
  
- (NSData *)copyImage:(NSData *)data
{
    UIImage *image = [UIImage imageWithData:data];
    UIImage *copy = [BNoteImageUtils copyImage:image];
    
    return UIImageJPEGRepresentation(copy, 0.8);
}

@end
