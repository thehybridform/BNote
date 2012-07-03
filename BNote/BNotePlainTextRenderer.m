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
@property (strong, nonatomic) NSArray *renderers;

- (id)initSingleton;

@end

@implementation BNotePlainTextRenderer
@synthesize renderers = _renderers;

- (NSString *)render:(Topic *)topic
{
    NSString *text = [[[TopicSummaryPlainRenderer alloc] init] render:topic];
    
    NotePlainRenderer *noteRenderer = [[NotePlainRenderer alloc] init];
    
    for (Note *note in [topic notes]) {
        text = [BNoteStringUtils append:text, [noteRenderer render:note], nil];
        NSEnumerator *entries = [[note entries] objectEnumerator];
        Entry *entry;
        while (entry = [entries nextObject]) {
            NSEnumerator *renderers = [[self renderers] objectEnumerator];
            id<EntityRenderHandler> renderer;
            while (renderer = [renderers nextObject]) {
                if ([renderer accept:entry]) {
                    text = [BNoteStringUtils append:text, [renderer render:entry], nil];
                }
            }
        }
    }
    
    for (Note *note in [topic associatedNotes]) {
        text = [BNoteStringUtils append:text, [noteRenderer render:note], nil];
        NSEnumerator *entries = [[note entries] objectEnumerator];
        Entry *entry;
        while (entry = [entries nextObject]) {
            NSEnumerator *renderers = [[self renderers] objectEnumerator];
            id<EntityRenderHandler> renderer;
            while (renderer = [renderers nextObject]) {
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
    NSString *text = [[[TopicSummaryPlainRenderer alloc] init] render:topic];
    
    NotePlainRenderer *noteRenderer = [[NotePlainRenderer alloc] init];
    
    for (Note *note in [topic notes]) {
        if (note == selectedNote) {
            text = [BNoteStringUtils append:text, [noteRenderer render:note], nil];
            NSEnumerator *entries = [[note entries] objectEnumerator];
            Entry *entry;
            while (entry = [entries nextObject]) {
                NSEnumerator *renderers = [[self renderers] objectEnumerator];
                id<EntityRenderHandler> renderer;
                while (renderer = [renderers nextObject]) {
                    if ([renderer accept:entry]) {
                        text = [BNoteStringUtils append:text, [renderer render:entry], nil];
                    }
                }
            }
        }
    }
    
    return text;
}

- (id)initSingleton
{
    self = [super init];
    
    NSMutableArray *arrays = [[NSMutableArray alloc] init];
    
    [arrays addObject:[[QuestionPlainRenderer alloc] init]];
    [arrays addObject:[[ActionItemPlainRenderer alloc] init]];
    [arrays addObject:[[DecisionPlainRenderer alloc] init]];
    [arrays addObject:[[KeyPointPlainRenderer alloc] init]];

    [self setRenderers:arrays];
    
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
