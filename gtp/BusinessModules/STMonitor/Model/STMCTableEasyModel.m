//
//  STMCTableEasyModel.m
//  STNewTools
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 stoneobs.qq.com. All rights reserved.
//

#import "STMCTableEasyModel.h"

@implementation STMCTableEasyModel
- (instancetype)initWithTextString:(NSString *)textString detailString:(NSString *)detailString
{
    if (self = [super init]) {
        self.detailString = detailString;
        self.textString = textString;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.height = 44;
    }
    return self;
}
- (instancetype)initWithTextString:(NSString*)textString accessoryView:(UIView*)accessoryView;
{
    if (self = [super init]) {
        self.accessoryView = accessoryView;
        self.textString = textString;
        self.accessoryType = UITableViewCellAccessoryNone;
        self.height = 44;
    }
    return self;
    
}
- (instancetype)initWithTextString:(NSString *)textString
detailString:(NSString *)detailString
accessoryType:(UITableViewCellAccessoryType)accessoryType{
    
    if (self = [super init]) {
        self.detailString = detailString;
        self.textString = textString;
        self.accessoryType = accessoryType;
        self.height = 44;
    }
    return self;
    
}
- (instancetype)initWithTextString:(NSString *)textString imageName:(NSString *)imageName{
    if (self = [super init]) {
        
        self.textString = textString;
        self.image   = [UIImage imageNamed:imageName];
        self.height = 44;
    }
    return self;
}
@end
@implementation UITableViewCell(STMCTablyEaseModel)
- (void)setStmc_tableEasyModel:(STMCTableEasyModel*)stmc_tableEasyModel{
    if (stmc_tableEasyModel.accessoryView) {
        self.accessoryView = stmc_tableEasyModel.accessoryView;
    }else{
        self.accessoryType = stmc_tableEasyModel.accessoryType;
    }
    self.imageView.image = stmc_tableEasyModel.image;
    self.textLabel.textColor = STMC_UIColorFromRGBA(0x333333);
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    self.detailTextLabel.textColor = STMC_UIColorFromRGBA(0x999999);
    self.textLabel.text = stmc_tableEasyModel.textString;
    self.detailTextLabel.text = stmc_tableEasyModel.detailString;
}
@end
