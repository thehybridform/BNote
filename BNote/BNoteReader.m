//
//  BNoteReader.m
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteReader.h"
#import "BNoteFactory.h"
#import "TopicGroup.h"

@interface BNoteReader()

- (id)initSingleton;

@end

@implementation BNoteReader
@synthesize context = _context;

- (id)initSingleton
{
    self = [super init];
    
    return self;
}

+ (BNoteReader *)instance
{
    static BNoteReader *_default = nil;
    
    if (_default != nil) {
        return _default;
    }
    
    static dispatch_once_t safer;
    dispatch_once(&safer, ^{
        _default = [[BNoteReader alloc] initSingleton];
    });
    
    return _default;
}

- (TopicGroup *)getTopicGroup:(NSString *)name
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TopicGroup"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *topicGroups = [[self context] executeFetchRequest:fetchRequest error:&error];
    
    if ([topicGroups count]) {
        return [topicGroups objectAtIndex:0];
    } else {
        return nil;
    }
}

- (NSMutableArray *)allTopics
{
    [self checkTopicGroup];
    
    TopicGroup *group = [self getTopicGroup:@"All"];
    
    if (group) {
        return [[group topics] mutableCopy];
    } else {
        return [NSMutableArray array];
    }
}

// temporaty method.
- (void)checkTopicGroup
{
    TopicGroup *group = [self getTopicGroup:@"All"];
    if (!group) {
        group = [BNoteFactory createTopicGroup:@"All"];
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Topic"];
    NSError *error = nil;
    NSArray *topics = [[self context] executeFetchRequest:fetchRequest error:&error];

    for (Topic *topic in topics) {
        if (![self topic:topic contains:group]) {
            [group addTopicsObject:topic];
        }
    }
}

// temporaty method.
- (BOOL)topic:(Topic *)topic contains:(TopicGroup *)group
{
    for (TopicGroup *g in [topic groups]) {
        if (g == group) {
            return YES;
        }
    }
    
    return NO;
}

- (NSMutableSet *)allKeyWords
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"KeyWord"];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"word" ascending:YES]];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *keyWords = [[self context] executeFetchRequest:fetchRequest error:&error];
    
    if (keyWords) {
        return [keyWords mutableCopy];
    } else {
        return [NSMutableArray array];
    }    
}

- (KeyWord *)keyWordFor:(NSString *)word
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"KeyWord"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"word = %@", word];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *keyWords = [[self context] executeFetchRequest:fetchRequest error:&error];
    
    if (keyWords && [keyWords count] > 0) {
        return [keyWords objectAtIndex:0];
    }    
    
    return nil;
}

@end
