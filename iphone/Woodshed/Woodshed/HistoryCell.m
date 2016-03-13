///////////////////////////////////////////////////
//
// Russ Gaspard
// Full Sail Mobile Development
// Final Project
//
//
//  HistoryCell.m
//  Woodshed
//
//  Created by Russell Gaspard on 3/11/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//
///////////////////////////////////////////////////

#import "HistoryCell.h"
#import "DelButton.h"

@implementation HistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//Call this method to update
-(void)refreshCellWithInfo:(NSString*)topicText dateText:(NSString*)dateText{
    topicLabel.text = topicText;
    dateLabel.text = dateText;
    
}

@end
