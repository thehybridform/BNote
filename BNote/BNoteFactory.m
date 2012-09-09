//
//  BNoteFactory.m
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteFactory.h"
#import "BNoteWriter.h"
#import "BNoteReader.h"
#import "AttendantsContentViewController.h"
#import "QuestionContentViewController.h"
#import "ActionItemContentViewController.h"
#import "KeyPointContentViewController.h"
#import "DecisionContentViewController.h"
#import "BNoteSessionData.h"
#import "Cloner.h"
#import "ClonerFactory.h"
#import "TableCellHeaderViewController.h"

NSString *const kActionItemActive = @"action_item_active_icon.png";
NSString *const ACTION_ITEM_INACTIVE = @"action_item_icon.png";
NSString *const ATTENDIES_ACTIVE = @"attendees_active_icon.png";
NSString *const ATTENDIES_INACTIVE = @"attendees_icon.png";
NSString *const DECISION_ACTIVE = @"decision_active_icon.png";
NSString *const DECISION_INACTIVE = @"decision_icon.png";
NSString *const KEY_POINT_MASK = @"key_point_mask.png";
NSString *const KEY_POINT_ACTIVE = @"key_point_active_icon.png";
NSString *const KEY_POINT_INACTIVE = @"key_point_icon.png";
NSString *const QUESTION_ACTIVE = @"question_active_icon.png";
NSString *const QUESTION_INACTIVE = @"question_icon.png";
NSString *const ATTENDANT = @"bnote-contact.png";
NSString *const PAPER = @"Squared_paper.jpg";

NSString *const questionAnsweredEntryHeader = @"Questions Answered";
NSString *const questionUnansweredEntryHeader = @"Questions Unanswered";
NSString *const actionItemsCompletedEntryHeader = @"Action Items Completed";
NSString *const actionItemsIncompleteEntryHeader = @"Action Items Incomplete";
NSString *const decisionsEntryHeader = @"Decisions";
NSString *const keyPointsEntryHeader = @"Key Points";

@implementation BNoteFactory

+ (TopicGroup *)createTopicGroup:(NSString *)name
{
    TopicGroup *group = [[BNoteWriter instance] insertNewObjectForEntityForName:@"TopicGroup"];
    [group setCreated:[NSDate timeIntervalSinceReferenceDate]];
    [group setLastUpdated:[group created]];
    [group setName:name];
    group.id = [BNoteStringUtils guuid];

    return group;
}

+ (Topic *)createTopic:(NSString *)name forGroup:(TopicGroup *)group
{
    Topic *topic = [[BNoteWriter instance] insertNewObjectForEntityForName:@"Topic"];

    [topic setCreated:[NSDate timeIntervalSinceReferenceDate]];
    [topic setLastUpdated:[topic created]];
    [topic setTitle:name];
    [topic setColor:0xFFFFFF];
    topic.id = [BNoteStringUtils guuid];

    [group addTopicsObject:topic];
    
    if (![[group name] isEqualToString:kAllTopicGroupName]) {
        TopicGroup *all = [[BNoteReader instance] getTopicGroup:kAllTopicGroupName];
        [all addTopicsObject:topic];
    }

    return topic;
}

+ (Topic *)createTopic:(NSString *)name forGroup:(TopicGroup *)group withSearch:(NSString *)text
{
    [[BNoteWriter instance] update];

    Topic *topic = [BNoteFactory createTopic:name forGroup:group];
    
    for (Note *note in [[BNoteReader instance] findNotesWithText:text]) {
        [topic addAssociatedNotesObject:note];
    }
    
    return topic;
}


+ (Note *)copyNote:(Note *)note toTopic:(Topic *)topic
{
    Note *copy = [BNoteFactory createNote:topic];
    [copy setSubject:[BNoteStringUtils append:@"Copy of ", [note subject], nil]];
    
    for (Entry *entry in [note entries]) {
        [[ClonerFactory clonerFor:entry] clone:entry into:copy];
    }
    
    return copy;
}

+ (Note *)createNote
{
    Note *note = [[BNoteWriter instance] insertNewObjectForEntityForName:@"Note"];
    [note setCreated:[NSDate timeIntervalSinceReferenceDate]];
    [note setLastUpdated:[note created]];
    note.id = [BNoteStringUtils guuid];
    
    return note;
}

+ (Note *)createNote:(Topic *)topic
{
    Note *note = [[BNoteWriter instance] insertNewObjectForEntityForName:@"Note"];
    [note setCreated:[NSDate timeIntervalSinceReferenceDate]];
    [note setLastUpdated:[note created]];
    [note setColor:[topic color]];
    [note setTopic:topic];
    note.id = [BNoteStringUtils guuid];
    
    return note;
}

+ (Attendant *)createAttendant
{
    Attendant *attendant = [[BNoteWriter instance] insertNewObjectForEntityForName:@"Attendees"];

    return attendant;
}

