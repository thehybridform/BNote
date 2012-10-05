//
// Created by kristinyoung on 10/4/12.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Topic.h"

@implementation Topic (methods)

static NSString *const kItemsKey = @"associatedNotes";

- (void)addAssociatedNotesObject:(Note *)value
{
    NSUInteger idx = [self.associatedNotes count];
    NSIndexSet* indexes = [NSIndexSet indexSetWithIndex:idx];
    [self willChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
    [[self mutableAssociatedNotes] addObject:value];
    [self didChange:NSKeyValueChangeInsertion valuesAtIndexes:indexes forKey:kItemsKey];
}

- (NSMutableOrderedSet *)mutableAssociatedNotes
{
    if (![self.associatedNotes isKindOfClass:[NSMutableOrderedSet class]]) {
        self.associatedNotes = [[NSMutableOrderedSet alloc] initWithOrderedSet:self.associatedNotes];
    }

    return (NSMutableOrderedSet *) self.associatedNotes;
}

@end