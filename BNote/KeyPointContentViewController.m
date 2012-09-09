//
//  KeyPointContentViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyPointContentViewController.h"
#import "BNoteSessionData.h"
#import "Photo.h"
#import "BNoteWriter.h"
#import "BNoteFactory.h"
#import "PhotoViewController.h"
#import "PhotoEditorViewController.h"
#import "LayerFormater.h"
#import "BNoteAnimation.h"

@interface KeyPointContentViewController()
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) UIButton *photoAlbumButton;
@property (strong, nonatomic) UIButton *cameraButton;
@property (strong, nonatomic) UIButton *sketchButton;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation KeyPointContentViewController
@synthesize imagePickerController = _imagePickerController;
@synthesize cameraButton = _cameraButton;
@synthesize photoAlbumButton = _photoAlbumButton;
@synthesize sketchButton = _sketchButton;
@synthesize photoImageView = _photoImageView;

static NSString *removeImageText;
static NSString *imageOptionsText;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setPhotoImageView:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString *)localNibName
{
    return @"KeyPointContentView";
}

- (KeyPoint *)keyPoint
{
    return (KeyPoint *) [self entry];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageOptionsText = NSLocalizedString(@"Image Options", @"Image options menu title");
    removeImageText = NSLocalizedString(@"Remove", @"Remove");
    
    
    UITapGestureRecognizer *normalTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPhoto:)];
    [[self photoImageView] addGestureRecognizer:normalTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showDelete:)];
    [[self photoImageView] addGestureRecognizer:longPress];
    
    [LayerFormater roundCornersForView:[self photoImageView]];
    
    [self handlePhotoImage];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePhotoImage:)
                                                 name:kKeyPointPhotoUpdated object:nil];
}

- (void)updatePhotoImage:(NSNotification *)notification
{
    if ([notification object] == [self keyPoint]) {
        [self handlePhotoImage];
    }
}

- (NSArray *)quickActionButtons
{
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    UIButton *button = [BNoteFactory buttonForImage:@"bnote-photos.png"];
    self.photoAlbumButton = button;
    [button addTarget:self action:@selector(presentPhotoAlbum:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
    
    button = [BNoteFactory buttonForImage:@"bnote-sketch.png"];
    self.sketchButton = button;
    [button addTarget:self action:@selector(presentPhotoEditor:) forControlEvents:UIControlEventTouchUpInside];
    [buttons addObject:button];
    
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if (hasCamera) {
        button = [BNoteFactory buttonForImage:@"bnote-take-snapshot.png"];
        self.cameraButton = button;
        [button addTarget:self action:@selector(presentCamera:) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:button];
    }

    return buttons;
}

- (void)handlePhotoImage
{
    Photo *photo = [[self keyPoint] photo];
    if (photo) {
        [[self photoImageView] setHidden:NO];
        UIImage *image = [UIImage imageWithData:[photo thumbnail]];
        [[self photoImageView] setImage:image];
    } else {
        [[self photoImageView] setHidden:YES];
    }
}

- (void)presentPhotoAlbum:(id)sender
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
                         animated:NO];
}

- (void)presentCamera:(id)sender
{
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    [controller setDelegate:self];
    [controller setSourceType:UIImagePickerControllerSourceTypeCamera];
    [controller setModalPresentationStyle:UIModalPresentationFullScreen];
    [controller setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
    
    [self setImagePickerController:controller];

    [[[BNoteSessionData instance] mainViewController] presentModalViewController:controller animated:YES];
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
        
    [[[BNoteSessionData instance] mainViewController] presentModalViewController:controller animated:YES];
}

- (void)updateImageView:(NSNotification *)notification
{
    [self handlePhotoImage];
}

- (void)presentPhotoEditor:(id)sender
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
    
    [[[BNoteSessionData instance] mainViewController] presentModalViewController:controller animated:YES];
}

- (void)showDelete:(id)sender
{
    if (![[BNoteSessionData instance] actionSheet]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setDelegate:[BNoteSessionData instance]];
        [[BNoteSessionData instance] setActionSheetDelegate:self];
        [[BNoteSessionData instance] setActionSheet:actionSheet];
    
        int index = [actionSheet addButtonWithTitle:removeImageText];
        [actionSheet setDestructiveButtonIndex:index];
    
        [actionSheet setTitle:imageOptionsText];
    
        CGRect rect = [[self photoImageView] frame];
        [actionSheet showFromRect:rect inView:[self view] animated:NO];   
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (title == removeImageText) {
            [[BNoteWriter instance] removePhoto:[[self keyPoint] photo]];
            [[BNoteWriter instance] update];
            [self handlePhotoImage];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
