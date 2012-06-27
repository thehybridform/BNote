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

@interface InformationViewController ()
@property (strong, nonatomic) NSArray *aboutArray;
@property (strong, nonatomic) NSArray *storageArray;

@end

@implementation InformationViewController
@synthesize aboutArray = _aboutArray;
@synthesize storageArray = _storageArray;

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
    [NSArray arrayWithObjects:@"iCloud", nil];
    [self setStorageArray:storageArray];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
        return @"Storage";
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
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([indexPath row] == 0 || [indexPath row] == 1) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
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
