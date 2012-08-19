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
@property (strong, nonatomic) NSMutableDictionary *entrySummaryHeaderImageViews;
@property (assign, nonatomic) BOOL keyboardVisible;

- (id)initSingleton;

@end

@implementation BNoteSessionData
@synthesize imageIconViews = _imageIconViews;
@synthesize keyboardVisible = _keyboardVisible;
@synthesize popup = _popup;
@synthesize actionSheet = _actionSheet;
@synthesize actionSheetDelegate = _actionSheetDelegate;
@synthesize entrySummaryHeaderImageViews = _entrySummaryHeaderImageViews;
@synthesize selectedTopic = _selectedTopic;
@synthesize selectedTopicGroup = _selectedTopicGroup;
@synthesize editingNote = _editingNote;
@synthesize mainViewController = _mainViewController;

- (id)initSingleton
{
    self = [super init];

    [self setImageIconViews:[[NSMutableDictionary alloc] init]];
    [self setEntrySummaryHeaderImageViews:[[NSMutableDictionary alloc] init]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideBNoteSessionData:)
                                                 name:UIKeyboardDidHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowBNoteSessionData:)
                                                 name:UIKeyboardDidShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewMode:)
                                                 name:kReviewingNote object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editingNote:)
                                                 name:kEditingNote object:nil];

    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardDidHideBNoteSessionData:(id)sender
{
    [self setKeyboardVisible:NO];
}

- (void)keyboardDidShowBNoteSessionData:(id)sender
{
    [self setKeyboardVisible:YES];
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

- (void)reviewMode:(NSNotification *)notification
{
    self.editingNote = NO;
}

- (void)editingNote:(NSNotification *)notification
{
    self.editingNote = YES;
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
