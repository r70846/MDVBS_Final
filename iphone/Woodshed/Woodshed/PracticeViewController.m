///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  PracticeViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import "PracticeViewController.h"

@interface PracticeViewController ()

@end

@implementation PracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:1 green:0.89 blue:0.631 alpha:1]]; ; /*#ffe3a1*/
    [self.view setBackgroundColor:[UIColor colorWithRed:0.561 green:0.635 blue:0.655 alpha:1]];  /*#8fa2a7*/
    
    //Run this first load only, not on each new diplay
    _iDisplayMode = 0;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
