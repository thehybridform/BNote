//
//  KeyPointContentViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyPointContentViewController.h"
#import "BNoteSessionData.h"
#import "KeyPoint.h"
#import "Photo.h"
#import "BNoteWriter.h"
#import "BNoteFactory.h"
#import "PhotoViewController.h"
#import "PhotoEditorViewController.h"

@interface KeyPointContentViewController()
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UIButton *photoAlbumButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (assign, nonatomic) BOOL hasCamera;
@property (strong, nonatomic) UITapGestureRecognizer *normalTap;
@property (strong, nonatomic) IBOutlet UIView *touchView;

@end

@implementation KeyPointContentViewController
@synthesize imagePickerController = _imagePickerController;
@synthesize cameraButton = _cameraButton;
@synthesize photoAlbumButton = _photoAlbumButton;
@synthesize hasCamera = _hasCamera;
@synthesize normalTap = _normalTap;
@synthesize touchView = _touchView;

- (id)initWithEntry:(Entry *)entry
{
    self = [super initWithNibName:@"KeyPointContentView" bundle:nil];
    
    if (self) {
        [self setEntry:entry];

        UITapGestureRecognizer *normalTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhoto:)];
        [self setNormalTap:normalTap];

        UITableViewCell *cell = (UITableViewCell *) [self view];
        [cell setEditingAccessoryType:UITableViewCellEditingStyleNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    return self;
}

- (KeyPoint *)keyPoint
{
    return (KeyPoint *) [self entry];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    [self setHasCamera:hasCamera];
    if (!hasCamera) {
        [[self cameraButton] setHidden:YES];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageView:) name:KeyPointPhotoUpdated object:[self keyPoint]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setImagePickerController:nil];
    [self setCameraButton:nil];
    [self setPhotoAlbumButton:nil];
    [self setNormalTap:nil];
    [self setTouchView:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (float)height
{
    float height = 45;
    if ([self hasCamera]) {
        height += 45;
    }
    
    return MAX(height, [super height]);
}

- (void)handleImageIcon:(BOOL)active
{
    KeyPoint *keyPoint = [self keyPoint];
    
    if ([keyPoint photo]) {
        UIImage *image = [UIImage imageWithData:[[keyPoint photo] thumbnail]];
        [[self iconView] setImage:image];
        [[self touchView] addGestureRecognizer:[self normalTap]];
    } else {
        [super handleImageIcon:active];
        [[self touchView] removeGestureRecognizer:[self normalTap]];
    }
}

- (IBAction)presentPhotoAlbum:(id)sender
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setDelegate:self];
    [controller setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    UIView *view = [self photoAlbumButton];
    CGRect rect = [view bounds];
    
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [[BNoteSessionData instance] setPopup:popup];
    
    [popup presentPopoverFromRect:rect inView:view 
         permittedArrowDirections:UIPopoverArrowDirectionAny 
                         animated:YES];
}

- (IBAction)presentCamera:(id)sender
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setDelegate:self];
    [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self setImagePickerController:controller];

    [[self parentController] presentModalViewController:controller animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    BOOL save = ![info objectForKey:UIImagePickerControllerReferenceURL];
    [BNoteEntryUtils handlePhoto:info forKeyPoint:[self keyPoint] saveToLibrary:save];
                   
    if ([[BNoteSessionData instance] popup]) {
        [[[BNoteSessionData instance] popup] dismissPopoverAnimated:YES];
        [[BNoteSessionData instance] setPopup:nil];
    }
    
    if ([self imagePickerController]) {
        [[self imagePickerController] dismissModalViewControllerAnimated:YES];
        [self setImagePickerController:nil];
    }
}

- (void)removePhotos
{
    KeyPoint *keyPoint = [self keyPoint];
    [[BNoteWriter instance] removePhoto:[keyPoint photo]];
    [self handleImageIcon:NO];
}

- (void)showPhoto:(id)sender
{
    KeyPoint *keyPoint = [self keyPoint];
    Photo *photo = [keyPoint photo];
    
    UIImage *image;
    if ([[photo sketchPaths] count]) {
        image = [UIImage imageWithData:[photo sketch]];
    } else {
        image = [UIImage imageWithData:[photo original]];
    }
    PhotoViewController *controller = [[PhotoViewController alloc] initWithImage:image];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
        
    [[self parentController] presentModalViewController:controller animated:YES];
}

- (void)updateImageView:(NSNotification *)notification
{
    [self handleImageIcon:NO];
}

- (IBAction)presentPhotoEditor:(id)sender
{
    if (![[self keyPoint] photo]) {
        Photo *photo = [BNoteFactory createPhoto:[self keyPoint]];
        [photo setOriginal:UIImageJPEGRepresentation([BNoteFactory paper], 0.8)];
    }
    
    PhotoEditorViewController *controller = [[PhotoEditorViewController alloc] initDefault];
    [controller setModalInPopover:YES];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [controller setKeyPoint:[self keyPoint]];
    
    [[self parentController] presentModalViewController:controller animated:YES];
    
}

@end
