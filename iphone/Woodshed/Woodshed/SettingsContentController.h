//
//  SettingsContentController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"
#import "DataStore.h"
@interface SettingsContentController : UIViewController
{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
}
@end
