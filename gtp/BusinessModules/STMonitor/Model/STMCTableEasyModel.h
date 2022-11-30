//
//  STMCTableEasyModel.h
//  STNewTools
//
//  Created by Mac on 2018/7/18.
//  Copyright © 2018年 stoneobs.qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "STMonitorHeader.h"
@interface STMCTableEasyModel : NSObject
@property(nonatomic, assign) CGFloat                     height;//默认44；

@property(nonatomic, strong) UIImage                     *image;

@property(nonatomic,strong)NSString                     *detailString;

@property(nonatomic,strong)NSString                     *textString;

@property (nonatomic)UITableViewCellAccessoryType       accessoryType;

@property(nonatomic,assign)bool                         isSlected;


@property(nonatomic,strong)NSIndexPath                  *indexPath;

@property(nonatomic,strong)UIView                       *accessoryView;

- (instancetype)initWithTextString:(NSString*)textString detailString:(NSString*)detailString;
- (instancetype)initWithTextString:(NSString*)textString imageName:(NSString*)imageName;

- (instancetype)initWithTextString:(NSString*)textString accessoryView:(UIView*)accessoryView;
- (instancetype)initWithTextString:(NSString*)textString
                      detailString:(NSString*)detailString
                     accessoryType:(UITableViewCellAccessoryType)accessoryType;
@end
@interface UITableViewCell(STMCTablyEaseModel)
- (void)setStmc_tableEasyModel:(STMCTableEasyModel*)stmc_tableEasyModel;
@end
