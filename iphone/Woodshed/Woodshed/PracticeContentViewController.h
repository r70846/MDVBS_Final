//
//  PracticeContentViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataStore.h"

@interface PracticeContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
    
    //Reference to data tables
    IBOutlet  UITableView *topicTableView;
    IBOutlet  UITableView *tagTableView;
    IBOutlet  UITableView *valueTableView;
    
    
    IBOutlet UILabel *topicDisplayLabel;
    IBOutlet UILabel *topicDisplayLabelTwo;
    IBOutlet UILabel *tagDisplayLabel;
    
    
    //Data Holders
    NSMutableArray *topicArray;
    NSArray *tagArray;
    NSMutableArray *valueArray;
    NSString *currentTag;
    
}


//Respond to click event
-(IBAction)onClick:(UIButton *)button;


@end
