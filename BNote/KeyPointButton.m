//
//  KeyPointButton.m
//  BNote
//
//  Created by Young Kristin on 5/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyPointButton.h"
#import "BNoteWriter.h"
#import "BNoteFactory.h"
#import "BNoteImageUtils.h"

@interface KeyPointButton()

@end

@implementation KeyPointButton
@synthesize keyPoint = _keyPoint;
@synthesize imagePickerController = _imagePickerController;

- (void)initCommon
{
    [self setImagePickerController:[[UIImagePickerController alloc] init]];
    [[self imagePickerController] setDelegate:self];
}

- (UIImage *)handlePhoto:(NSDictionary *)info
{
    KeyPoint *keyPoint = (KeyPoint *) [[self entryCellView] entry];
    [[BNoteWriter instance] removePhoto:[keyPoint photo]];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSData *originalImageData = UIImageJPEGRepresentation(image, 0.8);
    
    Photo *photo = [BNoteFactory createPhoto:keyPoint];
    [photo setOriginal:originalImageData];
    
    CGSize thumbnailSize = CGSizeMake(75.0, 75.0);
    UIImage *thumb = [BNoteImageUtils image:image scaleAndCropToMaxSize:thumbnailSize];
    NSData *thumbImageData = UIImageJPEGRepresentation(thumb, 0.8);
    [photo setThumbnail:thumbImageData];

    CGSize smallSize = CGSizeMake(30.0, 30.0);
    UIImage *small = [BNoteImageUtils image:image scaleAndCropToMaxSize:smallSize];
    NSData *smallImageData = UIImageJPEGRepresentation(small, 0.8);
    [photo setSmall:smallImageData];

    [[BNoteWriter instance] update];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KeyPointPhotoUpdated object:keyPoint];

    return image;
}

@end
