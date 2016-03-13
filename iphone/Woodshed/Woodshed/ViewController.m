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
    
    
    [self performSegueWithIdentifier:@"segueToTabController" sender:self];
    
    //Initialize Variables
    mUser = @"";
    mPassword = @"";
    bStayLogged = false;
    
    /// START MILLION ////////////////////////////////////////////////////////////////////
    
    // Allocate a reachability object
    reach = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    //create a week reference to self to avoid ARC retain cycle
    __weak typeof(self) wSelf = self;
    
    // Set the blocks
    reach.reachableBlock = ^(Reachability*reach)
    {
        // keep in mind this is called on a background thread
        // and if you are updating the UI it needs to happen
        // on the main thread, like this:
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"REACHABLE!");
            wSelf.dataStore.isOnline = true;
            if(wSelf.netWorkSign){
                [wSelf.netWorkSign setHidden:YES];
                
                //After control returns, check login
                [wSelf autoLog];
            }
        });
    };
    
    reach.unreachableBlock = ^(Reachability*reach)
    {
        NSLog(@"UNREACHABLE!");
        wSelf.dataStore.isOnline = false;
        if(wSelf.netWorkSign){
            [wSelf.netWorkSign setHidden:NO];
        }
    };
    
    // Start the notifier, which will cause the reachability object to retain itself!
    [reach startNotifier];
    
    /// END MILLION ////////////////////////////////////////////////////////////////////
    

}

- (void)autoLog{
    if([self getChecked]){
        mUser = [self getUser];
        mPassword = [self getPassword];
        txtUserName.text = mUser;
        txtPassword.text = mPassword;
        if([self validInput:mUser sPassword:mPassword]){
            if(dataStore.isOnline){
                [self logIn];
            }
        }
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    
    //txtUserName.text = @"";
    //txtPassword.text = @"";
    
    
     if([self getChecked]){
         [togStayLogged setOn:YES animated:NO];
     }else{
         [togStayLogged  setOn:NO animated:NO];
     }
    
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)getChecked{
    //Built in dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL bStay = false;
    NSString *sStay;
    if(defaults != nil)
    {
        //Get values
        sStay = (NSString*)[defaults objectForKey:@"stay"];
        if([sStay isEqualToString:@"1"]){
            bStay = true;
        }
        
    }
    return bStay;
}


-(NSString*)getUser{
    //Built in dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user = [defaults objectForKey:@"user"];
    return user;
}

-(NSString*)getPassword{
    //Built in dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *password = [defaults objectForKey:@"password"];
    return password;
}

-(IBAction)setChecked{
    //Built in dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(defaults != nil)
    {
        if ([togStayLogged isOn]) {
            [defaults setObject:@"1" forKey:@"stay"];
        }else{
            [defaults setObject:@"0" forKey:@"stay"];
        }
        
        //saves the data
        [defaults synchronize];
        
    }
    
}


-(void)saveCredentials:(NSString*)sUser sPassword:(NSString*)sPassword{
    //Built in dictionary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    //[self setChecked];
    
    if(defaults != nil)
    {
        
        [defaults setObject:sUser forKey:@"user"];
        [defaults setObject:sPassword forKey:@"password"];
        
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
            NSLog(@"Sign Up");
            [self processInput:false sUser:mUser sPassword:mPassword];
            
        }else{
            NSLog(@"Log In");
            [self processInput:true sUser:mUser sPassword:mPassword];
        }
    }
}


-(void)processInput:(BOOL)bLogin sUser:(NSString*)sUser sPassword:(NSString*)sPassword{
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
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            [self setChecked];
            
            // log in success - launch tab view
            if([self getChecked]){
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
    [PFUser logInWithUsernameInBackground:mUser password:mPassword
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            
                                            [self setChecked];
                                            
                                            // log in success - launch list view
                                            if([self getChecked]){
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
    //Logout Parse
    [PFUser logOut];
    PFUser *currentUser = [PFUser currentUser]; // this will now be nil
    currentUser = nil;
    
    //Logout local
    mUser = @"";
    mPassword = @"";
    [self saveCredentials:mUser sPassword:mPassword];
    
    
    txtUserName.text = mUser;
    txtPassword.text = mPassword;
}

@end
