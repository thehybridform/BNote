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
#import "ManagedObjectContextFactory.h"

@interface AppDelegate()
@property (strong, nonatomic) MainViewViewController *mainViewViewController;

@property (strong, nonatomic) NSURL *url;

@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize mainViewViewController = _mainViewViewController;
@synthesize url = _url;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    BNoteWriter.instance.context = [[ManagedObjectContextFactory instance] createManagedObjectContext];
    BNoteReader.instance.context = [[ManagedObjectContextFactory instance] createManagedObjectContext];
    
    MainViewViewController *mainViewViewController = [[MainViewViewController alloc] initWithDefault];
    [self setMainViewViewController:mainViewViewController];
    
    self.window.rootViewController = mainViewViewController;
    [self.window makeKeyAndVisible];


    if (![BNoteSessionData booleanForKey:kFirstLoad]) {
        BNoteLiteViewController *controller = [[BNoteLiteViewController alloc] initWithDefault];
        controller.helpDelegate = mainViewViewController;
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

@end
