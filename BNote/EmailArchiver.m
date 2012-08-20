//
//  EmailArchiver.m
//  BeNote
//
//  Created by kristin young on 8/15/12.
//
//

#import "EmailArchiver.h"
#import "BNoteMarshallingManager.h"

@implementation EmailArchiver

- (NSString *)displayName
{
    return NSLocalizedString(@"Email Archiver", @"Email Archiver display text");
}

- (NSString *)helpText
{
    return NSLocalizedString(@"Email Archiver Help Text", @"Email Archiver help text");
}

- (BNoteExportFileWrapper *)archiveData:(id)data
{
    return [[BNoteMarshallingManager instance] marshall:data];
}

- (BNoteExportFileWrapper *)archiveAll
{
    return [[BNoteMarshallingManager instance] marshall:nil];
}

@end
