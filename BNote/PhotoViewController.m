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
@property (assign, nonatomic) UIImage *image;

@end

@implementation PhotoViewController
@synthesize doneButton = _doneButton;
@synthesize imageView = _imageView;
@synthesize image = _image;

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
    
    [[self imageView] setImage:[self image]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setDoneButton:nil];
    [self setImageView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

@end
