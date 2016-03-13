///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  AppDelegate.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DataStore.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
}
@property (strong, nonatomic) UIWindow *window;


@end

