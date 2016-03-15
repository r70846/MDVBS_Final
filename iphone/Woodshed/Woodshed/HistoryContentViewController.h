///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  HistoryContentViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/22/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "DataStore.h"
#import "HistoryCell.h"
#import "TagCell.h"
#import "DelButton.h"

@interface HistoryContentViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate>

{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
    
    //Reference to data tables
    IBOutlet  UITableView *historyTableView;
    IBOutlet  UITableView *detailTableView;
    
    IBOutlet UILabel *topicDisplayLabel;
    IBOutlet UILabel *dateTimeDisplayLabel;
    
    // Data Editing
    IBOutlet UIButton *historyEditButton;
    
    
    NSMutableArray *sessions;
    NSMutableDictionary *lookupTable;
    
    
    NSMutableArray *filterArray;
    NSMutableArray *sortArray;
    UIActionSheet *filterActionSheet;
    UIActionSheet *sortActionSheet;
    
    //Session chosen by user to display from history
    NSMutableDictionary *detailSession;
    
    NSMutableArray *tagArray;
    NSMutableArray *valueArray;
    
}

//Respond to click event
-(IBAction)onClick:(UIButton *)button;
-(IBAction)editMode:(UIButton *)button;

@end
