//
//  ClonerFactory.m
//  BeNote
//
//  Created by Young Kristin on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ClonerFactory.h"
#import "ActionItem.h"
#import "Attendants.h"
#import "Decision.h"
#import "KeyPoint.h"
#import "Question.h"
#import "Photo.h"
#import "SketchPath.h"

#import "DecisionCloner.h"
#import "ActionItemCloner.h"
#import "QuestionCloner.h"
#import "KeyPointCloner.h"
#import "AttendantsCloner.h"

@implementation ClonerFactory

+ (id<Cloner>)clonerFor:(id)object
{
    if ([object isKindOfClass:[ActionItem class]]) {
        return [[ActionItemCloner alloc] init];
    } else if ([object isKindOfClass:[Attendants class]]) {
        return [[AttendantsCloner alloc] init];
    } else if ([object isKindOfClass:[Decision class]]) {
        return [[DecisionCloner alloc] init];
    } else if ([object isKindOfClass:[KeyPoint class]]) {
        return [[KeyPointCloner alloc] init];
    } else if ([object isKindOfClass:[Question class]]) {
        return [[QuestionCloner alloc] init];
    }

    return nil;
}

@end
