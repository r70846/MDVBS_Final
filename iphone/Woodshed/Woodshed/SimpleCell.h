///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  SimpleCell.h
//  Woodshed
//
//  Created by Russell Gaspard on 3/11/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "DelButton.h"

@interface SimpleCell : UITableViewCell
{

}

@property (nonatomic, strong)IBOutlet DelButton *delButton;
@property (nonatomic, strong)IBOutlet UILabel *displayText;

@end
