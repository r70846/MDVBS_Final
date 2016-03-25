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
#import <MessageUI/MessageUI.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface SettingsContentController : UIViewController <UIActionSheetDelegate, UITextViewDelegate, UITextFieldDelegate, MFMailComposeViewControllerDelegate>
{
    // Global Data Storage
    DataStore *dataStore;    //shared instance of my DataStore object
    
    
    IBOutlet UISwitch *togTweetComplete;
    IBOutlet UIButton *templateButton;
    IBOutlet UITextField *templateTextDisplay;
    
    UIActionSheet *templateSheet;
    
    //Default email for export
    NSString *defaultEmail;

    //Message Label
    IBOutlet UILabel *messageLabel;
    
    //Email Field
    IBOutlet UITextField *exportEmail;
    
    //Email Button
    IBOutlet UIButton *exportButton;
    
    //Keep track of where I'm coming from - (Tab Bar |or| Email View)
    Boolean bEmailView;
    
    //Retain current account
    ACAccount *currentAccount;
    
}


-(IBAction)chooseTemplate;
-(IBAction)clearSavedData;
-(IBAction)logOut;

@end
