//
//  AttendeeDetailViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AttendeeDetailViewController.h"
#import "LayerFormater.h"
#import "Attendant.h"
#import "BNoteWriter.h"
#import "BNoteFactory.h"

@interface AttendeeDetailViewController ()
@property (assign, nonatomic) Attendant *attendant;
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLable;
@property (strong, nonatomic) IBOutlet UILabel *lastNameLable;
@property (strong, nonatomic) IBOutlet UILabel *emailLable;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *menuView;

@end

@implementation AttendeeDetailViewController
@synthesize image = _image;
@synthesize firstNameField = _firstNameField;
@synthesize lastNameField = _lastNameField;
@synthesize emailField = _emailField;
@synthesize titleLabel = _titleLabel;
@synthesize attendant = _attendant;
@synthesize firstNameLable = _firstNameLable;
@synthesize lastNameLable = _lastNameLable;
@synthesize emailLable = _emailLable;
@synthesize popup = _popup;
@synthesize menuView = _menuView;

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self setImage:nil];
    [self setFirstNameField:nil];
    [self setLastNameField:nil];
    [self setEmailField:nil];
    [self setTitleLabel:nil];
    [self setFirstNameLable:nil];
    [self setLastNameLable:nil];
    [self setEmailLable:nil];
    [self setMenuView:nil];
}


- (id)initWithAttendant:(Attendant *)attendant;
{
    self = [super initWithNibName:@"AttendeeDetailViewController" bundle:nil];
    if (self) {
        [self setAttendant:attendant];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    Attendant *attendant = [self attendant];
    
    UIImage *image = [UIImage imageWithData:[attendant image]];
    if (!image) {
        image = [[BNoteFactory createIcon:AttendantIcon] image];
    }
    
    [[self image] setImage:image];
    
    [[self firstNameField] setText:[attendant firstName]];
    [[self lastNameField] setText:[attendant lastName]];
    [[self emailField] setText:[attendant email]];
    
    [LayerFormater roundCornersForView:[self view]];
    
//    [LayerFormater addShadowToView:[self menuView]];
    [LayerFormater setBorderWidth:1 forView:[self menuView]];

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(updateFirstName:)
     name:UITextFieldTextDidChangeNotification object:[self firstNameField]];

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(updateLastName:)
     name:UITextFieldTextDidChangeNotification object:[self lastNameField]];

    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(updateEmail:)
     name:UITextFieldTextDidChangeNotification object:[self emailField]];
    
    [[self firstNameField] setDelegate:self];
    [[self lastNameField] setDelegate:self];
    [[self emailField] setDelegate:self];
}

- (void)focus
{
    [[self firstNameField] becomeFirstResponder];
}

- (void)updateFirstName:(NSNotification *)notification
{
    if ([self firstNameField] == [notification object]) {
        [[self attendant] setFirstName:[[self firstNameField] text]];
    }
}

- (void)updateLastName:(NSNotification *)notification
{
    if ([self lastNameField] == [notification object]) {
        [[self attendant] setLastName:[[self lastNameField] text]];
    }
}

- (void)updateEmail:(NSNotification *)notification
{
    if ([self emailField] == [notification object]) {
        [[self attendant] setEmail:[[self emailField] text]];
    }
}

- (IBAction)done:(id)sender
{
    [[self popup] dismissPopoverAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self done:nil];
    return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
