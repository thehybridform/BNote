//
//  BNoteReader.m
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BNoteReader.h"
#import "BNoteFactory.h"
#import "BNoteWriter.h"

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

- (Topic *)getTopicForName:(NSString *)name
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Topic"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title = %@", name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *topics = [[self context] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", error);
    }
    
    if ([topics count]) {
        Topic *topic = [topics objectAtIndex:0];
        if (!topic.id) {
            topic.id = [BNoteStringUtils guuid];
        }
        return topic;
    } else {
        return nil;
    }
}

- (Topic *)getFilteredTopic
{
    return [self getTopicForName:kFilteredTopicName];
}

- (TopicGroup *)getTopicGroup:(NSString *)name
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"TopicGroup"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *topicGroups = [[self context] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", error);
    }
    
    if ([topicGroups count]) {
        return [topicGroups objectAtIndex:0];
    } else {
        return nil;
    }
}

- (NSMutableArray *)allTopics
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Topic"];

    NSError *error = nil;
    NSArray *allTopics = [[self context] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", error);
    }
    
    if ([allTopics count]) {
        TopicGroup *group = [self getTopicGroup:kAllTopicGroupName];
        if (!group) {
            [BNoteFactory createTopicGroup:kAllTopicGroupName];
        }
        
        [[BNoteWriter instance] update];
        
        return [allTopics mutableCopy];
    }
    
    return nil;
}

- (NSArray *)allKeyWords
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"KeyWord"];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"word" ascending:YES]];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    NSArray *keyWords = [[self context] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", error);
    }
    
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
    
    if (error != nil) {
        NSLog(@"Error: %@", error);
    }
    
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
    
    if (error != nil) {
        NSLog(@"Error: %@", error);
    }

    NSArray *sortedArray = [result sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *first = [[(TopicGroup *)a name] lowercaseString];
        NSString *second = [[(TopicGroup *)b name] lowercaseString];
        return [first compare:second];
    }];
    
    return [sortedArray mutableCopy];
}

- (NSSet *)findNotesWithText:(NSString *)searchText
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Note"];
    NSPredicate *predicate =
        [NSPredicate predicateWithFormat:
            @"subject CONTAINS[cd] %@ OR entries.text CONTAINS[cd] %@",
         searchText, searchText];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *notes = [[self context] executeFetchRequest:fetchRequest error:&error];
    
    if (error != nil) {
        NSLog(@"Error: %@", error);
    }

    return [NSMutableSet setWithArray:notes];
}

- (NSArray *)topicNames
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Topic"];
    [fetchRequest setResultType:NSDictionaryResultType];
    [fetchRequest setPropertiesToFetch:
            [NSArray arrayWithObjects:@"title", nil]];

    NSError *error = nil;
    NSArray *names = [[self context] executeFetchRequest:fetchRequest error:&error];

    if (error != nil) {
        NSLog(@"Error: %@", error);
    }

    return names;
}

@end
