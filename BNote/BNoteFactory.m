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

NSString *const ACTION_ITEM_ACTIVE = @"action_item_active_icon.png";
NSString *const ACTION_ITEM_INACTIVE = @"action_item_icon.png";
NSString *const ATTENDIES_ACTIVE = @"attendies_active_icon.png";
NSString *const ATTENDIES_INACTIVE = @"attendies_icon.png";
NSString *const DECISION_ACTIVE = @"decision_active_icon.png";
NSString *const DECISION_INACTIVE = @"decision_icon.png";
NSString *const KEY_POINT_ACTIVE = @"key_point_active_icon.png";
NSString *const KEY_POINT_INACTIVE = @"key_point_icon.png";
NSString *const QUESTION_ACTIVE = @"question_active_icon.png";
NSString *const QUESTION_INACTIVE = @"question_icon.png";

@implementation BNoteFactory

+ (Topic *)createTopic:(NSString *)name
{
    Topic *topic = [[BNoteWriter instance] insertNewObjectForEntityForName:@"Topic"];

    [topic setCreated:[NSDate timeIntervalSinceReferenceDate]];
    [topic setLastUpdated:[topic created]];
    [topic setTitle:name];
    [topic setColor:0xFFFFFF];
    
    [[BNoteWriter instance] update];
    
    return topic;
}

+ (Note *)createNote:(Topic *)topic
{
    Note *note = [[BNoteWriter instance] insertNewObjectForEntityForName:@"Note"];
    [note setCreated:[NSDate timeIntervalSinceReferenceDate]];
    [note setLastUpdated:[note created]];
    [note setTopic:topic];
        
    [[BNoteWriter instance] update];

    return note;
}

+ (Question *)createQuestion:(Note *)note
{
    Question *entry = (Question *)[BNoteFactory createEntry:@"Question" forNote:note];
    
    [[BNoteWriter instance] update];

    return entry;
}

+ (ActionItem *)createActionItem:(Note *)note
{
    ActionItem *entry = (ActionItem *)[BNoteFactory createEntry:@"ActionItem" forNote:note];
    
    [[BNoteWriter instance] update];
    
    return entry;
}

+ (KeyPoint *)createKeyPoint:(Note *)note
{
    KeyPoint *entry = (KeyPoint *)[BNoteFactory createEntry:@"KeyPoint" forNote:note];
    
    [[BNoteWriter instance] update];
    
    return entry;
}

+ (Decision *)createDecision:(Note *)note
{
    Decision *entry = (Decision *)[BNoteFactory createEntry:@"Decision" forNote:note];
    
    [[BNoteWriter instance] update];
    
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

+(UIView *)createHighlightSliver:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
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
            icon = ACTION_ITEM_ACTIVE;
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
        default:
            break;
    }
    
    if (icon) {
        UIImage *image = [UIImage imageNamed:icon];
        UIImageView *view = [[UIImageView alloc] initWithImage:image];
        [view setFrame:CGRectMake(0, 0, 25, 25)];
        
        return view;
    }
    
    return nil;
}

+ (UIImageView *)createIcon:(Entry *)entry active:(BOOL)active
{
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
    } else if ([entry isKindOfClass:[Attendant class]]) {
        return AttentiesIconActive;
    } else if ([entry isKindOfClass:[Decision class]]) {
        return DecisionIconActive;
    } else if ([entry isKindOfClass:[KeyPoint class]]) {
        return KeyPointIconActive;
    } else if ([entry isKindOfClass:[Question class]]) {
        return QuestionIconActive;
    }

    return Unknown;
}

+ (BNoteIconType)inactiveType:(Entry *)entry
{
    if ([entry isKindOfClass:[ActionItem class]]) {
        return ActionItemIcon;
    } else if ([entry isKindOfClass:[Attendant class]]) {
        return AttentiesIcon;
    } else if ([entry isKindOfClass:[Decision class]]) {
        return DecisionIcon;
    } else if ([entry isKindOfClass:[KeyPoint class]]) {
        return KeyPointIcon;
    } else if ([entry isKindOfClass:[Question class]]) {
        return QuestionIcon;
    }
    
    return Unknown;
}


@end
