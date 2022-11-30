//
//  STMenuControl.h
//  blanket
//
//  Created by Mac on 2017/12/5.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/************上imageView下title 建议高度80******************/
@interface STMenuControl : UIControl
@property(nonatomic, strong) UIImageView                     *imageButton;
@property(nonatomic, strong) UILabel                      *titleLable;
@property(nonatomic, copy) void(^onSelctedControl)(STMenuControl* control);
- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(NSString*)imageName
                        title:(NSString*)title
                   titleColor:(UIColor*)titleColor;
@end
