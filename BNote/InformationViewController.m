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

@interface InformationViewController ()
@property (strong, nonatomic) NSArray *aboutArray;
@property (strong, nonatomic) NSArray *storageArray;
@property (strong, nonatomic) IBOutlet UIView *menu;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@end

@implementation InformationViewController
@synthesize aboutArray = _aboutArray;
@synthesize storageArray = _storageArray;
@synthesize menu = _menu;
@synthesize doneButton = _doneButton;

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


    NSArray *aboutArray =
    [NSArray arrayWithObjects:@"Version 1.0", @"A musing of Uobia, Copyright 2012", @"License", @"Contact Us", nil];
    [self setAboutArray:aboutArray];
    
    NSArray *storageArray =
    [NSArray arrayWithObjects:@"BeNote Google+ Page", nil];
    [self setStorageArray:storageArray];
    
    [LayerFormater setBorderWidth:1 forView:[self menu]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [self setStorageArray:nil];
    [self setAboutArray:nil];
    [self setMenu:nil];
    [self setDoneButton:nil];
}

- (IBAction)done:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return [[self aboutArray] count];
    } else {
        return [[self storageArray] count];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"About";
    } else {
        return @"More Information";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    if ([indexPath section] == 0) {
        [[cell textLabel] setText:[[self aboutArray] objectAtIndex:[indexPath row]]];
    } else {
        [[cell textLabel] setText:[[self storageArray] objectAtIndex:[indexPath row]]];
    }
    
    if ([indexPath section] == 0) {
        if ([indexPath row] == 0 || [indexPath row] == 1) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        } else {
            [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
        }
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
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
    if ([indexPath section] == 0) {
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
    } else {
        [self dismissModalViewControllerAnimated:YES];
        NSURL *url = [NSURL URLWithString:@"http://plus.google.com/113838676367829565073/"];
        [[UIApplication sharedApplication] openURL:url];
    }
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
