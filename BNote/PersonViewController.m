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

@interface PersonViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (assign, nonatomic) Attendant *attendant;

@end

@implementation PersonViewController
@synthesize icon = _icon;
@synthesize nameLabel = _nameLabel;
@synthesize attendant = _attendant;

- (id)initWithAttendant:(Attendant *)attendant
{
    self = [super initWithNibName:@"PersonViewController" bundle:nil];
    if (self) {
        [self setAttendant:attendant];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
//    [LayerFormater setBorderWidth:1 forView:[self icon]];
    [LayerFormater setBorderColor:[UIColor clearColor] forView:[self icon]];

    [[self nameLabel] setFont:[BNoteConstants font:RobotoLight andSize:12.0]];
    [[self nameLabel] setTextColor:[BNoteConstants appHighlightColor1]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setNameLabel:nil];
    [self setIcon:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
