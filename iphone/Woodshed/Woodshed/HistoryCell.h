///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  HistoryCell.h
//  Woodshed
//
//  Created by Russell Gaspard on 3/11/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import <UIKit/UIKit.h>
#import "DelButton.h"

@interface HistoryCell : UITableViewCell
{
IBOutlet UILabel *topicLabel;
IBOutlet UILabel *dateLabel;

}

//Call this method to update
-(void)refreshCellWithInfo:(NSString*)topicText dateText:(NSString*)dateText;

@property (nonatomic, strong)IBOutlet DelButton *delButton;

@end