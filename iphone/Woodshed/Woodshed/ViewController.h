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

@interface ViewController : UIViewController
{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
    
    IBOutlet UIScrollView  *scrollView;
}

//Property to hold user topic choice
@property int iDisplayMode;


-(void)setScrollView;



@end
