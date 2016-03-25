///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  NewViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/25/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "NotesCell.h"
#import "DataStore.h"

@interface NewViewController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate>

{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
    
    IBOutlet UITextField *txtInput;
    IBOutlet UILabel *labelSource;
    IBOutlet  UITableView *notesTableView;
    IBOutlet UIView *tableHolder;
    
    NSMutableArray *notesArray;
}

//Property to hold user input
@property NSString *input;

//Property to hold source screen
@property NSString *source;

//Respond to click event
-(IBAction)onClick:(UIButton *)button;




@end
