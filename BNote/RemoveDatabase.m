//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "RemoveDatabase.h"


@implementation RemoveDatabase {

}
- (BOOL)migrateFrom:(NSManagedObjectContext *)context to:(NSManagedObjectContext *)to {

    for (id entity in [self entities:context for:@"TopicGroup"]) {
        [context deleteObject:entity];
    }

    for (id entity in [self entities:context for:@"KeyWord"]) {
        [context deleteObject:entity];
    }

    NSError *error = nil;

    BOOL success = [context save:&error];

    if (error != nil) {
        NSLog(@"Error: %@", error);
    }

    if (!success) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }

    return success;
}

- (id <NSFastEnumeration>)entities:(NSManagedObjectContext *)context for:(NSString *)name {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:name];
    NSError *error = nil;
    NSArray *entities = [context executeFetchRequest:fetchRequest error:&error];

    if (error != nil) {
        NSLog(@"Error: %@", error);
    }

    return entities;
}

@end