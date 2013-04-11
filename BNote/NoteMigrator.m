//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NoteMigrator.h"
#import "Topic.h"


@implementation NoteMigrator {

}

- (NSString *)name {
    return @"Note";
}

- (void)clone:(Note *)from to:(Note *)to in:(NSManagedObjectContext *)context {
    to.created = from.created;
    to.id = from.id;
    to.lastUpdated = from.lastUpdated;
    to.color = from.color;
    to.subject = from.subject;
    to.summary = from.summary;

    [to setTopic:[self findEntity:@"Topic" withId:from.id in:context]];

    for (Topic *topic in from.associatedTopics) {
        Topic *newTopic = [self findEntity:@"Topic" withId:topic.id in:context];
        [newTopic addAssociatedNotesObject:to];
    }
}

@end