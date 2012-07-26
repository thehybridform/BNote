//
//  BNoteDefaultData.m
//  BeNote
//
//  Created by Young Kristin on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteDefaultData.h"
#import "Topic.h"
#import "TopicGroup.h"
#import "BNoteSessionData.h"
#import "BNoteFactory.h"
#import "BNoteReader.h"
#import "KeyPoint.h"

@implementation BNoteDefaultData

+ (void)setup
{
    NSString *info1 = [self readString:@"info-1.txt"];
    NSString *info2 = [self readString:@"info-2.txt"];
    NSString *info3 = [self readString:@"info-3.txt"];
    NSString *info4 = [self readString:@"info-4.txt"];
    NSString *info5 = [self readString:@"info-5.txt"];
    NSString *info6 = [self readString:@"info-6.txt"];
    
    NSString *groupName = @"All";
    TopicGroup *group = [[BNoteReader instance] getTopicGroup:groupName];
    
    if (!group) {
        group = [BNoteFactory createTopicGroup:groupName];
    }

    Topic *topic = [BNoteFactory createTopic:@"Welcome to BeNote!" forGroup:group];
    [topic setColor:FilterColor];
    Note *note = [BNoteFactory createNote:topic];
    [note setSubject:@"Tap Me"];
    
    [self addKeyPointForNote:note withText:info1];
    [self addKeyPointForNote:note withText:info2];
    [self addKeyPointForNote:note withText:info3];
    [self addKeyPointForNote:note withText:info4];
    [self addKeyPointForNote:note withText:info5];
    [self addKeyPointForNote:note withText:info6];
    
    topic = [BNoteFactory createTopic:@"Usage Practices" forGroup:group];
//    note = 
}

+ (void)addKeyPointForNote:(Note *)note withText:(NSString *)text
{
    KeyPoint *keyPoint = [BNoteFactory createKeyPoint:note];
    [keyPoint setText:text];
}

+ (NSString *)readString:(NSString *)filename
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    return [NSString stringWithContentsOfFile:path
                                     encoding:NSUTF8StringEncoding
                                        error:NULL];
}

@end
