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
#import "BNoteWriter.h"
#import "KeyPoint.h"
#import "Decision.h"
#import "Question.h"
#import "ActionItem.h"
#import "Attendant.h"
#import "Attendants.h"

@implementation BNoteDefaultData

static NSString *WelcomeTitle = @"Welcome to BeNote!";
static NSString *UsageTitle = @"Using BeNote!";
static NSString *TapMe = @"Tap Me";
static NSString *KeyPoints = @"Key Points";
static NSString *Questions = @"Questions";
static NSString *Decisions = @"Decisions";
static NSString *ActionItems = @"Action Items";
static NSString *Attendees = @"Attendees";
static NSString *Overview = @"Overview";

+ (void)setup
{
    NSString *groupName = kAllTopicGroupName;
    TopicGroup *group = [[BNoteReader instance] getTopicGroup:groupName];
    
    if (!group) {
        group = [BNoteFactory createTopicGroup:groupName];
    }
    
    [self handleWelcome:group];
    [self handleUsage:group];
}

+ (void)handleWelcome:(TopicGroup *)group
{
    Topic *topic = [BNoteFactory createTopic:WelcomeTitle forGroup:group];
    [topic setColor:FilterColor];
    
    Note *note = [BNoteFactory createNote:topic];
    [note setSubject:TapMe];
    
    [self addKeyPointForNote:note withText:[self readString:@"info-1.txt"]];
    [self addKeyPointForNote:note withText:[self readString:@"info-2.txt"]];
    [self addKeyPointForNote:note withText:[self readString:@"info-3.txt"]];
    [self addKeyPointForNote:note withText:[self readString:@"info-4.txt"]];
    [self addKeyPointForNote:note withText:[self readString:@"info-5.txt"]];
    [self addKeyPointForNote:note withText:[self readString:@"info-6.txt"]];    
}

+ (void)handleUsage:(TopicGroup *)group
{
    Topic *topic = [BNoteFactory createTopic:UsageTitle forGroup:group];
    [topic setColor:FilterColor];
    
    [self handleOverview:topic];
    [self handleKeyPoints:topic];
    [self handleQuestions:topic];
    [self handleDecisions:topic];
    [self handleActionItems:topic];
    [self handleAttendees:topic];
}

+ (void)handleOverview:(Topic *)topic
{
    Note *note = [BNoteFactory createNote:topic];
    [note setSubject:Overview];
    
    [self addKeyPointForNote:note withText:[self readString:@"overview-1.txt"]];
    [self addKeyPointForNote:note withText:[self readString:@"overview-2.txt"]];
    [self addKeyPointForNote:note withText:[self readString:@"overview-3.txt"]];
}

+ (void)handleActionItems:(Topic *)topic
{
    Note *note = [BNoteFactory createNote:topic];
    [note setSubject:ActionItems];
    
    [self addActionItemForNote:note withText:[self readString:@"action-item-1.txt"]];
    [self addActionItemForNote:note withText:[self readString:@"action_item-2.txt"]];
    [self addActionItemForNote:note withText:[self readString:@"action-item-3.txt"]];
    [self addActionItemForNote:note withText:[self readString:@"action-item-4.txt"]];
}

+ (void)handleAttendees:(Topic *)topic
{
    Note *note = [BNoteFactory createNote:topic];
    [note setSubject:Attendees];
    
    [self addAttendeeForNote:note];
    [self addKeyPointForNote:note withText:[self readString:@"attendees-1.txt"]];
    [self addKeyPointForNote:note withText:[self readString:@"attendees-2.txt"]];
    [self addKeyPointForNote:note withText:[self readString:@"attendees-3.txt"]];
}

+ (void)addAttendeeForNote:(Note *)note
{
    Attendants *attendees = [BNoteFactory createAttendants:note];
    Attendant *attendant = [BNoteFactory createAttendant:attendees];
    [attendant setFirstName:@"John"];
    [attendant setLastName:@"Smith"];
    [attendant setEmail:@"John.Smith@uobia.com"];
    
    [[BNoteWriter instance] update];
}

+ (void)handleDecisions:(Topic *)topic
{
    Note *note = [BNoteFactory createNote:topic];
    [note setSubject:Decisions];
    
    [self addDecisionForNote:note withText:[self readString:@"Decision.txt"]];
}

+ (void)handleKeyPoints:(Topic *)topic
{
    Note *note = [BNoteFactory createNote:topic];
    [note setSubject:KeyPoints];
    
    [self addKeyPointForNote:note withText:[self readString:@"key-point.txt"]];
    [self addKeyPointForNote:note withText:[self readString:@"keypoint-1.txt"]];
    [self addKeyPointForNote:note withText:[self readString:@"keypoint-2.txt"]];
    [self addKeyPointForNote:note withText:[self readString:@"keypoint-3.txt"]];
}

+ (void)handleQuestions:(Topic *)topic
{
    Note *note = [BNoteFactory createNote:topic];
    [note setSubject:Questions];
    
    [self addQuestionForNote:note];
}

+ (void)addQuestionForNote:(Note *)note
{
    Question *question = [BNoteFactory createQuestion:note];
    [question setText:[self readString:@"question-1.txt"]];
    
    question = [BNoteFactory createQuestion:note];
    [question setText:[self readString:@"question-2.txt"]];
    [question setAnswer:[self readString:@"answer.txt"]];
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

+ (NSString *)readString:(NSString *)filename
{
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    return [NSString stringWithContentsOfFile:path
                                     encoding:NSUTF8StringEncoding
                                        error:NULL];
}

@end
