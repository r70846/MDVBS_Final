///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  ViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////


#import <UIKit/UIKit.h>
#import "DataStore.h"
#import "Reachability.h"

@interface ViewController : UIViewController
{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
    
    IBOutlet UIScrollView  *scrollView;

    // Track online status
    Reachability* reach;
}

//Property to hold user topic choice
@property int iDisplayMode;
@property DataStore *dataStore;
@property IBOutlet UILabel *netWorkSign;

-(void)setScrollView;



@end
