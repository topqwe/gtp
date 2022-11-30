//
//  STAreaHeaderView.h
//  SportHome
//
//  Created by stoneobs on 16/11/15.
//  Copyright © 2016年 zhaowei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^STAreaHeaderViewBlock)(NSString * chosedTitle);
@interface STAreaHeaderView : UIView
@property(nonatomic, strong) NSArray            *hotNameArray;//字符串array
@property(nonatomic, strong) NSString           *currenrLocationAddress;//当前地址
@property(nonatomic,copy)STAreaHeaderViewBlock block;
@end
