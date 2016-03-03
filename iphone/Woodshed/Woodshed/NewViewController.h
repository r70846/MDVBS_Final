//
//  NewViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/25/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewViewController : UIViewController
{
    IBOutlet UITextField *txtInput;
    IBOutlet UILabel *labelSource;
}

//Property to hold user input
@property NSString *input;

//Property to hold source screen
@property NSString *source;


//Respond to click event
-(IBAction)onClick:(UIButton *)button;

@end
