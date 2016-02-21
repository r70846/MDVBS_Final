//
//  PracticeContentViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PracticeContentViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    
    //Reference to topic table
    IBOutlet  UITableView *topicTableView;
    
    IBOutlet UILabel *topicDisplayLabel;
    
    IBOutlet  UITableView *tagTableView;
    
    
    //Static Data
    NSMutableArray *topicArray;
    
    //Static Data
    NSMutableArray *tagArray;
    
}


//Respond to click event
-(IBAction)onClick:(UIButton *)button;


@end
