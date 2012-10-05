//
//  TopicGroup+methods.m
//  BeNote
//
//  Created by kristin young on 10/4/12.
//
//

@implementation TopicGroup (methods)

static NSString *const kItemsKey = @"topics";

- (void)addTopicsObject:(Topic *)value;
{
    NSUInteger idx = [self.topics count];
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
    [[self mutableTopics] addObject:value];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
}

- (void)removeTopicsObject:(Topic *)value
{
    NSUInteger idx = [[self mutableTopics] indexOfObject:value];
    if (idx != NSNotFound) {
        NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
        [[self mutableTopics] removeObject:value];
        [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
    }
}

- (void)insertObject:(Topic *)value inTopicsAtIndex:(NSUInteger)idx
{
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
    [[self mutableTopics] insertObject:value atIndex:idx];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
}

- (NSMutableOrderedSet *)mutableTopics
{
    if (![self.topics isKindOfClass:[NSMutableOrderedSet class]]) {
        self.topics = [[NSMutableOrderedSet alloc] initWithOrderedSet:self.topics];
    }

    return (NSMutableOrderedSet *) self.topics;
}

@end
