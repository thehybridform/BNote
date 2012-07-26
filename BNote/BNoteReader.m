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

- (Topic *)getTopic:(NSString *)name
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Topic"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *topics = [[self context] executeFetchRequest:fetchRequest error:&error];
    
    if ([topics count]) {
        return [topics objectAtIndex:0];
    } else {
        return nil;
    }
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
    TopicGroup *group = [self getTopicGroup:@"All"];
    
    if (group) {
        return [[group topics] mutableCopy];
    } else {
        group = [BNoteFactory createTopicGroup:@"All"];
        return [NSMutableArray arrayWithObject:group];
    }
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

- (NSMutableArray *)allTopicGroups
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TopicGroup"];
    
    NSError *error = nil;
    NSArray *result = [[self context] executeFetchRequest:fetchRequest error:&error];
    
    NSArray *sortedArray = [result sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [[(TopicGroup *)a name] lowercaseString];
        NSString *second = [[(TopicGroup *)b name] lowercaseString];
        return [first compare:second];
    }];
    
    return [sortedArray mutableCopy];
}

@end
