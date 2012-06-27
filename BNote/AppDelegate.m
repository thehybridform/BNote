//
//  AppDelegate.m
//  BNote
//
//  Created by Young Kristin on 5/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "BNoteWriter.h"
#import "BNoteReader.h"
#import "BNoteFactory.h"
#import "EluaViewController.h"

@interface AppDelegate()

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];

    DetailViewController *detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
//    UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:detailViewController];

    masterViewController.detailViewController = detailViewController;
    
    [[BNoteWriter instance] setContext:[self managedObjectContext]];
    [[BNoteReader instance] setContext:[self managedObjectContext]];
        
    self.splitViewController = [[UISplitViewController alloc] init];
    self.splitViewController.delegate = detailViewController;
    self.splitViewController.viewControllers = [NSArray arrayWithObjects:masterNavigationController, detailViewController, nil];
    self.window.rootViewController = self.splitViewController;
    
    [self.window makeKeyAndVisible];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *agreedToEula = [defaults objectForKey:EulaFlag];
    if (!agreedToEula) {
        EluaViewController *controller = [[EluaViewController alloc] initWithDefault];
        [controller setEula:YES];
        [controller setModalInPopover:YES];
        [controller setModalPresentationStyle:UIModalPresentationPageSheet];
        [controller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
        
        [[self splitViewController] presentModalViewController:controller animated:YES];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
        NSString *dataFileName = @"BeNote.sqlite";
        NSString *iCloudDataDirectoryName = @"BeNote.nosync";
        NSString *iCloudLogsDirectoryName = @"BeNoteLogs";
        NSFileManager *fileManager = [NSFileManager defaultManager];        
        NSURL *localStore = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:dataFileName];
        NSURL *iCloud = [fileManager URLForUbiquityContainerIdentifier:nil];
        
        if (iCloud != nil) {
            
//            NSLog(@"iCloud is working");

            NSURL *iCloudLogsPath = [NSURL fileURLWithPath:[[iCloud path] stringByAppendingPathComponent:iCloudLogsDirectoryName]];

//            NSLog(@"iCloudEnabledAppID = %@",iCloudEnabledAppID);
//            NSLog(@"dataFileName = %@", dataFileName); 
//            NSLog(@"iCloudDataDirectoryName = %@", iCloudDataDirectoryName);
//            NSLog(@"iCloudLogsDirectoryName = %@", iCloudLogsDirectoryName);  
//            NSLog(@"iCloud = %@", iCloud);
//            NSLog(@"iCloudLogsPath = %@", iCloudLogsPath);
            
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
            
            
//            NSLog(@"iCloudData = %@", iCloudData);

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
//            NSLog(@"iCloud is NOT working - using a local store");
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
        
        
//        NSLog(@"connected to storage");
/*
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter]
             postNotificationName:RefetchAllDatabaseData
             object:self
             userInfo:nil];
        });
 */
    });

    return __persistentStoreCoordinator;
}

- (void)mergeChangesFrom_iCloud:(NSNotification *)notification {
    
//	NSLog(@"Merging in changes from iCloud...");
    
    NSManagedObjectContext* moc = [self managedObjectContext];
    
    [moc performBlock:^{
        
        [moc mergeChangesFromContextDidSaveNotification:notification]; 
        
        NSNotification* refreshNotification = [NSNotification notificationWithName:RefetchAllDatabaseData
                                                                            object:self
                                                                          userInfo:[notification userInfo]];
        
        [[NSNotificationCenter defaultCenter] postNotification:refreshNotification];
    }];
}

@end
