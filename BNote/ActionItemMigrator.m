//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ActionItemMigrator.h"


@implementation ActionItemMigrator {

}

- (NSString *)name {
    return @"ActionItem";
}

- (void)clone:(ActionItem *)from to:(ActionItem *)to in:(NSManagedObjectContext *)context {
    to.created = from.created;
    to.lastUpdated = from.lastUpdated;
    to.text = from.text;

    to.completed = from.completed;
    to.dueDate = from.dueDate;

    Note *note = [self findEntity:@"Note" withId:from.note.id in:context];
    to.note = note;
}

@end