//
//  BNoteSessionData.m
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteSessionData.h"

@interface BNoteSessionData()
@property (strong, nonatomic) NSMutableDictionary *imageIconViews;
@property (assign, nonatomic) BOOL keyboardVisible;

- (id)initSingleton;

@end

@implementation BNoteSessionData
@synthesize phase = _phase;
@synthesize settings = _settings;
@synthesize scratchTextView = _scratchTextView;
@synthesize imageIconViews = _imageIconViews;
@synthesize keyboardVisible = _keyboardVisible;

- (BOOL)canEditEntry
{
    return [self phase] == Editing;
}

- (id)initSingleton
{
    self = [super init];
    
    [self setScratchTextView:[[UITextView alloc] init]];
    [self setImageIconViews:[[NSMutableDictionary alloc] init]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideBNoteSessionData:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowBNoteSessionData:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    
    return self;
}

- (void)keyboardDidHideBNoteSessionData:(id)sender
{
    [self setKeyboardVisible:NO];
}

- (void)keyboardDidShowBNoteSessionData:(id)sender
{
    [self setKeyboardVisible:YES];
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
