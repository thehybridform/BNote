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
#import "LayerFormater.h"
#import "BNoteAnimation.h"

@interface KeyPointContentViewController()
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (strong, nonatomic) IBOutlet UIButton *photoAlbumButton;
@property (strong, nonatomic) IBOutlet UIButton *cameraButton;
@property (strong, nonatomic) IBOutlet UIButton *sketchButton;
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
    
    [self setCameraButton:nil];
    [self setPhotoAlbumButton:nil];
    [self setSketchButton:nil];
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

- (float)height
{
    UITextView *view = [[UITextView alloc] init];
    [view setText:[[self entry] text]];
    [view setFont:[BNoteConstants font:RobotoRegular andSize:16]];
    [view setFrame:CGRectMake(0, 0, [self width] - 200, 90)];

    return MAX(100, [view contentSize].height + 10);
}

- (void)updatePhotoImage:(NSNotification *)notification
{
    if ([notification object] == [self keyPoint]) {
        [self handlePhotoImage];
    }
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
        [actionSheet showFromRect:rect inView:[self view] animated:YES];   
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

- (void)hideControls
{
    [[self cameraButton] setHidden:YES];
    [[self photoAlbumButton] setHidden:YES];
    [[self sketchButton] setHidden:YES];
}

- (void)showControls
{
    BOOL hasCamera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    [[self cameraButton] setHidden:!hasCamera];
    [[self photoAlbumButton] setHidden:NO];
    [[self sketchButton] setHidden:NO];

    NSArray *views = [[NSArray alloc]
                      initWithObjects:
                      [self photoImageView],
                      [self cameraButton],
                      [self photoAlbumButton],
                      [self sketchButton],
                      nil];
    [BNoteAnimation winkInView:views withDuration:0.06 andDelay:0.5 andDelayIncrement:0.2];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
