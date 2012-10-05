//
// Created by kristinyoung on 10/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


@implementation Attendants (methods)

static NSString *const kItemsKey = @"children";

- (void)removeChildrenObject:(Attendant *)value
{
    NSUInteger idx = [[self mutableChildren] indexOfObject:value];
    if (idx != NSNotFound) {
        NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
        [self willChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
        [[self mutableChildren] removeObject:value];
        [self didChange:NSKeyValueChangeRemoval valuesAtIndexes:indexes forKey:kItemsKey];
    }
}

- (NSMutableOrderedSet *)mutableChildren
{
    if (![self.children isKindOfClass:[NSMutableOrderedSet class]]) {
        self.children = [[NSMutableOrderedSet alloc] initWithOrderedSet:self.children];
    }

    return (NSMutableOrderedSet *) self.children;
}

@end