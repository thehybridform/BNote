//
//  BNotePlainTextRenderer.m
//  BNote
//
//  Created by Young Kristin on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNotePlainTextRenderer.h"
#import "QuestionPlainRenderer.h"
#import "ActionItemPlainRenderer.h"
#import "DecisionPlainRenderer.h"
#import "KeyPointPlainRenderer.h"
#import "Note.h"
#import "Entry.h"
#import "EntityRenderHandler.h"
#import "NotePlainRenderer.h"
#import "TopicSummaryPlainRenderer.h"
#import "NotePlainRenderer.h"

@interface BNotePlainTextRenderer()

- (id)initSingleton;

@end

@implementation BNotePlainTextRenderer

- (NSString *)render:(Topic *)topic
{
    NSArray *renderers = [self renderers];
    
    NSString *text = [[[TopicSummaryPlainRenderer alloc] init] render:topic];
    
    NotePlainRenderer *noteRenderer = [[NotePlainRenderer alloc] init];
    
    for (Note *note in [topic notes]) {
        text = [BNoteStringUtils append:text, [noteRenderer render:note], nil];
        
        for (Entry *entry in note.entries) {
            for (id<EntityRenderHandler> renderer in renderers) {
                if ([renderer accept:entry]) {
                    text = [BNoteStringUtils append:text, [renderer render:entry], nil];
                }
            }
        }
    }
    
    for (Note *note in [topic associatedNotes]) {
        text = [BNoteStringUtils append:text, [noteRenderer render:note], nil];
        
        for (Entry *entry in note.entries) {
            for (id<EntityRenderHandler> renderer in renderers) {
                if ([renderer accept:entry]) {
                    text = [BNoteStringUtils append:text, [renderer render:entry], nil];
                }
            }
        }
    }
    
    return text;
}

- (NSString *)render:(Topic *)topic and:(Note *)selectedNote
{
    NSArray *renderers = [self renderers];

    NSString *text = [[[TopicSummaryPlainRenderer alloc] init] render:topic];
    
    NotePlainRenderer *noteRenderer = [[NotePlainRenderer alloc] init];
    
    for (Note *note in [topic notes]) {
        if (note == selectedNote) {
            text = [BNoteStringUtils append:text, [noteRenderer render:note], nil];
            
            for (Entry *entry in note.entries) {
                for (id<EntityRenderHandler> renderer in renderers) {
                    if ([renderer accept:entry]) {
                        text = [BNoteStringUtils append:text, [renderer render:entry], nil];
                    }
                }
            }
        }
    }
    
    return text;
}

- (NSArray *)renderers
{
    NSMutableArray *arrays = [[NSMutableArray alloc] init];
    
    [arrays addObject:[[QuestionPlainRenderer alloc] init]];
    [arrays addObject:[[ActionItemPlainRenderer alloc] init]];
    [arrays addObject:[[DecisionPlainRenderer alloc] init]];
    [arrays addObject:[[KeyPointPlainRenderer alloc] init]];

    return arrays;
}

- (id)initSingleton
{
    self = [super init];
    
    return self;
}

+ (BNotePlainTextRenderer *)instance
{
    static BNotePlainTextRenderer *_default = nil;
    
    if (_default != nil) {
        return _default;
    }
    
    static dispatch_once_t safer;
    dispatch_once(&safer, ^{
        _default = [[BNotePlainTextRenderer alloc] initSingleton];
    });
    
    return _default;
}

@end
