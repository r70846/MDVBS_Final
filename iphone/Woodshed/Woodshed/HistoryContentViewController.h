//
//  HistoryContentViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/22/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"

@interface HistoryContentViewController : UIViewController
{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
    
    //Reference to data tables
    IBOutlet  UITableView *historyTableView;
    IBOutlet  UITableView *detailTableView;
    
}

//Respond to click event
-(IBAction)onClick:(UIButton *)button;

@end
