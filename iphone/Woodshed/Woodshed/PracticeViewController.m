//
//  PracticeViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import "PracticeViewController.h"

@interface PracticeViewController ()

@end

@implementation PracticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Setup shared instance of data storage in RAM
    dataStore = [DataStore sharedInstance];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    int iWidth = [[UIScreen mainScreen] bounds].size.width;
    //int iHeight = [[UIScreen mainScreen] bounds].size.height;
    scrollView.contentSize=CGSizeMake(iWidth,1200);
    
    _iDisplayMode = 0;
    
    [scrollView setContentOffset:CGPointMake(0, _iDisplayMode) animated:NO];
}

- (void)scrollViewDidScroll:(UIScrollView *)aScrollView
{
    
    //Keep the scoll where we want it. No user scroll !
    [aScrollView setContentOffset: CGPointMake(0, _iDisplayMode)];
}


-(void)setScrollView{

    [scrollView setContentOffset:CGPointMake(0, _iDisplayMode) animated:YES];
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
