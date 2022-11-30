//
//  NetworkingErrorView.h
//  PPOYang
//
//  Created by Tgs on 2017/4/20.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkingErrorView : UIView
@property(nonatomic,strong)UIImageView *imgView;
@property(nonatomic,strong)UIButton *refushBnt;
@property(nonatomic,strong)UILabel *tit00;
@property(nonatomic,strong)UILabel *tit01;

//type 0-网络错误信息 1-系统繁忙
-(void)setNetWorkingDetialWith:(NSInteger)type;
@end
