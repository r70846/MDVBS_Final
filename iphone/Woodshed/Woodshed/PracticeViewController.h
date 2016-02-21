//
//  PracticeViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PracticeViewController : UIViewController
{
    IBOutlet UIScrollView  *scrollView;
    
    //int iDisplayMode;
}

//Property to hold user topic choice
@property int iDisplayMode;


-(void)setScrollView;



@end
