//
//  STTableViewDetailController.h
//  ZuoBiao
//
//  Created by stoneobs on 17/2/17.
//  Copyright © 2017年 stoneobs. All rights reserved.
//  tableiview 详情,单个cell和textfiled

#import <UIKit/UIKit.h>
@class STTableViewDetailController;

typedef void(^STTableViewDetailComplete)(NSString * text,STTableViewDetailController * detailControllerVC);
@interface STTableViewDetailController : UIViewController

@property(nonatomic,strong)UITextField                    *textFiled;//可以更改键盘类型 限制输入字符

@property(nonatomic,assign)NSInteger                      maxTextNum;//defult NSUIntegerMax；

@property(nonatomic,strong)NSString                       *rightItemTitle;

@property(nonatomic,strong)UIColor                        *rightItemTitleColor;


- (instancetype)initWithPlaceholder:(NSString*)placeholder
                              title:(NSString*)title
                               text:(NSString*)text
                           complete:(STTableViewDetailComplete) complete;
@end
