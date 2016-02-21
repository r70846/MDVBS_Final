//
//  ViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"
#import "DataStore.h"
@interface ViewController : UIViewController
{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
}


//Respond to click event
-(IBAction)onClick:(UIButton *)button;


-(IBAction)logout:(UIStoryboardSegue *)segue;

@end

