//
//  HistoryViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Run this first load only, not on each new diplay
    _iDisplayMode = 0;
    
    //Setup shared instance of data storage in RAM
    dataStore = [DataStore sharedInstance];
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
