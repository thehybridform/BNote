//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TopicGroupMigrator.h"


@implementation TopicGroupMigrator

- (NSString *)name {
    return @"TopicGroup";
}

- (void)clone:(TopicGroup *)from to:(TopicGroup *)to in:(NSManagedObjectContext *)context {
    to.created = from.created;
    to.id = from.id;
    to.lastUpdated = from.lastUpdated;
    to.name = from.name;
}


@end