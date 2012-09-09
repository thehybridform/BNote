//
//  QuestionCloner.m
//  BeNote
//
//  Created by Young Kristin on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionCloner.h"
#import "BNoteFactory.h"

@implementation QuestionCloner

- (Question *)clone:(Question *)question into:(Note *)note
{
    Question *copy = [BNoteFactory createQuestion:note];
    [copy setText:[question text]];
    [copy setAnswer:[question answer]];
    
    return copy;
}

@end
