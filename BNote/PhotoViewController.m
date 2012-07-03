//
//  PhotoViewController.m
//  BNote
//
//  Created by Young Kristin on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotoViewController.h"

@interface PhotoViewController ()
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign, nonatomic) UIImage *image;

@end

@implementation PhotoViewController
@synthesize doneButton = _doneButton;
@synthesize imageView = _imageView;
@synthesize image = _image;
@synthesize scrollView = _scrollView;

- (id)initWithImage:(UIImage *)image
{
    self = [super initWithNibName:@"PhotoViewController" bundle:nil];
    
    if (self) {
        [self setImage:image];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIScrollView *scrollView = [self scrollView];
    [scrollView setDelegate:self];
    
    UIImageView *imageView = [self imageView];
    [imageView setImage:[self image]];

    CGSize size = CGSizeMake([[self imageView] bounds].size.width, [[self imageView] bounds].size.height);
    [[self scrollView] setContentSize:size];

    [scrollView setMinimumZoomScale:[scrollView frame].size.width / [imageView frame].size.width];
    [scrollView setMaximumZoomScale:3.0]; 
    
    UITapGestureRecognizer *tap =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(done:)];
    [[self view] addGestureRecognizer:tap];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [self imageView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setDoneButton:nil];
    [self setImageView:nil];
    [self setScrollView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
