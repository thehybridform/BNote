//
// Created by kristinyoung on 4/10/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "EntityMigratorBasis.h"


@implementation EntityMigratorBasis

- (BOOL)migrateFrom:(NSManagedObjectContext *)context to:(NSManagedObjectContext *)to {
    BOOL success = YES;
    for (id entity in [self entities:context]) {
        success = success && [self save:entity in:to];
    }

    return success;
}

- (BOOL)save:(id)entity in:(NSManagedObjectContext *)context {
    id newEntity = [NSEntityDescription insertNewObjectForEntityForName:[self name] inManagedObjectContext:context];

    [self clone:entity to:newEntity in:context];

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

- (id <NSFastEnumeration>)entities:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:[self name]];
    NSError *error = nil;
    NSArray *entities = [context executeFetchRequest:fetchRequest error:&error];

    if (error != nil) {
        NSLog(@"Error: %@", error);
    }

    return entities;
}

- (id)findEntity:(NSString *)name withId:(NSString *)identifier in:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:name];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", identifier];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    id entity = [context executeFetchRequest:fetchRequest error:&error];

    if (error != nil) {
        NSLog(@"Error: %@", error);
    }

    return entity;
}

- (NSString *)name {
    return nil;
}

- (void)clone:(id)from to:(id)to in:(NSManagedObjectContext *)context {

}

@end