//
//  BNoteSessionData.m
//  BNote
//
//  Created by Young Kristin on 5/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteSessionData.h"

@interface BNoteSessionData()
@property (strong, nonatomic) NSMutableDictionary *entrySummaryHeaderImageViews;

- (id)initSingleton;

@end

@implementation BNoteSessionData
@synthesize popup = _popup;
@synthesize actionSheet = _actionSheet;
@synthesize actionSheetDelegate = _actionSheetDelegate;
@synthesize entrySummaryHeaderImageViews = _entrySummaryHeaderImageViews;
@synthesize selectedTopic = _selectedTopic;
@synthesize selectedTopicGroup = _selectedTopicGroup;
@synthesize mainViewController = _mainViewController;

- (id)initSingleton
{
    self = [super init];

    [self setEntrySummaryHeaderImageViews:[[NSMutableDictionary alloc] init]];

    return self;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([self actionSheetDelegate]) {
        [[self actionSheetDelegate] actionSheet:actionSheet clickedButtonAtIndex:buttonIndex];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self setActionSheet:nil];
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

+ (BOOL)booleanForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}

+ (void)setBoolean:(BOOL)flag forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:flag forKey:key];
    [defaults synchronize];
}

+ (NSString *)stringForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}

+ (void)setString:(NSString *)string forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:string forKey:key];
    [defaults synchronize];
}

@end
