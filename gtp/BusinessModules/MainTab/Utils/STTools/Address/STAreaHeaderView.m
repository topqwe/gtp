//
//  STAreaHeaderView.m
//  SportHome
//
//  Created by stoneobs on 16/11/15.
//  Copyright © 2016年 zhaowei. All rights reserved.
//

#import "STAreaHeaderView.h"
@interface STAreaHeaderView()
@property(nonatomic,strong) STLabel     *hotLabel;
@property(nonatomic,strong) STButton *nowCityButton;
@end
@implementation STAreaHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}
- (void)initSubviews{
    __weak typeof(self) weakSelf = self;
    CGFloat butWith = (SCREEN_WIDTH-90)/4;
    STLabel * nowCity = [[STLabel alloc]
                         initWithFrame:CGRectMake(17.5, 15, butWith, 15)
                         text:@"当前地址:"
                         textColor:SecendTextColor
                         font:15
                         isSizetoFit:NO
                         textAlignment:NSTextAlignmentLeft];
    [self addSubview:nowCity];
    _nowCityButton =
    [[STButton alloc] initWithFrame:CGRectMake(17.7, nowCity.bottom+10, butWith, 25)
                              title:@"成都"
                         titleColor:FirstTextColor
                          titleFont:15
                       cornerRadius:2
                    backgroundColor:[UIColor whiteColor]
                    backgroundImage:nil
                              image:[UIImage imageNamed:@"btn_adress2"]];
    
    _nowCityButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _nowCityButton.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
    [_nowCityButton setClicAction:^(UIButton *sender) {
        if (weakSelf.block) {
            weakSelf.block(sender.currentTitle);
        }
    }];
    [self addSubview:_nowCityButton];
    
    
    _hotLabel = [[STLabel alloc] initWithFrame:CGRectMake(17.5, _nowCityButton.bottom+15,butWith , 15)
                                          text:@"热门城市:"
                                     textColor:SecendTextColor
                                          font:15
                                   isSizetoFit:NO textAlignment:NSTextAlignmentLeft];
    [self addSubview:_hotLabel];
    
}
- (void)setHotNameArray:(NSArray *)hotNameArray
{
    __weak typeof(self) weakSelf =  self;
    CGFloat butWith = (SCREEN_WIDTH-90)/4;
    for (int i =0; i<hotNameArray.count; i++) {
        STButton * but =
        [[STButton alloc] initWithFrame:CGRectMake(17.5 + i%4*butWith+i%4*20, self.hotLabel.bottom+10+ i/4 *10 +i/4 * 25, butWith, 25)
                                  title:hotNameArray[i]
                             titleColor:FirstTextColor
                              titleFont:15
                           cornerRadius:2
                        backgroundColor:[UIColor whiteColor] backgroundImage:nil image:nil];
        but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [but setClicAction:^(UIButton *sender) {
            if (weakSelf.block) {
                weakSelf.block(sender.currentTitle);
            }
        }];
        [self addSubview:but];
        
    }
    self.height = self.subviews.lastObject.bottom + 15;
    _hotNameArray = hotNameArray;
}
- (void)setCurrenrLocationAddress:(NSString *)currenrLocationAddress{
    _currenrLocationAddress = currenrLocationAddress;
    [self.nowCityButton setTitle:currenrLocationAddress forState:UIControlStateNormal];
}
@end