+ (Attendant *)createAttendant:(Attendants *)attendants
{
    Attendant *attendant = [[BNoteWriter instance] insertNewObjectForEntityForName:@"Attendees"];
    [attendant setParent:attendants];
    
    return attendant;
}

+ (Attendants *)createAttendants:(Note *)note
{
    Attendants *entry = (Attendants *)[BNoteFactory createEntry:@"Attendants" forNote:note];

    return entry;
}

+ (Question *)createQuestion:(Note *)note
{
    Question *entry = (Question *)[BNoteFactory createEntry:@"Question" forNote:note];
    
    return entry;
}

+ (ActionItem *)createActionItem:(Note *)note
{
    ActionItem *entry = (ActionItem *)[BNoteFactory createEntry:@"ActionItem" forNote:note];
    
    return entry;
}

+ (ActionItem *)copyActionItem:(ActionItem *)actionItem
{
    ActionItem *copy = [BNoteFactory createActionItem:[actionItem note]];
    [copy setText:[actionItem text]];
    
    return copy;
}

+ (KeyPoint *)createKeyPoint:(Note *)note
{
    KeyPoint *entry = (KeyPoint *)[BNoteFactory createEntry:@"KeyPoint" forNote:note];
    
    return entry;
}

+ (Decision *)createDecision:(Note *)note
{
    Decision *entry = (Decision *)[BNoteFactory createEntry:@"Decision" forNote:note];
    
    return entry;
}

+ (Entry *)createEntry:(NSString *)name forNote:(Note *)note
{
    Entry *entry = [[BNoteWriter instance] insertNewObjectForEntityForName:name];
    [entry setCreated:[NSDate timeIntervalSinceReferenceDate]];
    [entry setLastUpdated:[entry created]];
    [entry setNote:note];
    
    return entry;
}

+ (Photo *)createPhoto
{
    Photo *photo = [[BNoteWriter instance] insertNewObjectForEntityForName:@"Photo"];
    [photo setCreated:[NSDate timeIntervalSinceReferenceDate]];
    
    return photo;
}

+ (Photo *)createPhoto:(KeyPoint *)keyPoint
{
    Photo *photo = [[BNoteWriter instance] insertNewObjectForEntityForName:@"Photo"];
    [photo setCreated:[NSDate timeIntervalSinceReferenceDate]];
    [photo setKeyPoint:keyPoint];
    
    return photo;
}

+ (SketchPath *)createSketchPath:(Photo *)photo
{
    SketchPath *sketch = [[BNoteWriter instance] insertNewObjectForEntityForName:@"SketchPath"];
    [sketch setPhoto:photo];

    return sketch;
}

+ (void)addUIBezierPath:(UIBezierPath *)path withColor:(UIColor *)color toPhoto:(Photo *)photo
{
    SketchPath *sketch = [BNoteFactory createSketchPath:photo];
    [sketch setPathColor:color];
    [sketch setBezierPath:path];
}

+ (KeyWord *)createKeyWord:(NSString *)word
{
    if ([BNoteStringUtils nilOrEmpty:word]) {
        return nil;
    }
    
    KeyWord *keyWord = [[BNoteReader instance] keyWordFor:word];
    if (!keyWord) {
        keyWord = [[BNoteWriter instance] insertNewObjectForEntityForName:@"KeyWord"];
        [keyWord setWord:word];
    }
    
    return keyWord;
}

+(UIView *)createHighlightSliver:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 44)];
    [view setBackgroundColor:color];

    return view;
}

+(UIView *)createHighlight:(UIColor *)color
{
    UIView *view = [[UIView alloc] init];
    [view setBackgroundColor:color];
    
    return view;
}

+(UIImageView *)createIcon:(BNoteIconType)type
{
    NSString *icon;
    
    switch (type) {
        case ActionItemIcon:
            icon = ACTION_ITEM_INACTIVE;
            break;
        case ActionItemIconActive:
            icon = kActionItemActive;
            break;
        case AttentiesIcon:
            icon = ATTENDIES_INACTIVE;
            break;
        case AttentiesIconActive:
            icon = ATTENDIES_ACTIVE;
            break;
        case DecisionIcon:
            icon = DECISION_INACTIVE;
            break;
        case DecisionIconActive:
            icon = DECISION_ACTIVE;
            break;
        case KeyPointIcon:
            icon = KEY_POINT_INACTIVE;
            break;
        case KeyPointIconActive:
            icon = KEY_POINT_ACTIVE;
            break;
        case QuestionIcon:
            icon = QUESTION_INACTIVE;
            break;
        case QuestionIconActive:
            icon = QUESTION_ACTIVE;
            break;
        case AttendantIcon:
            icon = ATTENDANT;
            break; 
        case KeyPointIconMask:
            icon = KEY_POINT_MASK;
            break;
        default:
            break;
    }

    if (icon) {
        /*
        UIImageView *view = [[[BNoteSessionData instance] imageIconViews] objectForKey:icon];
        if (!view) {
            UIImage *image = [UIImage imageNamed:icon];
            view = [[UIImageView alloc] initWithImage:image];
            [view setFrame:CGRectMake(0, 0, 25, 25)];
            
            [[[BNoteSessionData instance] imageIconViews] setObject:view forKey:icon];
        }
        */
        
        UIImage *image = [UIImage imageNamed:icon];
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        [view setFrame:CGRectMake(0, 0, 25, 25)];
        
        return view;
    }
    
    return nil;
}

