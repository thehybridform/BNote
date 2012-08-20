//
//  EmailViewController.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "EmailViewController.h"
#import "Note.h"
#import "Entry.h"
#import "Attendant.h"
#import "Attendants.h"
#import "AttendantFilter.h"
#import "KeyPoint.h"
#import "KeyPointFilter.h"
#import "BNoteFilter.h"
#import "Photo.h"
#import "BNoteRenderer.h"
#import "BNoteRenderFactory.h"
#import "DrawingView.h"

@interface EmailViewController ()

@end

@implementation EmailViewController

- (id)initWithAttachment:(NSData *)attachment mimeType:(NSString *)mimeType filename:(NSString *)filename
{
    self = [super init];
    if (self) {
        [self setMailComposeDelegate:self];
        
        [self setSubject:@"BeNote Archive"];
        
        [self addAttachmentData:attachment mimeType:mimeType fileName:filename];
    }
    
    return self;
}

- (id)initWithTopic:(Topic *)topic
{
    NSMutableArray *allNotes = [[topic notes] mutableCopy];

    for (Note *note in [topic associatedNotes]) {
        [allNotes addObject:note];
    }
    
    self = [self initCommon:topic and:allNotes];
    
    id<BNoteRenderer> renderer = [BNoteRenderFactory create:Plain];
    [self setMessageBody:[renderer render:topic] isHTML:NO];

    return self;
}

- (id)initWithNote:(Note *)note
{
    NSArray *allNotes = [NSArray arrayWithObject:note];
    self = [self initCommon:[note topic] and:allNotes];

    id<BNoteRenderer> renderer = [BNoteRenderFactory create:Plain];
    [self setMessageBody:[renderer render:[note topic] and:note] isHTML:NO];
    
    return self;
}

- (id)initCommon:(Topic *)topic and:(NSArray *)allNotes
{
    self = [super init];
    
    if (self) {
        
        [self setMailComposeDelegate:self];
        
        NSString *subject = [BNoteStringUtils append:@"Topic: ", [topic title], nil];
        [self setSubject:subject];
                
        NSMutableArray *emails = [[NSMutableArray alloc] init];
        for (Attendants *attendant in [self filterEntries:[[BNoteFilterFactory instance] create:AttendantType] for:allNotes]) {
            for (Attendant *recipient in [attendant children]) {
                if ([recipient email]) {
                    [emails addObject:[recipient email]];
                }
            }
        }
        
        [self setToRecipients:emails];
        
        int i = 0;
        for (KeyPoint *keyPoint in [self filterEntries:[[BNoteFilterFactory instance] create:KeyPointType] for:allNotes]) {
            if ([keyPoint photo]) {
                Photo *photo = [keyPoint photo];
                NSData *data;
                if ([[photo sketchPaths] count]) {
                    data = [photo sketch];
                } else {
                    data = [photo original];
                }
                
                NSString *name = [BNoteStringUtils append:@"KeyPoint-Image-", [NSString stringWithFormat:@"%d", i++], @"jpeg", nil];
                [self addAttachmentData:data mimeType:@"image/jpeg" fileName:name];
            }
        }
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
                                                        message:nil
                                                       delegate:nil
                                              cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

- (NSArray *)filterEntries:(id <BNoteFilter>)filter for:(NSArray *)allNotes
{
    NSMutableArray *filtered = [[NSMutableArray alloc] init];
    
    for (Note *note in allNotes) {
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
