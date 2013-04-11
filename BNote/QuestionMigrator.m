//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "QuestionMigrator.h"


@implementation QuestionMigrator {

}

- (NSString *)name {
    return @"Question";
}

- (void)clone:(Question *)from to:(Question *)to in:(NSManagedObjectContext *)context {
    to.answer = from.answer;
    to.created = from.created;
    to.lastUpdated = from.lastUpdated;
    to.text = from.text;

    Note *note = [self findEntity:@"Note" withId:from.note.id in:context];
    to.note = note;
}

@end