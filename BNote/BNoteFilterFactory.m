//
//  BNoteFilterFactory.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteFilterFactory.h"
#import "IdentityFillter.h"
#import "KeyPointFilter.h"
#import "ActionItemFilter.h"
#import "ActionItemCompleteFilter.h"
#import "ActionItemInCompleteFilter.h"
#import "QuestionFilter.h"
#import "QuestionAnsweredFilter.h"
#import "QuestionUnansweredFilter.h"
#import "DecisionFilter.h"
#import "AttendantFilter.h"


@implementation BNoteFilterFactory

+ (id<BNoteFilter>)create:(BNoteFilterType)type
{
    switch (type) {
        case KeyPointType:
            return [[KeyPointFilter alloc] init];
            break;
        case ActionItemType:
            return [[ActionItemFilter alloc] init];
            break;
        case ActionItemCompleteType:
            return [[ActionItemCompleteFilter alloc] init];
            break;
        case ActionItemsIncompleteType:
            return [[ActionItemInCompleteFilter alloc] init];
            break;
        case QuestionType:
            return [[QuestionFilter alloc] init];
            break;
        case QuestionAnsweredType:
            return [[QuestionAnsweredFilter alloc] init];
            break;
        case QuestionUnansweredType:
            return [[QuestionUnansweredFilter alloc] init];
            break;
        case DecistionType:
            return [[DecisionFilter alloc] init];
            break;
        case AttendantType:
            return [[AttendantFilter alloc] init];
            break;
        default:
            break;
    }
    
    return [[IdentityFillter alloc] init];
}
@end
