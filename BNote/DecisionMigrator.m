//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DecisionMigrator.h"
#import "Decision.h"


@implementation DecisionMigrator {

}

- (NSString *)name {
    return @"Decision";
}

- (void)clone:(Decision *)from to:(Decision *)to in:(NSManagedObjectContext *)context {
    to.created = from.created;
    to.lastUpdated = from.lastUpdated;
    to.text = from.text;

    Note *note = [self findEntity:@"Note" withId:from.note.id in:context];
    to.note = note;
}

@end