//
//  InformationViewController.m
//  BeNote
//
//  Created by Young Kristin on 6/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InformationViewController.h"
#import "EluaViewController.h"
#import "ContactMailController.h"
#import "LayerFormater.h"
#import "BNoteDefaultData.h"
#import "TopicGroup.h"
#import "BNoteReader.h"
#import "ProgressViewController.h"

@interface InformationViewController ()
@property (strong, nonatomic) NSArray *aboutArray;
@property (strong, nonatomic) NSArray *storageArray;
@property (strong, nonatomic) NSArray *defaultsArray;
@property (strong, nonatomic) IBOutlet UIView *menu;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UIView *progressView;
@property (strong, nonatomic) IBOutlet UIView *progressBackgroundView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;

@end

@implementation InformationViewController
@synthesize aboutArray = _aboutArray;
@synthesize storageArray = _storageArray;
@synthesize menu = _menu;
@synthesize doneButton = _doneButton;
@synthesize defaultsArray = _defaultsArray;
@synthesize progressView = _progressView;
@synthesize progressBackgroundView = _progressBackgroundView;
@synthesize activityView = _activityView;

- (id)initWithDefault
{
    self = [super initWithNibName:@"InformationViewController" bundle:nil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LayerFormater roundCornersForView:[self progressBackgroundView]];
    [[self progressView] setHidden:YES];
    [[self progressView] setBackgroundColor:[UIColor clearColor]];

    NSArray *aboutArray =
    [NSArray arrayWithObjects:@"Version 1.0", @"A musing of Uobia, Copyright 2012", @"License", @"Contact Us", nil];
    [self setAboutArray:aboutArray];
    
    NSArray *storageArray =
    [NSArray arrayWithObjects:@"BeNote Google+ Page", nil];
    [self setStorageArray:storageArray];
    
    NSArray *defaults =
    [NSArray arrayWithObjects:@"Create Help Notes", nil];
    [self setDefaultsArray:defaults];

    [LayerFormater setBorderWidth:1 forView:[self menu]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setStorageArray:nil];
    [self setAboutArray:nil];
    [self setMenu:nil];
    [self setDoneButton:nil];
    [self setDefaultsArray:nil];
    [self setProgressView:nil];
    [self setProgressBackgroundView:nil];
    [self setActivityView:nil];
}

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [[self aboutArray] count];
            break;
            
        case 1:
            return [[self storageArray] count];
            break;
            
        default:
            return [[self defaultsArray] count];
            break;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"About";
            break;
            
        case 1:
            return @"More Information";
            break;
            
        default:
            return @"Help";
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    switch ([indexPath section]) {
        case 0:
            [[cell textLabel] setText:[[self aboutArray] objectAtIndex:[indexPath row]]];
            if ([indexPath row] == 0 || [indexPath row] == 1) {
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            } else {
                [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            }
            break;
            
        case 1:
            [[cell textLabel] setText:[[self storageArray] objectAtIndex:[indexPath row]]];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            break;
            
        default:
            [[cell textLabel] setText:[[self defaultsArray] objectAtIndex:[indexPath row]]];
            break;
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch ([indexPath section]) {
        case 0:
            switch ([indexPath row]) {
                case 2:
                    [self showElua];
                    break;
                    
                case 3:
                    [self showEmail];
                    break;
                    
                default:
                    break;
            }
            break;
            
        case 1:
        {
            [self dismissModalViewControllerAnimated:YES];
            NSURL *url = [NSURL URLWithString:@"http://plus.google.com/113838676367829565073/"];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
            
        default:
        {
            [[self progressView] setHidden:NO];
            [[self activityView] startAnimating];
            
            [self performSelector: @selector(setup)
                       withObject: nil
                       afterDelay: 0];
        }
            break;
    }
}

- (void)setup
{
    [BNoteDefaultData setup];
    
    [self dismissModalViewControllerAnimated:YES];
    
    TopicGroup *group = [[BNoteReader instance] getTopicGroup:@"All"];
    [[NSNotificationCenter defaultCenter] postNotificationName:TopicGroupSelected object:group];
}

- (void)showElua
{
    EluaViewController *controller = [[EluaViewController alloc] initWithDefault];
    [controller setModalInPopover:YES];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:controller animated:YES];
}

- (void)showEmail
{
    ContactMailController *controller = [[ContactMailController alloc] init];
    [controller setModalInPopover:YES];
    [controller setModalPresentationStyle:UIModalPresentationPageSheet];
    [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    
    [self presentModalViewController:controller animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
