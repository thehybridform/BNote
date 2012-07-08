//
//  AttendantView.m
//  BNote
//
//  Created by Young Kristin on 6/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendantView.h"
#import "BNoteWriter.h"
#import "BNoteFactory.h"
#import "AttendeeDetailViewController.h"

@interface AttendantView()
@property (strong, nonatomic) UIActionSheet *sheet;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIPopoverController *popup;

@end

@implementation AttendantView
@synthesize attendant = _attendant;
@synthesize sheet = _sheet;
@synthesize imageView = _imageView;
@synthesize popup = _popup;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [BNoteFactory createIcon:AttendantIcon];
        [imageView setFrame:CGRectMake(32, 3, 35, 35)];
        [self addSubview:imageView];
        [self setImageView:imageView];
        
        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(normalPressTap:)];
        [self addGestureRecognizer:tap];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideAttendantView:)
                                                     name:UIKeyboardDidHideNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];            
}

- (void)normalPressTap:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Attendant" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Remove" otherButtonTitles:@"Details", nil];

    CGRect rect = [self bounds];
    [sheet showFromRect:rect inView:self animated:YES];
    
    [self setSheet:sheet];
}

- (void)setAttendant:(Attendant *)attendant
{
    _attendant = attendant;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 90, 10)];
    [nameLabel setLineBreakMode:UILineBreakModeTailTruncation];
    [nameLabel setTextAlignment:UITextAlignmentCenter];
    [nameLabel setFont:[UIFont systemFontOfSize:10]];
    [nameLabel setNumberOfLines:1];
    [nameLabel setBackgroundColor:[UIColor clearColor]];

    NSString *name = [BNoteStringUtils append:[attendant firstName], @" ", [attendant lastName], nil];
    [nameLabel setText:name];

    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 90, 10)];
    [emailLabel setLineBreakMode:UILineBreakModeTailTruncation];
    [emailLabel setTextAlignment:UITextAlignmentCenter];
    [emailLabel setFont:[UIFont systemFontOfSize:10]];
    [emailLabel setNumberOfLines:1];
    [emailLabel setText:[attendant email]];
    [emailLabel setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:nameLabel];
    [self addSubview:emailLabel];
    
    if ([attendant image]) {
        [[self imageView] removeFromSuperview];
        
        NSData *data = [attendant image];
        UIImage *image = [UIImage imageWithData:data];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(32, 3, 35, 35)];
        [self addSubview:imageView];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [[BNoteWriter instance] removeAttendant:[self attendant]];
            [[NSNotificationCenter defaultCenter] postNotificationName:AttendeeDeleted object:nil];
            break;
            
        case 1:
            [self presentAttendeeDetail];
            break;
            
        default:
            break;
    }
}

- (void)presentAttendeeDetail
{
    if ([self popup]) {
        [self setPopup:nil];
    }
    
    AttendeeDetailViewController *controller = [[AttendeeDetailViewController alloc] initWithAttendant:[self attendant]];
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller setPopup:popup];
    
    [popup setDelegate:self];
    
    [popup presentPopoverFromRect:[self frame]
                           inView:self permittedArrowDirections:
                                            (UIPopoverArrowDirectionUp) animated:YES];

    [popup setPopoverContentSize:CGSizeMake(367, 224)];
    [self setPopup:popup];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [[BNoteWriter instance] updateAttendee:[self attendant]];
}

- (void)keyboardDidHideAttendantView:(NSNotification *)notification
{
    if ([self popup] && ![self isHidden]) {
        [[self popup] dismissPopoverAnimated:YES];
        [[BNoteWriter instance] updateAttendee:[self attendant]];
        [self setPopup:nil];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setSheet:nil];
}

@end
