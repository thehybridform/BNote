//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "TopicMigrator.h"
#import "Topic.h"


@implementation TopicMigrator


- (NSString *)name {
    return @"Topic";
}

- (void)clone:(Topic *)from to:(Topic *)to in:(NSManagedObjectContext *)context {
    to.color = from.color;
    to.created = from.created;
    to.id = from.id;
    to.lastUpdated = from.lastUpdated;
    to.title = from.title;

    for (TopicGroup *topicGroup in from.groups) {
        TopicGroup *newTopicGroup = [self findEntity:@"TopicGroup" withId:topicGroup.id in:context];
        [newTopicGroup addTopicsObject:to];
    }
}

@end