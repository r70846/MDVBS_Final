//
//  LoginViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 3/22/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize dataStore;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:0.89 blue:0.631 alpha:1]]; /*#ffe3a1*/
    [self.view setBackgroundColor:[UIColor colorWithRed:0.561 green:0.635 blue:0.655 alpha:1]];  /*#8fa2a7*/
    
    //setup shared instance of data storage in RAM
    dataStore = [DataStore sharedInstance];
    
    // Only needed on waiting screen...,
    [activityIndicator startAnimating];
    
    dataStore.isOnline = false;
    [self startNetworkCheck];
    
    [self autoLog];
    
}


-(void)startNetworkCheck{
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
}

- (void)viewWillAppear:(BOOL)animated {
    if([self getChecked]){
        [togStayLogged setOn:YES animated:NO];
    }else{
        [togStayLogged  setOn:NO animated:NO];
    }
    
    //Initialize Variables
    if(! dataStore.stay){
        mUser = @"";
        mPassword = @"";
    }
    
    [super viewWillAppear:animated];
}

- (void)autoLog{
    NSLog(@"auto logging");
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
    dataStore.stay = bStay;
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
    if(dataStore.isOnline){
        if([self validInput:mUser sPassword:mPassword]){
            if(tag == 0){
                //NSLog(@"Sign Up");
                [self processInput:false sUser:mUser sPassword:mPassword];
            }else{
                // NSLog(@"Log In");
                [self processInput:true sUser:mUser sPassword:mPassword];
            }
        }else{
            messageLabel.text = @"user name & password required";
            
        }
    }else{
        messageLabel.text = @"network connection required";
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
            
            [self newUser];
            
            // sign up success - launch tab view
            //[self performSegueWithIdentifier:@"segueToTabController" sender:self];
        } else {
            // Show error
            NSString *sError = [error userInfo][@"error"];
            NSLog(@"%@", sError);
            messageLabel.text = sError;
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
                                            NSLog(@"logged in made it here...");
                                            [self returnUser];
                                            //[self performSegueWithIdentifier:@"segueToTabController" sender:self];
                                        } else {
                                            NSString *sError = [error userInfo][@"error"];
                                            NSLog(@"%@", sError);
                                            messageLabel.text = sError;
                                            [self backToTop];
                                        }
                                    }];
}


-(IBAction)onChange{
    messageLabel.text = @"";
}


-(void)backToTop{
    //Scroll to tag screen
    ViewController *viewViewController = (ViewController*) self.parentViewController;
    viewViewController.iDisplayMode = 0;
    [viewViewController setScrollView];
}

-(IBAction)logout:(UIStoryboardSegue *)segue
{
    
}

/////////////////  LOAD USER DATA ////////////
/////////////////  NEW USER SETUP
-(void)returnUser{
    PFUser *user = [PFUser currentUser];
    user.ACL = [PFACL ACLWithUser:user];
    [PFACL setDefaultACL:[PFACL ACL] withAccessForCurrentUser:YES];
    [self loadUserKeys];
}

