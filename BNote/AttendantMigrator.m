//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "AttendantMigrator.h"


@implementation AttendantMigrator {

}

- (NSString *)name {
    return @"Attendees";
}

- (void)clone:(Attendant *)from to:(Attendant *)to in:(NSManagedObjectContext *)context {
    to.email = from.email;
    to.firstName = from.firstName;
    to.image = from.image;
    to.lastName = from.lastName;
    to.phone = from.phone;

    Attendants *attendants = [self findEntity:@"" withId:@"Attendants" in:context];
    to.parent = attendants;
}

@end