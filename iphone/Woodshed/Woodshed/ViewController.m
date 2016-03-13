///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  ViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize dataStore;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:0.89 blue:0.631 alpha:1]]; /*#ffe3a1*/
    [self.view setBackgroundColor:[UIColor colorWithRed:0.561 green:0.635 blue:0.655 alpha:1]];  /*#8fa2a7*/
    
    //setup shared instance of data storage in RAM
    dataStore = [DataStore sharedInstance];
    

}

- (void)viewWillAppear:(BOOL)animated {
     if(dataStore.stay){
         [togStayLogged setOn:YES animated:NO];
     }else{
         [togStayLogged  setOn:NO animated:NO];
     }

    //Initialize Variables
    mUser = @"";
    mPassword = @"";
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)setChecked{
    //Built in dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(defaults != nil)
    {
        if ([togStayLogged isOn]) {
            [defaults setObject:@"1" forKey:@"stay"];
            dataStore.stay = true;
        }else{
            [defaults setObject:@"0" forKey:@"stay"];
            dataStore.stay = false;
        }
        
        //saves the data
        [defaults synchronize];
        
    }
    
}

-(void)saveCredentials:(NSString*)sUser sPassword:(NSString*)sPassword{
    //Built in dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(defaults != nil)
    {
        
        [defaults setObject:sUser forKey:@"user"];
        [defaults setObject:sPassword forKey:@"password"];
        [defaults setObject:@"1" forKey:@"success"];
        //saves the data
        [defaults synchronize];
    }
}

-(BOOL)validInput:(NSString*)sUser sPassword:(NSString*)sPassword{
    Boolean bValid = false;
    if (sUser.length > 0 && sPassword.length > 0){
        bValid = true;
    }
    return bValid;
}

-(IBAction)onClick:(UIButton *)button
{
    
    UIButton *btn = (UIButton*)button;
    int tag = (int)btn.tag;
    
    mUser = txtUserName.text;
    mPassword = txtPassword.text;

    if([self validInput:mUser sPassword:mPassword]){
        if(tag == 0){
            //NSLog(@"Sign Up");
            [self processInput:false sUser:mUser sPassword:mPassword];
            
        }else{
           // NSLog(@"Log In");
            [self processInput:true sUser:mUser sPassword:mPassword];
        }
    }
}


-(void)processInput:(BOOL)bLogin sUser:(NSString*)sUser sPassword:(NSString*)sPassword{
    
    NSLog(@"process Input: user=%@ pw=%@ online=%d" , mUser, mPassword, dataStore.isOnline);
    if(dataStore.isOnline){
        if(bLogin){
            [self logIn];
        }else{
            [self signUp];
        }
    }
}



-(void)signUp {
    
    
    PFUser *user = [PFUser user];
    user.username = mUser;
    user.password = mPassword;

                NSLog(@"Sign Up Function");
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            [self setChecked];
            
            // log in success - launch tab view
            if(dataStore.stay){
                [self saveCredentials:mUser sPassword:mPassword];
            }
            
            // sign up success - launch tab view
            [self performSegueWithIdentifier:@"segueToTabController" sender:self];
        } else {
            // Show error
            NSString *strError = [error userInfo][@"error"];
            NSLog(@"%@", strError);
        }
    }];
}


-(void)logIn
{
    
    NSLog(@"Log In Function");
    [PFUser logInWithUsernameInBackground:mUser password:mPassword
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            
                                            [self setChecked];
                                            
                                            // log in success - launch list view
                                            if(dataStore.stay){
                                                [self saveCredentials:mUser sPassword:mPassword];
                                            }
                                            [self performSegueWithIdentifier:@"segueToTabController" sender:self];
                                        } else {
                                            // Show error
                                            NSString *strError = [error userInfo][@"error"];
                                            NSLog(@"%@", strError);
                                            
                                        }
                                    }];
}


-(IBAction)logout:(UIStoryboardSegue *)segue
{

}

@end
