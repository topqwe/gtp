//
//  STTableEasyModel.m
//  GodHorses
//
//  Created by Mac on 2017/11/25.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STTableEasyModel.h"

@implementation STTableEasyModel
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
@implementation UITableViewCell(STTablyEaseModel)
- (void)setSt_tableEasyModel:(STTableEasyModel*)st_tableEasyModel{
    if (st_tableEasyModel.accessoryView) {
        self.accessoryView = st_tableEasyModel.accessoryView;
    }else{
        self.accessoryView = nil;
        self.accessoryType = st_tableEasyModel.accessoryType;
//        if (st_tableEasyModel.accessoryType == UITableViewCellAccessoryDisclosureIndicator) {
//            UIImageView * moreimageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 9, 15)];
//            moreimageView.image = [UIImage imageNamed:@"ic_arrow_right_brown"];
//            self.accessoryView = moreimageView;
//        }
    }
    self.imageView.image = st_tableEasyModel.image;
    self.textLabel.textColor = UIColorFromRGBA(0x333333);
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.detailTextLabel.font = [UIFont systemFontOfSize:13];
    self.detailTextLabel.textColor = UIColorFromRGBA(0x999999);
    self.textLabel.text = st_tableEasyModel.textString;
    self.detailTextLabel.text = st_tableEasyModel.detailString;
}
@end
