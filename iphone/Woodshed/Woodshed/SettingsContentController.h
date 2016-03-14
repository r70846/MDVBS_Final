///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  SettingsContentController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "DataStore.h"
#import "DataStore.h"
@interface SettingsContentController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate>
{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
    
    
    IBOutlet UISwitch *togTweetComplete;
    IBOutlet UIButton *templateButton;
    IBOutlet UITextField *templateTextDisplay;
    
    UIActionSheet *templateSheet;
}


-(IBAction)chooseTemplate;
-(IBAction)clearSavedData;
-(IBAction)logOut;

@end
