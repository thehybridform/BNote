//
//  QuestionAnsweredFilter.m
//  BNote
//
//  Created by Young Kristin on 5/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionAnsweredFilter.h"

@implementation QuestionAnsweredFilter

- (BOOL)accept:(id)item
{
    if ([item isKindOfClass:[Question class]]) {
        Question *question = (Question *) item;
        return ![BNoteStringUtils nilOrEmpty:[question answer]];
    }
    
    return NO;
}

@end
