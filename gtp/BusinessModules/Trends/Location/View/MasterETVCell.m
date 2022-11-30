//
//  MasterETVCell.m
//  TestDemo
//
//  Created by WIQChen on 16/3/1.
//  Copyright © 2016年 WIQChen. All rights reserved.
//

#import "MasterETVCell.h"

@implementation MasterETVCell

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:NO];
//    
//    if (selected ) {
//        self.contentView.backgroundColor = PHWhiteColor;
//    } else {
//        self.contentView.backgroundColor = PHWhiteColor;
//    }
//}
//- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setSelected:highlighted animated:NO];
//    
//    if (highlighted ) {
//        self.contentView.backgroundColor = PHWhiteColor;
//    } else {
//        self.contentView.backgroundColor = PHWhiteColor;
//    }
//}
+ (instancetype)itsCellWithTableView:(UITableView *)tableView
{
    static NSString *reuseID = @"MasterETVCell";
    MasterETVCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    if (!cell) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"MasterETVCell" owner:nil options:nil][0];
    }
    return cell;
}
- (void)richElementsInCellWithListData:(NSString*)listModel{
    self.titleLabel.text = listModel;
    
}
@end
