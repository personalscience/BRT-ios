//
//  BTAppDelegate.m
//  BrainTracker
//
//  Created by Richard Sprague on 3/5/14.
//  Copyright (c) 2014 Richard Sprague. All rights reserved.
//

#import "BTAppDelegate.h"
#import <CoreData/CoreData.h>
#import "ZBConnectionProtocol.h"

@interface BTAppDelegate()
@property (strong, nonatomic) NSManagedObjectContext *BTDataContext;
@property (strong, nonatomic) UIManagedDocument *document;

@end

extern NSString *ZBAccessToken;
extern NSString *ZBScopeToken;

@implementation BTAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


- (void) documentIsReady {
    if (self.document.documentState == UIDocumentStateNormal){
        
#if DEBUG
        NSLog(@"%@...ready to start using document",[[NSString stringWithUTF8String:__FILE__] lastPathComponent]);
#endif
        
        //[[NSString stringWithUTF8String:__FILE__] lastPathComponent]
        self.BTDataContext = self.document.managedObjectContext;
        self.managedObjectContext = self.BTDataContext;
    }
    
}

// used by CoreDataPro
#if !(TARGET_OS_EMBEDDED)  // This will work for Mac or Simulator but excludes physical iOS devices
- (void) createCoreDataDebugProjectWithType: (NSNumber*) storeFormat storeUrl:(NSString*) storeURL modelFilePath:(NSString*) modelFilePath {
    NSDictionary* project = @{
                              @"storeFilePath": storeURL,
                              @"storeFormat" : storeFormat,
                              @"modelFilePath": modelFilePath,
                              @"v" : @(1)
                              };
    
    NSString* projectFile = [NSString stringWithFormat:@"/tmp/%@.cdp", [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey]];
    
    [project writeToFile:projectFile atomically:YES];
    
}
#endif

# pragma mark Zenobase handling

- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"Calling from application Bundle ID: %@", sourceApplication);
    //    NSLog(@"URL scheme:%@", [url scheme]);
    //    NSLog(@"URL query: %@", [url query]);
    //    NSLog(@"URL query: %@", [url fragment]);
    
    NSArray *urlComponents = [url.fragment componentsSeparatedByString:@"&"];
    if (urlComponents.count < 2){
        NSLog(@"Error: attempting to load application without specifying an access token: %@",urlComponents);
    } else {
        
        NSString *accessToken = nil;
        NSString *scopeToken = nil;
        NSArray *accessTokenArray= [urlComponents[0] componentsSeparatedByString:@"="];
        NSArray *scopeIDArray = [urlComponents[2] componentsSeparatedByString:@"="];
        
        // if all is well, then:
        // accessToken = accessTokenArray[1]
        // scopeToken = scopeIDArray[1]
        // but the following convoluted if-statement will double-check
        if ([accessTokenArray[0] isKindOfClass:[NSString class]] && [scopeIDArray[0] isKindOfClass:[NSString class]]){
            // confirm that it's an access token
            if ([accessTokenArray[0] isEqualToString:@"access_token"] && [scopeIDArray[0] isEqualToString:@"scope"]){
                accessToken = accessTokenArray[1];
                scopeToken = scopeIDArray[1];
                
                NSLog(@"%s access_token = %@, scope=%@",__func__,accessToken,scopeToken);
                ZBAccessToken = accessToken;
                ZBScopeToken = scopeToken;
                
                [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:ZBACCESSTOKEN_KEY];
                [[NSUserDefaults standardUserDefaults]setObject:scopeToken forKey:ZBSCOPETOKEN_KEY];
            }
            else {
                NSLog(@"Error: attempting to load application without access_token=%@ or scope=%@",accessTokenArray,scopeIDArray);
            }
            
            
        } else {
            NSLog(@"Error: attempting to load application with incorrect URL parameters: %@",urlComponents[0]);
        }
                 
        // note: if something went wrong, don't change the current values (if any) of ZBAccessToken or ZBScopeToken
        
        
    }
    
    
    
    return YES;
}

# pragma mark application launching

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSURL *documentsDirectory = [self applicationDocumentsDirectory];
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:@"BTData"];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    bool fileExists = [[NSFileManager defaultManager] fileExistsAtPath:[url path]];
    
    if(fileExists) {
        [self.document openWithCompletionHandler:^(BOOL success) {
            [self documentIsReady];
        }];
    }
        else {
            [self.document saveToURL:url
                    forSaveOperation:UIDocumentSaveForCreating
                   completionHandler:^(BOOL success) {
                       if(success) { NSLog(@"UI Document is ready for save");
                                          [self documentIsReady];
                                       }
                            else NSLog(@"couldn't get the UI document ready for save at all");
                   }
             ];
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

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BTData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BTData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
// used by CoreDataPro
#if !(TARGET_OS_EMBEDDED)  // This will work for Mac or Simulator but excludes physical iOS devices
    NSLog(@"building for simulator");
//#ifdef DEBUG
    // @(1) is NSSQLiteStoreType
      NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BTData" withExtension:@"momd"];
    NSLog(@"adding coredatapro stuff now");
    [self createCoreDataDebugProjectWithType:@(1) storeUrl:[storeURL absoluteString] modelFilePath:[modelURL absoluteString]];
//#endif
#endif
    
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




@end
