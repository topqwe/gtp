//
//  STNoticeScrollView.h
//  GrapeGold
//
//  Created by Mac on 2018/5/2.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class STNewsModel;
/************上下新闻轮播View******************/
@interface STNoticeScrollView : UIView
@property (nonatomic,assign) NSInteger            during;//间隔,默认4

@property (nonatomic,strong) NSArray<STNewsModel*>            *dataSouce;

@property (nonatomic,copy) void(^clicActionHandel)(STNewsModel * model);//点击回调
@end

@interface STNewsModel : NSObject
@property(nonatomic, strong) NSString                     *title;/**< title */
@end
