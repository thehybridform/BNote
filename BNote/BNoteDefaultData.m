//
//  BNoteDefaultData.m
//  BeNote
//
//  Created by Young Kristin on 7/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteDefaultData.h"
#import "Topic.h"
#import "BNoteFactory.h"
#import "BNoteReader.h"
#import "BNoteWriter.h"

@implementation BNoteDefaultData

+ (void)setup
{
    NSString *groupName = kAllTopicGroupName;
    TopicGroup *group = [[BNoteReader instance] getTopicGroup:groupName];
    
    if (!group) {
        group = [BNoteFactory createTopicGroup:groupName];
    }
    
    [self handleWelcome:group];
    
    [[BNoteWriter instance] update];
}

+ (void)handleWelcome:(TopicGroup *)group
{
    Topic *topic = [BNoteFactory createTopic:NSLocalizedString(@"Welcome to BeNote Title", nil) forGroup:group];
    [topic setColor:kFilterColor];
    
    Note *note = [BNoteFactory createNote:topic];
    [note setSubject:NSLocalizedString(@"Tap Me", nil)];
    
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Welcome 1", nil)];
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Welcome 2", nil)];
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Welcome 3", nil)];
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Welcome 4", nil)];
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Welcome 5", nil)];
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Welcome 6", nil)];
    
    
    note = [BNoteFactory createNote:topic];
    [note setSubject:NSLocalizedString(@"Overview Note Title", nil)];
    
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Topics Description", nil)];
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Notes Description", nil)];
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Sharing Description", nil)];
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Search Description", nil)];

    note = [BNoteFactory createNote:topic];
    [note setSubject:NSLocalizedString(@"Note Taking Title", nil)];
    
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Participants Description", nil)];
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Key Points Description", nil)];
    [self addActionItemForNote:note withText:NSLocalizedString(@"Action Items Description", nil)];
    [self addQuestionForNote:note withText:NSLocalizedString(@"Questions Description", nil)];
    [self addDecisionForNote:note withText:NSLocalizedString(@"Decisions Description", nil)];
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Reviewing Your Notes Description", nil)];
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Quick Words Description", nil)];
    [self addKeyPointForNote:note withText:NSLocalizedString(@"Multiple Note Topics Description", nil)];
}

+ (void)addQuestionForNote:(Note *)note withText:(NSString *)text
{
    Question *question = [BNoteFactory createQuestion:note];
    [question setText:text];
}

+ (void)addActionItemForNote:(Note *)note withText:(NSString *)text
{
    ActionItem *actionItem = [BNoteFactory createActionItem:note];
    [actionItem setText:text];
}

+ (void)addDecisionForNote:(Note *)note withText:(NSString *)text
{
    Decision *decision = [BNoteFactory createDecision:note];
    [decision setText:text];
}

+ (void)addKeyPointForNote:(Note *)note withText:(NSString *)text
{
    KeyPoint *keyPoint = [BNoteFactory createKeyPoint:note];
    [keyPoint setText:text];
}

@end
