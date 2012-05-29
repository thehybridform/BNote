//
//  BNoteSessionData.m
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteSessionData.h"

@interface BNoteSessionData()
@property (assign, nonatomic) BNotePhase phase;
- (id)initSingleton;

@end

@implementation BNoteSessionData
@synthesize phase = _phase;
@synthesize currentNoteViewController = _currentNoteViewController;
@synthesize currentEntryReviewViewController = _currentEntryReviewViewController;
@synthesize currentTopic = _currentTopic;

- (void)setPhase:(BNotePhase)phase
{
    _phase = phase;
}

- (BOOL)canEditEntry
{
    return YES;
}

- (id)initSingleton
{
    self = [super init];
    
    return self;
}

+ (BNoteSessionData *)instance
{
    static BNoteSessionData *_default = nil;
    
    if (_default != nil) {
        return _default;
    }
    
    static dispatch_once_t safer;
    dispatch_once(&safer, ^{
        _default = [[BNoteSessionData alloc] initSingleton];
    });
    
    return _default;
}

@end
