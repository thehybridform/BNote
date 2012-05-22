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

    for (int i = 0; i < 4; i++) {
        [BNoteFactory createQuestion:note];
    }
    

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
    [entry setText:@"Touch to Update"];
    [entry setNote:note];
    
    return entry;
}

+(UIView *)createHighlightSliver:(UIColor *)color
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [view setBackgroundColor:color];
    

    return view;
}

@end
