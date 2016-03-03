//
//  NewViewController.m
//  Woodshed
//
//  Created by Russell Gaspard on 2/25/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import "NewViewController.h"

@interface NewViewController ()

@end

@implementation NewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *newItem = [NSString stringWithFormat:@"New %@", _source];
    labelSource.text = newItem;
        
    [txtInput becomeFirstResponder];
}




-(IBAction)onClick:(UIButton *)button
{
    
    //int tag = (int)button.tag;
    
    _input = txtInput.text;
    NSLog(@"%@", _input);
    [self performSegueWithIdentifier:@"unwindFromNewInput" sender:self];
    
    
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
