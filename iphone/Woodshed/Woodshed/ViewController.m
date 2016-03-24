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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:0.89 blue:0.631 alpha:1]]; ; /*#ffe3a1*/
    [self.view setBackgroundColor:[UIColor colorWithRed:0.561 green:0.635 blue:0.655 alpha:1]];  /*#8fa2a7*/
    
    //Run this first load only, not on each new diplay
    if([self autoLog]){
        _iDisplayMode = 600;
    }else{
        _iDisplayMode = 0;
    }

    
    //Setup shared instance of data storage in RAM
    dataStore = [DataStore sharedInstance];
    
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    //int iWidth = [[UIScreen mainScreen] bounds].size.width;
    //int iHeight = [[UIScreen mainScreen] bounds].size.height;
    //scrollView.contentSize=CGSizeMake(iWidth,1200);
    //scrollView.contentSize=CGSizeMake(iWidth,iHeight);
    
    
    [scrollView setContentOffset:CGPointMake(0, _iDisplayMode) animated:NO];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    //Keep the scoll where we want it. No user scroll !
    [aScrollView setContentOffset: CGPointMake(0, _iDisplayMode)];
}


-(void)setScrollView{
    
    [scrollView setContentOffset:CGPointMake(0, _iDisplayMode) animated:NO];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)autoLog{
    BOOL bResult = false;
    NSLog(@"auto logging");
    if([self getChecked]){
        NSString *sUser = [self getUser];
        NSString *sPassword = [self getPassword];
        if([self validInput:sUser sPassword:sPassword]){
            bResult = true;
        }
    }
    return bResult;
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

-(BOOL)validInput:(NSString*)sUser sPassword:(NSString*)sPassword{
    Boolean bValid = false;
    if (sUser.length > 0 && sPassword.length > 0){
        bValid = true;
    }
    return bValid;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end