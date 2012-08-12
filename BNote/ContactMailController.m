//
//  ContactMailController.m
//  BeNote
//
//  Created by Young Kristin on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ContactMailController.h"

@implementation ContactMailController

- (id)init
{
    self = [super init];
    
    if (self) {
        [self setMailComposeDelegate:self];
        [self setSubject:@"BeNote "];
        [self setToRecipients:[NSArray arrayWithObject:@"benotesupport@uobia.net"]];
    }
    
    return self;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Failed to Send E-Mail", nil)
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    if (result == MFMailComposeResultSent) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"E-Mail Sent", nil)
                                                        message:NSLocalizedString(@"Thank you for cantacting us!", nil)
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }

    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
}

@end
