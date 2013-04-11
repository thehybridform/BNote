//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AttendantsMigrator.h"


@implementation AttendantsMigrator {

}

- (NSString *)name {
    return @"Attendants";
}

- (void)clone:(Attendants *)from to:(Attendants *)to in:(NSManagedObjectContext *)context {
    to.created = from.created;
    to.lastUpdated = from.lastUpdated;
    to.text = from.text;

    Note *note = [self findEntity:@"Note" withId:from.note.id in:context];
    to.note = note;
}

@end