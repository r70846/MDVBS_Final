///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  AppDelegate.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    // Parse Code //////////////////
    
    // Override point for customization after application launch.
    [Parse enableLocalDatastore];
    
    [Parse setApplicationId:@"MiZ7FTraoO7lVpUdDeSiqNcXehakCZMALPAkeDo9"
                  clientKey:@"j2mabIIedxKzK2OGALZxeP5zxBCWHni8egPE2fTw"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    // Defaults Code //////////////////
    
    //Setup shared instance of data storage in RAM
    dataStore = [DataStore sharedInstance];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if(defaults != nil)
    {
        dataStore.user = [defaults objectForKey:@"user"];
        dataStore.password = [defaults objectForKey:@"password"];
        NSString *stay = (NSString*)[defaults objectForKey:@"stay"];
        if([stay isEqualToString:@"1"]){
            dataStore.stay = true;
        }else{
            dataStore.stay = false;
        }
        NSString *success = (NSString*)[defaults objectForKey:@"success"];
        if([success isEqualToString:@"1"]){
            dataStore.success = true;
        }else{
            dataStore.success = false;
        }
    }


    // Launch Code //////////////////
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController;
 

    if(dataStore.stay && dataStore.success){
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
        [PFUser logInWithUsernameInBackground:dataStore.user password:dataStore.password
                                        block:^(PFUser *user, NSError *error) {
                                            if (user) {
                                            } else {
                                                // Show error
                                                NSString *strError = [error userInfo][@"error"];
                                                NSLog(@"Login error from app delegate: %@", strError);
                                            }
                                        }];
        
        
        
    }else{
        viewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
    }
    
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(BOOL)isStayLogged{
    //Built in dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL bStay = false;
    NSString *sStay;
    if(defaults != nil)
    {
        //Get values
        sStay = (NSString*)[defaults objectForKey:@"stay"];
        if([sStay isEqualToString:@"1"]){
            bStay = true;
        }
        
    }
    return bStay;
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
