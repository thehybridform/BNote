//
//  QuestionEntryCell.m
//  BeNote
//
//  Created by Young Kristin on 6/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QuestionEntryCell.h"

@implementation QuestionEntryCell

- (void)updateDetail
{
    Question *question = (Question *) [self entry];
    [[self detail] setText:[question answer]];
}

@end
