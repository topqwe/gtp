//
//  TMDynamicHeeaderReusableView.m
//  Marriage
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "TMDynamicHeeaderReusableView.h"
@interface TMDynamicHeeaderReusableView()
@property(nonatomic, strong) STLabel                     *titleLable;/**< 名字 */
@property(nonatomic, strong) STLabel                     *contentLable;/**< 内容 */
@property(nonatomic, strong) STButton                     *genderButton;/**< <##> */
@end
@implementation TMDynamicHeeaderReusableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubView];
    }
    return self;
}
#pragma mark --subView
- (void)configSubView{
    STButton * iconButton = [[STButton alloc] initWithFrame:CGRectMake(12, 20, 48, 48)
                                                     title:nil
                                                titleColor:nil
                                                 titleFont:0
                                              cornerRadius:24
                                           backgroundColor:nil
                                           backgroundImage:[UIImage imageNamed:@"3"]
                                                     image:nil];
    self.iconButton = iconButton;
    [self addSubview:iconButton];
    
    CGFloat lableWith = UIScreenWidth - 10 - self.iconButton.right - 10;
    STLabel * titleLable = [[STLabel alloc] initWithFrame:CGRectMake(self.iconButton.right + 10, self.iconButton.top, lableWith, 20)
                                                     text:@"萌么~阿卡丽"
                                                textColor:TM_ThemeBackGroundColor
                                                     font:14
                                              isSizetoFit:NO
                                            textAlignment:NSTextAlignmentLeft];
    self.titleLable = titleLable;
    [self addSubview:self.titleLable];
    
    STLabel * cntentLable = [[STLabel alloc] initWithFrame:CGRectMake(self.iconButton.right + 10, self.titleLable.bottom + 8, lableWith, 20)
                                                     text:@"朝如青丝暮成雪"
                                                textColor:SecendTextColor
                                                     font:13
                                              isSizetoFit:NO
                                            textAlignment:NSTextAlignmentLeft];
    self.contentLable = cntentLable;

    [self addSubview:self.contentLable];
    
    STButton * button = [[STButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)
                                                  title:nil
                                             titleColor:nil
                                              titleFont:0
                                           cornerRadius:0
                                        backgroundColor:nil
                                        backgroundImage:nil
                                                  image:[UIImage imageNamed:@"男"]];
    self.genderButton = button;
    button.centerY = self.titleLable.centerY;
    [button setImage:[UIImage imageNamed:@"女"] forState:UIControlStateSelected];
    [self addSubview:button];
    
    
    STButton * dbutton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, 45, 22)
                                                  title:@"详情"
                                             titleColor:SecendTextColor
                                              titleFont:12
                                           cornerRadius:11
                                        backgroundColor:nil
                                        backgroundImage:nil
                                                  image:nil];
    self.detailButton = dbutton;
    dbutton.centerY = self.titleLable.centerY;
    dbutton.right = UIScreenWidth - 15;
    [dbutton st_setBorderWith:0.5 borderColor:TM_lineColor cornerRadius:11];
    [self addSubview:dbutton];
    dbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}

- (void)layoutSubviews{
    self.contentLable.bottom = self.height - 10;
    
    self.titleLable.bottom = self.contentLable.top - 8;
    
    self.iconButton.top = self.titleLable.top;
    

    self.detailButton.centerY = self.titleLable.centerY;
    self.genderButton.centerY = self.titleLable.centerY;
}
- (void)setModel:(TMDynamicModel *)model{
    _model = model;
    [self.iconButton sd_setBackgroundImageWithURL:[NSURL URLWithString:model.image] forState:UIControlStateNormal];
    self.titleLable.text = model.nickname;
    [NSString lableAutoAdjustWitdhWithLabel:self.titleLable];
    if (self.titleLable.width > UIScreenWidth * 0.6) {
        self.titleLable.width = UIScreenWidth * 0.6;
    }
    self.genderButton.left = self.titleLable.right + 5;
    self.genderButton.selected = model.sex.integerValue==2? YES:NO;
    self.contentLable.text = model.content;
    [NSString lableAutoAdjustheightWithLabel:self.contentLable];
}
@end
