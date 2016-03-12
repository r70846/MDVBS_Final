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
    
    //DATA STORAGE
    //DataStore *dataStore;    //shared instance of my data store object
    
    //IBOutlet UILabel *netWorkSign;
    
    IBOutlet UISwitch *togStayLogged;
    IBOutlet UITextField *txtUserName;
    IBOutlet UITextField *txtPassword;
    IBOutlet UIButton *btnLogin;
    IBOutlet UIButton *btnSignUp;
    
    NSString *mUser;
    NSString *mPassword;
    BOOL bStayLogged;
    Reachability* reach;
    
}

//Use properties instead of variables to reference from 'self' or wSelf

//shared instance of my data store object as 'weak' property
@property DataStore *dataStore;

@property IBOutlet UILabel *netWorkSign;

-(IBAction)onClick:(UIButton *)button;
-(IBAction)setChecked;

-(void)signUp;
-(void)logIn;


-(BOOL)getChecked;
-(NSString*)getUser;


-(BOOL)validInput:(NSString*)sUser sPassword:(NSString*)sPassword;

-(void)processInput:(BOOL)bLogin sUser:(NSString*)sUser sPassword:(NSString*)sPassword;

-(void)saveCredentials:(NSString*)sUser sPassword:(NSString*)sPassword;

-(IBAction)logout:(UIStoryboardSegue *)segue;

@end

