//
//  NetworkingErrorView.m
//  PPOYang
//
//  Created by Tgs on 2017/4/20.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "NetworkingErrorView.h"

@implementation NetworkingErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
        self.backgroundColor =
        HEXCOLOR(0xf3f4f5);
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(MAINSCREEN_WIDTH/2-90, 130, 180, 76)];
        [self addSubview:self.imgView];

        self.tit00 = [[UILabel alloc]initWithFrame:CGRectMake(MAINSCREEN_WIDTH/2-100, CGRectGetMaxY(self.imgView.frame)+20, 200, 25)];
        self.tit00.textAlignment = NSTextAlignmentCenter;
        self.tit00.textColor = RGBCOLOR(35, 35, 35);
        self.tit00.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.tit00];
        
        self.tit01 = [[UILabel alloc]initWithFrame:CGRectMake(MAINSCREEN_WIDTH/2-100, CGRectGetMaxY(self.tit00.frame), 200, 25)];
        self.tit01.textAlignment = NSTextAlignmentCenter;
        self.tit01.textColor = RGBCOLOR(135, 135, 135);
        self.tit01.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.tit01];
        
        self.refushBnt = [UIButton buttonWithType:UIButtonTypeCustom];
        self.refushBnt.frame = CGRectMake(MAINSCREEN_WIDTH/2-120, CGRectGetMaxY(self.tit01.frame)+25, 240, 44);
        [self.refushBnt setTitleColor: HEXCOLOR(0xffaa1c) forState:UIControlStateNormal];
        [self.refushBnt setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateHighlighted];

        [self.refushBnt.layer setCornerRadius:5];
        [self.refushBnt.layer setBorderWidth:0.5];
        [self.refushBnt.layer setBorderColor:[ HEXCOLOR(0xffaa1c) CGColor]];
        self.refushBnt.backgroundColor = [UIColor clearColor];
        self.refushBnt.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.refushBnt];
    }
    return self;
}

-(void)setNetWorkingDetialWith:(NSInteger)type{
    if (type==0) {
        self.imgView.image = [UIImage imageNamed:@"no_network"];
        self.tit00.text = @"网络连接异常";
        self.tit01.text = @"别紧张，试试看刷新页面";
        self.refushBnt.frame = CGRectMake(MAINSCREEN_WIDTH/2-120, CGRectGetMaxY(self.tit01.frame)+25, 240, 44);
        [self.refushBnt setTitle:@"重新加载" forState:UIControlStateNormal];
    }else if (type==1){
        self.imgView.image = [UIImage imageNamed:@"system_busy"];
        self.tit00.text = @"系统正忙，稍后再试";
        self.tit01.text = @"耽误您的时间，我们深表歉意";
        self.refushBnt.frame = CGRectMake(MAINSCREEN_WIDTH/2-60, CGRectGetMaxY(self.tit01.frame)+25, 120, 44);
        [self.refushBnt setTitle:@"刷新" forState:UIControlStateNormal];
    }
}
@end
