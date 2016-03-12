///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  TagCell.h
//  Woodshed
//
//  Created by Russell Gaspard on 3/11/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "DelButton.h"

@interface TagCell : UITableViewCell
{
    IBOutlet UILabel *tagLabel;
    IBOutlet UILabel *valueLabel;
    
}

//Call this method to update
-(void)refreshCellWithInfo:(NSString*)tagText valtext:(NSString*)valText;

@property (nonatomic, strong)IBOutlet DelButton *delButton;

@end
