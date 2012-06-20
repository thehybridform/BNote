//
//  KeyPointEntryCell.m
//  BeNote
//
//  Created by Young Kristin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KeyPointEntryCell.h"
#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "KeyPoint.h"
#import "Photo.h"
#import "PhotoViewController.h"
#import "EntriesViewController.h"

@interface KeyPointEntryCell()
@property (strong, nonatomic) UIActionSheet *actionSheet;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;

@end

@implementation KeyPointEntryCell
@synthesize longPress = _longPress;
@synthesize actionSheet = _actionSheet;

- (void)handleImageIcon:(BOOL)active
{
    KeyPoint *keyPoint = (KeyPoint *) [self entry];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateImageView:) name:KeyPointPhotoUpdated object:keyPoint];
        
    if ([keyPoint photo]) {
        UIImage *image = [UIImage imageWithData:[[keyPoint photo] thumbnail]];
        [[self imageView] setImage:image];
            
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressTap:)];
        [self addGestureRecognizer:longPress];
        [self setLongPress:longPress];
    } else {
        [super handleImageIcon:active];
    }
}

- (void)longPressTap:(id)sender
{
    if (![self actionSheet]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Key Point" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove Photo" otherButtonTitles:@"View Photo Full Screen", nil];
        [self setActionSheet:actionSheet];
        
        CGRect rect = [self bounds];
        [actionSheet showFromRect:rect inView:self animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self removePhotos];
            break;
        case 1:    
            [self showPhoto];
            break;
        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setActionSheet:nil];
}

- (void)removePhotos
{
    KeyPoint *keyPoint = (KeyPoint *) [self entry];
    [[BNoteWriter instance] removePhoto:[keyPoint photo]];
    [self updateImageViewForKeyPoint:keyPoint];
}

- (void)showPhoto
{
    KeyPoint *keyPoint = (KeyPoint *) [self entry];
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
        [self removeGestureRecognizer:[self longPress]];
        [self setLongPress:nil];
        UIImageView *imageView = [BNoteFactory createIcon:[self entry] active:NO];
        [[self imageView] setImage:[imageView image]];
    }
}

@end
