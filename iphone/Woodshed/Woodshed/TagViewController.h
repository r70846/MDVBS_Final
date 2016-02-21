//
//  TagViewController.h
//  Woodshed
//
//  Created by Russell Gaspard on 2/20/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TagViewController : UIViewController
{
    IBOutlet UILabel *topicDisplayLabel;
    
}


//Property to hold user topic choice
@property (nonatomic, strong) NSString *topicString;

@end
