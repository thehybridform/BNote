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
#import "BNoteSessionData.h"
#import "AttendeeDetailViewController.h"
#import "LayerFormater.h"

@interface AttendantView()
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIPopoverController *popup;

@end

@implementation AttendantView
@synthesize attendant = _attendant;
@synthesize imageView = _imageView;
@synthesize popup = _popup;

static NSString *attendantOptions;
static NSString *detailsText;
static NSString *removeAttendanText;

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
    
    detailsText = NSLocalizedString(@"Details", @"Show attenant details.");
    removeAttendanText = NSLocalizedString(@"Remove", @"Remove attenant from note.");
    attendantOptions = NSLocalizedString(@"Attendee Options", @"Attendee options menu title.");
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)normalPressTap:(id)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] init];
    [sheet setDelegate:[BNoteSessionData instance]];
    [[BNoteSessionData instance] setActionSheet:sheet];
    [[BNoteSessionData instance] setActionSheetDelegate:self];
    
    [sheet addButtonWithTitle:detailsText];
    int index = [sheet addButtonWithTitle:removeAttendanText];
    [sheet setDestructiveButtonIndex:index];
    
    sheet.title = attendantOptions;
    
    CGRect rect = [self bounds];
    [sheet showFromRect:rect inView:self animated:NO];
}

- (void)setAttendant:(Attendant *)attendant
{
    _attendant = attendant;
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 50, 90, 10)];
    [nameLabel setLineBreakMode:UILineBreakModeTailTruncation];
    [nameLabel setTextAlignment:UITextAlignmentCenter];
    [nameLabel setFont:[BNoteConstants font:RobotoLight andSize:10]];
    [nameLabel setNumberOfLines:1];

    NSString *name = [BNoteStringUtils append:[attendant firstName], @" ", [attendant lastName], nil];
    [nameLabel setText:name];

    UILabel *emailLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 60, 90, 10)];
    [emailLabel setLineBreakMode:UILineBreakModeTailTruncation];
    [emailLabel setTextAlignment:UITextAlignmentCenter];
    [emailLabel setFont:[BNoteConstants font:RobotoLight andSize:10]];
    [emailLabel setNumberOfLines:1];
    [emailLabel setText:[attendant email]];
    
    [self addSubview:nameLabel];
    [self addSubview:emailLabel];
    
    if ([attendant image]) {
        [[self imageView] removeFromSuperview];
        
        NSData *data = [attendant image];
        UIImage *image = [UIImage imageWithData:data];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:CGRectMake(32, 3, 35, 35)];
        [self addSubview:imageView];
        [LayerFormater roundCornersForView:imageView];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if (title == detailsText) {
            [self presentAttendeeDetail];
        } else if (title == removeAttendanText) {
            Attendants *parent = [[self attendant] parent];
            [parent removeChildrenObject:[self attendant]];
            [[NSNotificationCenter defaultCenter] postNotificationName:kAttendeeDeleted object:nil];
        }
    }
    
    [[BNoteSessionData instance] setActionSheet:nil];
}

- (void)presentAttendeeDetail
{
    AttendeeDetailViewController *controller = [[AttendeeDetailViewController alloc] initWithAttendant:[self attendant]];
    UIPopoverController *popup = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller setPopup:popup];
    
    [popup setDelegate:self];
    
    [popup presentPopoverFromRect:[self frame]
                           inView:[self superview] permittedArrowDirections:
                                            (UIPopoverArrowDirectionAny) animated:NO];

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

@end
