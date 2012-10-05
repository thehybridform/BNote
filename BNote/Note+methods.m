//
// Created by kristinyoung on 10/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


@implementation Note (methods)

static NSString *const kItemsKey = @"entries";

- (void)removeEntriesObject:(Entry *)value
{
    NSUInteger idx = [[self mutableEntries] indexOfObject:value];
    if (idx != NSNotFound) {
        NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
        [[self mutableEntries] removeObject:value];
        [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
    }
}

- (void)insertObject:(Entry *)value inEntriesAtIndex:(NSUInteger)idx
{
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
    [[self mutableEntries] insertObject:value atIndex:idx];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
}

- (NSMutableOrderedSet *)mutableEntries
{
    if (![self.entries isKindOfClass:[NSMutableOrderedSet class]]) {
        self.entries = [[NSMutableOrderedSet alloc] initWithOrderedSet:self.entries];
    }

    return (NSMutableOrderedSet *) self.entries;
}

@end