//
//  EmailViewController.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EmailViewController.h"
#import "Note.h"
#import "Entry.h"
#import "Attendant.h"
#import "AttendantFilter.h"
#import "KeyPoint.h"
#import "KeyPointFilter.h"
#import "BNoteFilter.h"
#import "Photo.h"
#import "BNoteRenderer.h"
#import "BNoteRenderFactory.h"

@interface EmailViewController ()
@property (assign, nonatomic) Topic *topic;

@end

@implementation EmailViewController
@synthesize topic = _topic;

- (id)initWithTopic:(Topic *)topic
{
    self = [super init];

    if (self) {
        [self setTopic:topic];

        [self setMailComposeDelegate:self];
        
        NSString *subject = [BNoteStringUtils append:@"Topic: ", [[self topic] title], nil];
        [self setSubject:subject];
        
        NSMutableArray *emails = [[NSMutableArray alloc] init];
        NSEnumerator *attendants = [[self filterEntries:[BNoteFilterFactory create:AttendantType]] objectEnumerator];
        Attendant *attendant;
        while (attendant = [attendants nextObject]) {
            [emails addObject:[attendant email]];
        }
        
        [self setToRecipients:emails];
        
        NSEnumerator *keyPoints = [[self filterEntries:[BNoteFilterFactory create:KeyPointType]] objectEnumerator];
        KeyPoint *keyPoint;
        int i = 0;
        while (keyPoint = [keyPoints nextObject]) {
            if ([keyPoint photo]) {
                NSData *photo = [[keyPoint photo] original];
                NSString *name = [BNoteStringUtils append:@"KeyPoint-Image-", [NSString stringWithFormat:@"%d", i], @"jpeg", nil];
                [self addAttachmentData:photo mimeType:@"image/jpeg" fileName:name];
            }
        }
        
        id<BNoteRenderer> renderer = [BNoteRenderFactory create:Plain];
        [self setMessageBody:[renderer render:[self topic]] isHTML:NO];
    }
    
    return self;
}

- (void)viewDidLoad
{
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (NSArray *)filterEntries:(id <BNoteFilter>)filter
{
    NSMutableArray *filtered = [[NSMutableArray alloc] init];
    
    NSEnumerator *notes = [[[self topic] notes] objectEnumerator];
    Note *note;
    while (note = [notes nextObject]) {
        NSEnumerator *entries = [[note entries] objectEnumerator];
        Entry *entry;
        while (entry = [entries nextObject]) {
            if ([filter accept:entry]) {
                [filtered addObject:entry];
            }
        }
    }
    
    return filtered;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
