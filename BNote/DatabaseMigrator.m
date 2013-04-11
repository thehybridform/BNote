//
// Created by kristinyoung on 4/8/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "DatabaseMigrator.h"
#import "EntityMigratorFactory.h"
#import "EntityMigrator.h"
#import "RemoveDatabase.h"
#import "Migration.h"

@implementation DatabaseMigrator

+ (void)migrate:(NSManagedObjectContext *)destination {
    Migration *migration = [self migrationRecord:destination];

    if (!migration.remote) {
        BOOL success = YES;
        NSManagedObjectContext *remoteContext = [self remoteContext];
        if ([remoteContext persistentStoreCoordinator]) {
            success = [self migrateFrom:remoteContext to:destination];
        }

        if (success) {
            migration.remote = YES;
            [self save:destination];
        }
    }

    if (!migration.local) {
        BOOL success = [self migrateFrom:[self localContext] to:destination];
        if (success) {
            migration.local = YES;
            [self save:destination];
        }
    }
}

+ (BOOL)migrateFrom:(NSManagedObjectContext *)context to:(NSManagedObjectContext *)to {
    BOOL success = true;
    for (id<EntityMigrator> migrator in [EntityMigratorFactory migrators]) {
        success = success && [migrator migrateFrom:context to:to];
    }

    if (success) {
        RemoveDatabase *removeDatabase = [[RemoveDatabase alloc] init];
        [removeDatabase remove:context];
    }

    return success;
}

+(Migration *)migrationRecord:(NSManagedObjectContext *)context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Migration"];
    NSError *error = nil;
    NSArray *entities = [context executeFetchRequest:fetchRequest error:&error];

    if (error != nil) {
        NSLog(@"Error: %@", error);
    }

    Migration *migration;
    if ([entities count]) {
        migration = [entities objectAtIndex:0];
    } else {
        migration = [NSEntityDescription insertNewObjectForEntityForName:@"Migration" inManagedObjectContext:context];
        [self save:context];
    }

    return migration;
}

+ (void)save:(NSManagedObjectContext *)context {
    NSError *error = nil;

    BOOL success = [context save:&error];

    if (error != nil) {
        NSLog(@"Error: %@", error);
    }

    if (!success) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
}

+ (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

+ (NSManagedObjectContext *)remoteContext {

    NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSURL *modelURL = [[NSBundle mainBundle]
            URLForResource:@"BeNote"
             withExtension:@"momd"];

        NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: managedObjectModel];

        NSString *iCloudEnabledAppID = @"com.kristinyoung.BeNote";
        NSString *dataFileName = @"BeNote-data.sqlite";
        NSString *iCloudDataDirectoryName = @"BeNote-data.nosync";
        NSString *iCloudLogsDirectoryName = @"BeNoteLogs";
        NSFileManager *fileManager = [NSFileManager defaultManager];

        NSURL *iCloud = [fileManager URLForUbiquityContainerIdentifier:nil];

        if (iCloud != nil) {

            NSURL *iCloudLogsPath = [NSURL fileURLWithPath:[[iCloud path] stringByAppendingPathComponent:iCloudLogsDirectoryName]];

            if([fileManager fileExistsAtPath:[[iCloud path] stringByAppendingPathComponent:iCloudDataDirectoryName]] == NO) {
                NSError *fileSystemError;
                [fileManager createDirectoryAtPath:[[iCloud path] stringByAppendingPathComponent:iCloudDataDirectoryName]
                       withIntermediateDirectories:YES
                                        attributes:nil
                                             error:&fileSystemError];
                if(fileSystemError != nil) {
                    NSLog(@"Error creating database directory %@", fileSystemError);
                }
            }

            NSString *iCloudData = [[[iCloud path]
                    stringByAppendingPathComponent:iCloudDataDirectoryName]
                    stringByAppendingPathComponent:dataFileName];


            NSMutableDictionary *options = [NSMutableDictionary dictionary];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
            [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
            [options setObject:iCloudEnabledAppID            forKey:NSPersistentStoreUbiquitousContentNameKey];
            [options setObject:iCloudLogsPath                forKey:NSPersistentStoreUbiquitousContentURLKey];

            [psc lock];

            NSError *fileSystemError;

            [psc addPersistentStoreWithType:NSSQLiteStoreType
                              configuration:nil
                                        URL:[NSURL fileURLWithPath:iCloudData]
                                    options:options
                                      error:&fileSystemError];

            if(fileSystemError != nil) {
                NSLog(@"Error creating database directory %@", fileSystemError);
            }

            [psc unlock];

            [moc performBlockAndWait:^{
                [moc setPersistentStoreCoordinator: psc];
            }];
        }
//    });


    return moc;
}

+ (NSManagedObjectContext *)localContext {
    NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSURL *modelURL = [[NSBundle mainBundle]
            URLForResource:@"BeNote"
             withExtension:@"momd"];

        NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: managedObjectModel];


        NSString *dataFileName = @"BeNote-data.sqlite";
        NSURL *localStore = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:dataFileName];

        NSMutableDictionary *options = [NSMutableDictionary dictionary];
        [options setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
        [options setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];

        [psc lock];

        NSError *fileSystemError;

        [psc addPersistentStoreWithType:NSSQLiteStoreType
                          configuration:nil
                                    URL:localStore
                                options:options
                                  error:&fileSystemError];

        if(fileSystemError != nil) {
            NSLog(@"Error creating database directory %@", fileSystemError);
        }

        [psc unlock];

        [moc performBlockAndWait:^{
            [moc setPersistentStoreCoordinator: psc];
        }];

//    });

    return moc;
}

@end