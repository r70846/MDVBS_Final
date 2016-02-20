//
//  ViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//Respond to click event
-(IBAction)onClick:(UIButton *)button
{
    [self performSegueWithIdentifier:@"segueToTabController" sender:self];
}

-(IBAction)logout:(UIStoryboardSegue *)segue
{

}

@end
