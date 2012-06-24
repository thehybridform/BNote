//
//  KeyPointEntryCell.m
//  BeNote
//
//  Created by Young Kristin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyPointEntryCell.h"
#import "BNoteEntryUtils.h"
#import "BNoteFactory.h"
#import "BNoteSessionData.h"
#import "BNoteWriter.h"
#import "KeyPoint.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "EntriesViewController.h"

@interface KeyPointEntryCell()
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UIPopoverController *popup;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;

@end

@implementation KeyPointEntryCell
@synthesize actionSheet = _actionSheet;
@synthesize popup = _popup;
@synthesize imagePickerController = _imagePickerController;

static NSString *choosePhoto = @"Choose Photo";
static NSString *takePhoto = @"Take Picture";
static NSString *viewFullScreen = @"View Full Screen";
static NSString *removePhoto = @"Remove Photo";

- (KeyPoint *)keyPoint
{
    return (KeyPoint *) [self entry];
}

- (void)setup
{
    [super setup];

    UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showKeyPointOptions:)];
    [self addGestureRecognizer:tap];
}

- (void)showKeyPointOptions:(UITapGestureRecognizer *)gesture
{
    CGPoint location = [gesture locationInView:self];
    if (location.x < 120) {
        [self handleTouch];
    } else {
        [[self textView] becomeFirstResponder];
    }
}

- (void)handleTouch
{
    if (![[BNoteSessionData instance] keyboardVisible]) {
        [self handleImageIcon:YES];
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setDelegate:self];
        
        KeyPoint *keyPoint = [self keyPoint];
        
        if ([keyPoint photo]) {
            [actionSheet addButtonWithTitle:viewFullScreen];
        }
        
        [actionSheet addButtonWithTitle:choosePhoto];
        
        BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
        if (hasCamera) {
            [actionSheet addButtonWithTitle:takePhoto];
        }
        
        if ([keyPoint photo]) {
            NSInteger index = [actionSheet addButtonWithTitle:removePhoto];
            [actionSheet setDestructiveButtonIndex:index];
        }
        
        [actionSheet setTitle:@"Key Point Photo"];
        [self setActionSheet:actionSheet];
        
        CGRect rect = [[self imageView] bounds];
        [actionSheet showFromRect:rect inView:[self imageView] animated:YES];
    }
}
- (void)handleImageIcon:(BOOL)active
{
    KeyPoint *keyPoint = [self keyPoint];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageView:) name:KeyPointPhotoUpdated object:keyPoint];
        
    if ([keyPoint photo]) {
        UIImage *image = [UIImage imageWithData:[[keyPoint photo] thumbnail]];
        [[self imageView] setImage:image];
        
    } else {
        [super handleImageIcon:active];
    }
}

- (void)presentPhotoPicker
{
    
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setDelegate:self];
    [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];

    UIView *view = [self imageView];
    CGRect rect = [view bounds];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [self setPopup:popup];
    
    [popup presentPopoverFromRect:rect inView:self 
                     permittedArrowDirections:UIPopoverArrowDirectionAny 
                                     animated:YES];
}

- (void)presentCamera
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setDelegate:self];
    [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self setImagePickerController:controller];

    [[[self parentController] parentController] presentModalViewController:controller animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [BNoteEntryUtils handlePhoto:info forKeyPoint:[self keyPoint]];
  
    if ([self popup]) {
        [[self popup] dismissPopoverAnimated:YES];
        [self setPopup:nil];
    }
    
    if ([self imagePickerController]) {
        [[self imagePickerController] dismissModalViewControllerAnimated:YES];
        [self setImagePickerController:nil];
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (title == choosePhoto) {
            [self presentPhotoPicker];
        } else if (title == takePhoto) {
            [self presentCamera];
        } else if (title == viewFullScreen) {
            [self showPhoto];
        } else if (title == removePhoto) {
            [self removePhotos];
        }
    }

    [self setActionSheet:nil];
    [self handleImageIcon:NO];
}

- (void)removePhotos
{
    KeyPoint *keyPoint = [self keyPoint];
    [[BNoteWriter instance] removePhoto:[keyPoint photo]];
    [self updateImageViewForKeyPoint:keyPoint];
}

- (void)showPhoto
{
    KeyPoint *keyPoint = [self keyPoint];
    Photo *photo = [keyPoint photo];
    
    UIImage *image = [UIImage imageWithData:[photo original]];
    PhotoViewController *controller = [[PhotoViewController alloc] initWithImage:image];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [[[self parentController] parentController] presentModalViewController:controller animated:YES];
}

- (void)updateImageView:(id)object
{
    NSNotification *notification = object;
    if ([notification object] == [self entry]) {
        KeyPoint *keyPoint = (KeyPoint *) [notification object];
        [self updateImageViewForKeyPoint:keyPoint];
    }
}

- (void)updateImageViewForKeyPoint:(KeyPoint *)keyPoint
{
    if ([keyPoint photo]) {
        UIImage *image = [UIImage imageWithData:[[keyPoint photo] thumbnail]];
        [[self imageView] setImage:image];
    } else {
        UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:NO];
        [[self imageView] setImage:[imageView image]];
    }
}

@end
