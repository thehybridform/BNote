//
//  QuestionUnansweredFilter.m
//  BNote
//
//  Created by Young Kristin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionUnansweredFilter.h"
#import "Question.h"

@implementation QuestionUnansweredFilter

- (BOOL)accept:(id)item
{
    if ([item isKindOfClass:[Question class]]) {
        Question *question = (Question *) item;
        return [question answer] != nil;
    }
    
    return NO;
}

@end
