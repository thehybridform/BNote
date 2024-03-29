//
//  PersonViewController.m
//  BeNote
//
//  Created by Young Kristin on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PersonViewController.h"
#import "BNoteFactory.h"
#import "LayerFormater.h"
#import "ContactMailController.h"
#import "BNoteSessionData.h"

@interface PersonViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UIView *shadowView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) Attendant *attendant;

@end

@implementation PersonViewController
@synthesize icon = _icon;
@synthesize nameLabel = _nameLabel;
@synthesize attendant = _attendant;
@synthesize shadowView = _shadowView;

static NSString *emailText;
static NSString *attendantOptionsText;

- (id)initWithAttendant:(Attendant *)attendant
{
    self = [super initWithNibName:@"PersonViewController" bundle:nil];
    if (self) {
        [self setAttendant:attendant];

        UITapGestureRecognizer *tap = 
            [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentEmailOptions:)];
        
        [[self view] addGestureRecognizer:tap];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    attendantOptionsText = NSLocalizedString(@"Attendant Options", @"Options for the attendant.");
    emailText = NSLocalizedString(@"Send E-mail", @"Send an email to this person.");

    Attendant *attendant = [self attendant];

    NSString *name = [BNoteStringUtils append:[attendant firstName], @" ", [attendant lastName], nil];
    [[self nameLabel] setText:name];

    UIImage *icon = [UIImage imageWithData:[attendant image]];
    
    if (icon) {
        [[self icon] setImage:icon];
    } else {
        [[self icon] setImage:[[BNoteFactory createIcon:AttendantIcon] image]];
    }
    
    [LayerFormater roundCornersForView:[self icon]];
    [LayerFormater setBorderColor:[UIColor clearColor] forView:[self icon]];
    
    [LayerFormater addShadowToView:self.shadowView];

    [[self nameLabel] setFont:[BNoteConstants font:RobotoLight andSize:12.0]];
    [[self nameLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setNameLabel:nil];
    [self setIcon:nil];
    self.shadowView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)presentEmailOptions:(id)sender
{
    if (![BNoteStringUtils nilOrEmpty:[[self attendant] email]]) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        [actionSheet setDelegate:[BNoteSessionData instance]];
        [[BNoteSessionData instance] setActionSheet:actionSheet];
        [[BNoteSessionData instance] setActionSheetDelegate:self];
    
        [actionSheet addButtonWithTitle:emailText];
    
        [actionSheet setTitle:attendantOptionsText];
    
        CGRect rect = [[self icon] frame];
        [actionSheet showFromRect:rect inView:[self view] animated:NO];
    }
}

- (void)presentEmailer
{
    ContactMailController *controller = [[ContactMailController alloc] init];
    [controller setModalInPopover:YES];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [controller setToRecipients:[NSArray arrayWithObject:[[self attendant] email]]];

    [self presentViewController:controller animated:YES completion:^{}];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex >= 0) {
        NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:emailText]) {
            [self presentEmailer];
        }
    }
}

@end