-(void)loadUserKeys{
    
    PFQuery *query = [PFQuery queryWithClassName:@"KeyData"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            if(objects.count > 0){
                //PFObject *topicData = [objects objectAtIndex:objects.count];
                PFObject *keyData = [objects objectAtIndex:0];
                dataStore.parseObjects[@"keyData"] = keyData;
                dataStore.userKeys = (NSMutableDictionary*)keyData[@"KeyData"];
                [self loadTopics];
            }else{
                messageLabel.text = @"Record Retrieval Error";
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

-(void)loadTopics{
    PFQuery *query = [PFQuery queryWithClassName:@"TopicData"];
    [query getObjectInBackgroundWithId:dataStore.userKeys[@"topics"] block:^(PFObject *topicData, NSError *error) {
        if (!error) {
            // The find succeeded.
            dataStore.parseObjects[@"topicData"] = topicData;
            dataStore.topicData = (NSMutableDictionary*)topicData[@"topicData"];
            
            dataStore.topicArray = (NSMutableArray*)[dataStore.topicData allKeys];
            dataStore.topicArray = (NSMutableArray*)[dataStore.topicArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            [self loadTags];
        } else {
            // Log details of the failure
            NSLog(@"Error loading topics: %@", error.description);
        }
    }];
}

-(void)loadTags{
    PFQuery *query = [PFQuery queryWithClassName:@"TagData"];
    [query getObjectInBackgroundWithId:dataStore.userKeys[@"tags"] block:^(PFObject *tagData, NSError *error) {
        if (!error) {
            // The find succeeded.
            //dataStore.parseObjects[@"tagData"] = tagData;
            dataStore.tagData = (NSMutableDictionary*)tagData[@"tagData"];
            [dataStore addTagsFromTemplate];
            
            dataStore.tagArray = (NSMutableArray*)[dataStore.tagData allKeys];
            dataStore.tagArray = (NSMutableArray*)[dataStore.tagArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            [self loadSessions];
        } else {
            // Log details of the failure
            NSLog(@"Error loading tags: %@", error.description);
        }
    }];
}

-(void)loadSessions{
    
    PFQuery *query = [PFQuery queryWithClassName:@"SessionData"];
    [query getObjectInBackgroundWithId:dataStore.userKeys[@"sessions"] block:^(PFObject *sessionData, NSError *error) {
        if (!error) {
            // The find succeeded.
            //dataStore.parseObjects[@"sessionData"] = sessionData;
            dataStore.sessions = (NSMutableArray*)sessionData[@"sessionData"];
            [self performSegueWithIdentifier:@"segueToTabController" sender:self];
        } else {
            // Log details of the failure
            NSLog(@"Error from topics by ID: %@ %@", error, [error userInfo]);
        }
    }];
}
/////////////////  NEW USER SETUP
-(void)newUser{
    PFUser *user = [PFUser currentUser];
    user.ACL = [PFACL ACLWithUser:user];
    [PFACL setDefaultACL:[PFACL ACL] withAccessForCurrentUser:YES];
    [self saveDefaultTopics];
}

-(void)saveDefaultTopics
{
    PFObject *topicData = [PFObject objectWithClassName:@"TopicData"];
    topicData[@"topicData"] = [dataStore getDefaultTopics];
    dataStore.parseObjects[@"topicData"] = topicData;
    [topicData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            dataStore.topicData = (NSMutableDictionary*)topicData[@"topicData"];
            
            dataStore.topicArray = (NSMutableArray*)[dataStore.topicData allKeys];
            dataStore.topicArray = (NSMutableArray*)[dataStore.topicArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            dataStore.userKeys[@"topics"] = topicData.objectId;
            [self saveDefaultTags];
        } else {
            // There was a problem, check error.description
            NSLog (@"Parse error saving default topics:%@", error.description);
        }
    }];
}

-(void)saveDefaultTags
{
    PFObject *tagData = [PFObject objectWithClassName:@"TagData"];
    tagData[@"tagData"] = [dataStore getDefaultTags];
    //dataStore.parseObjects[@"tagData"] = tagData;
    [tagData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            dataStore.userKeys[@"tags"] = tagData.objectId;
            dataStore.userKeys[@"template"] = @"none";
            dataStore.tagData = (NSMutableDictionary*)tagData[@"tagData"];
            [dataStore addTagsFromTemplate];
            
            dataStore.tagArray = (NSMutableArray*)[dataStore.tagData allKeys];
            dataStore.tagArray = (NSMutableArray*)[dataStore.tagArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
            
            [self saveEmptySessions];
        } else {
            // There was a problem, check error.description
            NSLog (@"Parse error saving defailt tags:%@", error.description);
        }
    }];
}

-(void)saveEmptySessions{
    PFObject *sessionData = [PFObject objectWithClassName:@"SessionData"];
    NSMutableArray *sessions = [[NSMutableArray alloc] init];
    sessionData[@"sessionData"] = sessions;
    //dataStore.parseObjects[@"sessionData"] = sessionData;
    [sessionData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            dataStore.userKeys[@"sessions"] = sessionData.objectId;
            dataStore.sessions = (NSMutableArray*)sessionData[@"sessionData"];
            [self saveNewUserKeys];
        } else {
            // There was a problem, check error.description
            NSLog (@"Parse error saving empty sessions:%@", error.description);
        }
    }];
}

-(void)saveNewUserKeys{
    PFObject *keyData = [PFObject objectWithClassName:@"KeyData"];
    dataStore.userKeys[@"email"] = @"";
    dataStore.userKeys[@"template"] = @"[ Tag Templates ]";
    dataStore.userKeys[@"tweet"] = @"0";
    keyData[@"KeyData"] = dataStore.userKeys;
    [keyData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            dataStore.userKeys[@"key"] = keyData.objectId;
            //dataStore.parseObjects[@"keyData"] = keyData;
            [keyData saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    [self performSegueWithIdentifier:@"segueToTabController" sender:self];
                } else {
                    // There was a problem, check error.description
                    NSLog (@"Parse error saving empty sessions:%@", error.description);
                }
            }];
        } else {
            // There was a problem, check error.description
            NSLog (@"Parse error saving empty sessions:%@", error.description);
        }
    }];
}


@end
