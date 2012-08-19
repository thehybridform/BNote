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

- (BOOL)archiveTopicGroup:(TopicGroup *)topicGroup
{
    [[BNoteMarshallingManager instance] marshall:topicGroup];
    
    return YES;
}

- (BOOL)archiveTopic:(Topic *)topic
{
    return YES;
}

- (BOOL)archiveNote:(Note *)note
{
    return YES;
}

- (BOOL)archiveAll
{
    return YES;
}

@end
