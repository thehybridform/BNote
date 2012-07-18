//
//  KeyPointPhotoPickerButton.m
//  BNote
//
//  Created by Young Kristin on 6/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyPointPhotoPickerButton.h"
#import "EntriesViewController.h"
#import "BNoteFactory.h"
#import "Photo.h"
#import "BNoteImageUtils.h"
#import "BNoteWriter.h"

@interface KeyPointPhotoPickerButton()
@property (strong, nonatomic) UIPopoverController *popoverController;

@end

@implementation KeyPointPhotoPickerButton
@synthesize popoverController = _popoverController;

- (void)execute:(id)sender
{
//    EntryContentViewController *controller = [self entryContentViewController];
//    [[controller mainTextView] resignFirstResponder];
    
    [self presentPhotoLibrary];
}

- (void)presentPhotoLibrary
{
    UIImagePickerController *controller = [self imagePickerController];
    [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    id<EntryContent> entryController = [self entryContent];
    
    UIView *view = [entryController view];
    CGRect rect = [view bounds];

    UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:[self imagePickerController]];
    [self setPopoverController:popoverController];

    [popoverController presentPopoverFromRect:rect inView:view 
                        permittedArrowDirections:UIPopoverArrowDirectionUp 
                                        animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [[self popoverController] dismissPopoverAnimated:YES];
    [self setPopoverController:nil];
    
    [self handlePhoto:info];
}

@end
