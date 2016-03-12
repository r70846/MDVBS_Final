//
//  TagCell.m
//  Woodshed
//
//  Created by Russell Gaspard on 3/11/16.
//  Copyright (c) 2016 Russell Gaspard. All rights reserved.
//

#import "TagCell.h"
#import "DelButton.h"

@implementation TagCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//Call this method to update
-(void)refreshCellWithInfo:(NSString*)tagText valtext:(NSString*)valText{
    tagLabel.text = tagText;
    valueLabel.text = valText;
    
}



@end
