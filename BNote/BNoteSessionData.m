//
//  BNoteSessionData.m
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteSessionData.h"

@interface BNoteSessionData()

- (id)initSingleton;

@end

@implementation BNoteSessionData
@synthesize phase = _phase;
@synthesize settings = _settings;
@synthesize scratchTextView = _scratchTextView;

- (BOOL)canEditEntry
{
    return [self phase] == Editing;
}

- (id)initSingleton
{
    self = [super init];
    
    [self setScratchTextView:[[UITextView alloc] init]];
    
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