+ (UIImageView *)createIcon:(Entry *)entry active:(BOOL)active
{
    if (!entry) {
        return nil;
    }
    
    BNoteIconType type;
    if (active) {
        type = [BNoteFactory activeType:entry];
    } else {
        type = [BNoteFactory inactiveType:entry];
    }
    return [BNoteFactory createIcon:type];
}

+ (BNoteIconType)activeType:(Entry *)entry
{
    if ([entry isKindOfClass:[ActionItem class]]) {
        return ActionItemIconActive;
    } else if ([entry isKindOfClass:[Attendants class]]) {
        return AttentiesIconActive;
    } else if ([entry isKindOfClass:[Decision class]]) {
        return DecisionIconActive;
    } else if ([entry isKindOfClass:[KeyPoint class]]) {
        return KeyPointIconActive;
    } else if ([entry isKindOfClass:[Question class]]) {
        return QuestionIconActive;
    }

    return -1;
}

+ (BNoteIconType)inactiveType:(Entry *)entry
{
    if ([entry isKindOfClass:[ActionItem class]]) {
        return ActionItemIcon;
    } else if ([entry isKindOfClass:[Attendants class]]) {
        return AttentiesIcon;
    } else if ([entry isKindOfClass:[Decision class]]) {
        return DecisionIcon;
    } else if ([entry isKindOfClass:[KeyPoint class]]) {
        return KeyPointIcon;
    } else if ([entry isKindOfClass:[Question class]]) {
        return QuestionIcon;
    }
    
    return -1;
}

+ (EntryContentViewController *)createEntryContent:(Entry *)entry
{
    if ([entry isKindOfClass:[Attendants class]]) {
        return [[AttendantsContentViewController alloc] initWithEntry:entry];
    } else if ([entry isKindOfClass:[KeyPoint class]]) {
        return [[KeyPointContentViewController alloc] initWithEntry:entry];
    } else if ([entry isKindOfClass:[ActionItem class]]) {
        return [[ActionItemContentViewController alloc] initWithEntry:entry];
    } else if ([entry isKindOfClass:[Question class]]) {
        return [[QuestionContentViewController alloc] initWithEntry:entry];
    }
    return [[DecisionContentViewController alloc] initWithEntry:entry];
}

+ (NoteSummaryViewController *)createSummaryEntry:(Note *)note
{
    return [[NoteSummaryViewController alloc] initWithNote:note];
}

+ (UIImage *)paper
{
    return [UIImage imageNamed:PAPER];
}

+ (UIView *)createEntrySummaryHeaderView:(EntrySummaryHeaderType)type
{
    NSString *text;
    switch (type) {
        case QuestionAnsweredHeader:
            text = NSLocalizedString(@"Questions - Answered", @"The questions answered note entry header.") ;
            break;
            
        case QuestionUnansweredHeader:
            text = NSLocalizedString(@"Questions - Unanswered", @"The questions unanswered note entry header.") ;
            break;
            
        case DecisionHeader:
            text = NSLocalizedString(@"Decisions", @"The decisions note entry header.") ;
            break;
            
        case KeyPointHeader:
            text = NSLocalizedString(@"Key Points", @"The key points note entry header.") ;
            break;
            
        case ActionItemCompleteHeader:
            text = NSLocalizedString(@"Action Items - Completed", @"The action items complete header.") ;
            break;
            
        case ActionItemIncompleteHeader:
            text = NSLocalizedString(@"Action Items - Incomplete", @"The action items incomplete header.") ;
            break;
            
        default:
            break;
    }

    TableCellHeaderViewController *controller = 
        [[[BNoteSessionData instance] entrySummaryHeaderImageViews] objectForKey:text];
    
    if (!controller) {
        controller = [[TableCellHeaderViewController alloc] initWithTitle:text];
        [[[BNoteSessionData instance] entrySummaryHeaderImageViews] setObject:controller forKey:text];
    }

    return [controller view];
}

+ (UIButton *)buttonForImage:(NSString *)name
{
    UIButton *button = [[UIButton alloc] init];
    
    UIImage *image = [UIImage imageNamed:name];
    [button setImage:image forState:UIControlStateNormal];
    
    return button;
}


@end
