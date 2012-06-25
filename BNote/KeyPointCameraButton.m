//
//  KeyPointCameraButton.m
//  BNote
//
//  Created by Young Kristin on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyPointCameraButton.h"
#import "EntriesViewController.h"

@implementation KeyPointCameraButton

- (void)execute:(id)sender
{
    EntryContentViewController *controller = [self entryContentViewController];
    [[controller mainTextView] resignFirstResponder];
    
    [self presentCamera];
}

- (void)presentCamera
{
    [[self imagePickerController] setSourceType:UIImagePickerControllerSourceTypeCamera];
    [[self imagePickerController] setModalPresentationStyle:UIModalPresentationFullScreen];
    [[self imagePickerController] setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    EntryContentViewController *controller = [self entryContentViewController];
    [controller presentModalViewController:[self imagePickerController] animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    EntryContentViewController *controller = [self entryContentViewController];
    [controller dismissModalViewControllerAnimated:YES];
    UIImage *image = [self handlePhoto:info];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

@end
