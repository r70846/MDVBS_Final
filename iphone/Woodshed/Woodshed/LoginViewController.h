///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  LoginViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "DataStore.h"
#import "Reachability.h"
#import <Parse/Parse.h>
#import "Reachability.h"
#import "ViewController.h"

@interface LoginViewController : UIViewController
{
    
    
    
    IBOutlet UISwitch *togStayLogged;
    IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnSignUp;
    IBOutlet UILabel *messageLabel;
    
    IBOutlet UIActivityIndicatorView *activityIndicator;
    

    NSString *mUser;
    NSString *mPassword;
    
    // Track online status
    Reachability* reach;
}

//Use properties instead of variables to reference from 'self' or wSelf

//shared instance of my data store object as 'weak' property

@property DataStore *dataStore;

@property IBOutlet UILabel *netWorkSign;

-(IBAction)onClick:(UIButton *)button;
-(IBAction)setChecked;
-(IBAction)onChange;


-(void)signUp;
-(void)logIn;

-(BOOL)validInput:(NSString*)sUser sPassword:(NSString*)sPassword;

-(void)processInput:(BOOL)bLogin sUser:(NSString*)sUser sPassword:(NSString*)sPassword;

-(void)saveCredentials:(NSString*)sUser sPassword:(NSString*)sPassword;

-(IBAction)logout:(UIStoryboardSegue *)segue;

@end