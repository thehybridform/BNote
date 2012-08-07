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
#import "KeyWordFilter.h"

@interface BNoteFilterFactory()
@property (strong, nonatomic) NSMutableDictionary *filters;

- (id)initSingleton;

@end

@implementation BNoteFilterFactory
@synthesize filters = _filters;

NSString *const questionFilter = @"Questions Filter";
NSString *const questionAnsweredFilter = @"Questions Answered Filter";
NSString *const questionUnansweredFilter = @"Questions Unanswered Filter";
NSString *const actionItemFilter = @"Action Items Filter";
NSString *const actionItemCompleteFilter = @"Action Items Complete Filter";
NSString *const actionItemIncompleteFilter = @"Action Items Incomplete Filter";
NSString *const decisionsFilter = @"Decisions Filter";
NSString *const keyPointsFilter = @"Key Points Filter";
NSString *const attendantsFilter = @"Attendants Filter";
NSString *const identityFilter = @"Identity Filter";


- (id)initSingleton
{
    self = [super init];
    
    if (self) {
        NSMutableDictionary *filters = [[NSMutableDictionary alloc] init];
        [self setFilters:filters];
    
        [filters setObject:[[KeyPointFilter alloc] init] forKey:keyPointsFilter];
        [filters setObject:[[ActionItemFilter alloc] init] forKey:actionItemFilter];
        [filters setObject:[[ActionItemCompleteFilter alloc] init] forKey:actionItemCompleteFilter];
        [filters setObject:[[ActionItemInCompleteFilter alloc] init] forKey:actionItemIncompleteFilter];
        [filters setObject:[[QuestionFilter alloc] init] forKey:questionFilter];
        [filters setObject:[[QuestionAnsweredFilter alloc] init] forKey:questionAnsweredFilter];
        [filters setObject:[[QuestionUnansweredFilter alloc] init] forKey:questionUnansweredFilter];
        [filters setObject:[[DecisionFilter alloc] init] forKey:decisionsFilter];
        [filters setObject:[[AttendantFilter alloc] init] forKey:attendantsFilter];
        [filters setObject:[[IdentityFillter alloc] init] forKey:identityFilter];
    }
    
    return self;
}

- (id<BNoteFilter>)create:(BNoteFilterType)filterType
{
    switch (filterType) {
        case KeyPointType:
            return [[self filters] objectForKey:keyPointsFilter];
            break;
        case ActionItemType:
            return [[self filters] objectForKey:actionItemFilter];
            break;
        case ActionItemCompleteType:
            return [[self filters] objectForKey:actionItemCompleteFilter];
            break;
        case ActionItemsIncompleteType:
            return [[self filters] objectForKey:actionItemIncompleteFilter];
            break;
        case QuestionType:
            return [[self filters] objectForKey:questionFilter];
            break;
        case QuestionAnsweredType:
            return [[self filters] objectForKey:questionAnsweredFilter];
            break;
        case QuestionUnansweredType:
            return [[self filters] objectForKey:questionUnansweredFilter];
            break;
        case DecistionType:
            return [[self filters] objectForKey:decisionsFilter];
            break;
        case AttendantType:
            return [[self filters] objectForKey:attendantsFilter];
            break;
        default:
            return [[self filters] objectForKey:identityFilter];
            break;
    }
}

+ (id<BNoteFilter>)createEntryTextFilter:(NSString *)searchText
{
    return [[KeyWordFilter alloc] initWithSearchString:searchText];
}

+ (BNoteFilterFactory *)instance
{
    static BNoteFilterFactory *_default = nil;
    
    if (_default != nil) {
        return _default;
    }
    
    static dispatch_once_t safer;
    dispatch_once(&safer, ^{
        _default = [[BNoteFilterFactory alloc] initSingleton];
    });
    
    return _default;
}

@end
