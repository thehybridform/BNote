//
// Created by kristinyoung on 4/8/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "ManagedObjectContextFactory.h"
#import "BNoteSessionData.h"
#import "DatabaseMigrator.h"

@interface ManagedObjectContextFactory()

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (id)initSingleton;

@end

@implementation ManagedObjectContextFactory

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (id)initSingleton
{
    self = [super init];

    return self;
}

+ (ManagedObjectContextFactory *)instance
{
    static ManagedObjectContextFactory *_default = nil;

    if (_default != nil) {
        return _default;
    }

    static dispatch_once_t safer;
    dispatch_once(&safer, ^{
        _default = [[ManagedObjectContextFactory alloc] initSingleton];
    });

    return _default;
}

- (NSManagedObjectContext *)createManagedObjectContext {
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }

    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];

    if (coordinator != nil) {
        NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];

        [moc performBlockAndWait:^{
            [moc setPersistentStoreCoordinator: coordinator];
        }];
        __managedObjectContext = moc;
    }

    if ([BNoteSessionData booleanForKey:kFirstLoad]) {
        [DatabaseMigrator migrate:__managedObjectContext];
    }

    return __managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }

    NSURL *modelURL = [[NSBundle mainBundle]
            URLForResource:@"BeNote"
             withExtension:@"momd"];

    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    return __managedObjectModel;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }

    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
            initWithManagedObjectModel: [self managedObjectModel]];
    NSPersistentStoreCoordinator *psc = __persistentStoreCoordinator;

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *dataFileName = @"BeNote-data2.sqlite";
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

        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
                    postNotificationName:kRefetchAllDatabaseData
                                  object:self
                                userInfo:nil];
        });
//    });

    return __persistentStoreCoordinator;
}

@end