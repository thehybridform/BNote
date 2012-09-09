//
//  AppDelegate.m
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "BNoteWriter.h"
#import "BNoteReader.h"
#import "BNoteSessionData.h"
#import "BNoteLiteViewController.h"

@interface AppDelegate()
@property (strong, nonatomic) MainViewViewController *mainViewViewController;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSURL *url;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize mainViewViewController = _mainViewViewController;
@synthesize url = _url;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    BNoteWriter.instance.context = self.managedObjectContext;
    BNoteReader.instance.context = self.managedObjectContext;
    
    MainViewViewController *mainViewViewController = [[MainViewViewController alloc] initWithDefault];
    [self setMainViewViewController:mainViewViewController];
    
    self.window.rootViewController = mainViewViewController;
    [self.window makeKeyAndVisible];
    
        
    if (![BNoteSessionData booleanForKey:kEulaFlag]) {
        UIViewController *controller;
        controller = [[BNoteLiteViewController alloc] initWithDefault];
        controller.modalPresentationStyle = UIModalPresentationFormSheet;
        controller.modalInPopover = YES;
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        
        [mainViewViewController presentViewController:controller animated:YES completion:^{}];
    }
        
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    if (self.mainViewViewController.searchTopic) {
        [[BNoteWriter instance] removeTopic:[[self mainViewViewController] searchTopic]];
    }
    [[BNoteWriter instance] update];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (self.mainViewViewController.searchTopic) {
        [[BNoteWriter instance] removeTopic:[[self mainViewViewController] searchTopic]];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{

}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if (url) {
        self.url = url;
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:NSLocalizedString(@"Import Notes Title", nil)
                              message:nil
                              delegate:self
                              cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                              otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        
        [alert show];
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.mainViewViewController presentImportController:self.url];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    if (self.mainViewViewController.searchTopic) {
        [[BNoteWriter instance] removeTopic:[[self mainViewViewController] searchTopic]];
    }
    [[BNoteWriter instance] update];
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    if (coordinator != nil) {
        NSManagedObjectContext* moc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        
        [moc performBlockAndWait:^{
            [moc setPersistentStoreCoordinator: coordinator];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(mergeChangesFrom_iCloud:) name:NSPersistentStoreDidImportUbiquitousContentChangesNotification object:coordinator];
        }];
        __managedObjectContext = moc;
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

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        

        NSString *iCloudEnabledAppID = @"com.kristinyoung.BeNote";
        NSString *dataFileName = @"BeNote-data.sqlite";
        NSString *iCloudDataDirectoryName = @"BeNote-data.nosync";
        NSString *iCloudLogsDirectoryName = @"BeNoteLogs";
        NSFileManager *fileManager = [NSFileManager defaultManager];        
        NSURL *localStore = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:dataFileName];
        
        NSURL *iCloud;
        
#ifdef LITE
        iCloud = nil;
#else
        iCloud = [fileManager URLForUbiquityContainerIdentifier:nil];
#endif
        
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
 
        } else {
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
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:kRefetchAllDatabaseData
             object:self
             userInfo:nil];
        });
    });

    return __persistentStoreCoordinator;
}

- (void)mergeChangesFrom_iCloud:(NSNotification *)notification {
        
    NSManagedObjectContext* moc = [self managedObjectContext];
    
    [moc performBlock:^{
        
        [moc mergeChangesFromContextDidSaveNotification:notification]; 
        
        NSNotification* refreshNotification = [NSNotification notificationWithName:kRefetchAllDatabaseData
                                                                            object:self
                                                                          userInfo:[notification userInfo]];
        
        [[NSNotificationCenter defaultCenter] postNotification:refreshNotification];
    }];
}

@end
