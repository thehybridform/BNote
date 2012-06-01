//
//  QuestionUnansweredFilter.m
//  BNote
//
//  Created by Young Kristin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionUnansweredFilter.h"
#import "Question.h"
#import "BNoteStringUtils.h"

@implementation QuestionUnansweredFilter

- (BOOL)accept:(id)item
{
    if ([item isKindOfClass:[Question class]]) {
        Question *question = (Question *) item;
        return [BNoteStringUtils nilOrEmpty:[question answer]];
    }
    
    return NO;
}

@end
