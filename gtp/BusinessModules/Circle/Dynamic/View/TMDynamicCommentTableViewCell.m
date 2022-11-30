//
//  LBCommentTableViewCell.m
//  LangBa
//
//  Created by Mac on 2017/12/21.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "TMDynamicCommentTableViewCell.h"
@interface TMDynamicCommentTableViewCell()
@property(nonatomic, strong) STLabel                     *timeLable;
@property(nonatomic, strong) STButton                     *iconButton;
@property(nonatomic, strong) STLabel                     *titleLable;
@property(nonatomic, strong) STButton                     *vipButton;
@property(nonatomic, strong) STButton                     *levelButton;
@property(nonatomic, strong) STLabel                     *contenLable;
@end
@implementation TMDynamicCommentTableViewCell
+ (CGFloat)cellHeight{
    return 120;
}
-  (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configSubView];
    }
    return self;
}
#pragma mark --subView
- (void)configSubView{
    self.backgroundColor = UIColor.whiteColor;
    self.iconButton = [[STButton alloc] initWithFrame:CGRectMake(15 , 16, 36, 36)
                                                title:nil
                                           titleColor:nil
                                            titleFont:0
                                         cornerRadius:18
                                      backgroundColor:nil
                                      backgroundImage:[UIImage imageNamed:@"1"]
                                                image:nil];
    self.iconButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self addSubview:self.iconButton];
    
    self.timeLable = [[STLabel alloc] initWithFrame:CGRectMake(self.iconButton.right  +10, 26, 100, 20)
                                               text:@"2017年12月21日09:38:22"
                                          textColor:TM_thirdTextColor
                                               font:12
                                        isSizetoFit:NO
                                      textAlignment:NSTextAlignmentLeft];
    self.timeLable.centerY = self.iconButton.centerY;
    [NSString lableAutoAdjustWitdhWithLabel:self.timeLable];
    self.timeLable.right = UIScreenWidth -   15;
    [self addSubview:self.timeLable];
    
    self.titleLable = [[STLabel alloc] initWithFrame:CGRectMake(self.iconButton.right  +10, self.iconButton.top,200, 20)
                                                text:@"stoneobs~"
                                           textColor:TM_firstTextColor
                                                font:14
                                         isSizetoFit:NO
                                       textAlignment:NSTextAlignmentLeft];
    //最大值200
    [NSString lableAutoAdjustWitdhWithLabel:self.titleLable];
    self.titleLable.lineBreakMode = NSLineBreakByTruncatingMiddle;
    [self addSubview:self.titleLable];
    
    self.timeLable.left = self.titleLable.left;
    self.timeLable.bottom = self.iconButton.bottom;
    
    
    
    STButton * vipButton = [[STButton alloc] initWithFrame:CGRectMake(_titleLable.right + 5, _titleLable.bottom  +8, 36, 14)
                                                     title:@"vip2  "
                                                titleColor:[UIColor whiteColor]
                                                 titleFont:8
                                              cornerRadius:0
                                           backgroundColor:nil
                                           backgroundImage:[UIImage imageNamed:@"vip"]
                                                     image:nil];
    vipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    vipButton.left = _titleLable.right + 5;
    vipButton.centerY = _titleLable.centerY;
    vipButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    self.vipButton = vipButton;
//    [self addSubview:vipButton];
    
    
    
    STButton * levelButton = [[STButton alloc] initWithFrame:CGRectMake(0, _titleLable.bottom  +8, 36, 14)
                                                       title:@"骑士  "
                                                  titleColor:[UIColor whiteColor]
                                                   titleFont:8
                                                cornerRadius:0
                                             backgroundColor:nil
                                             backgroundImage:[UIImage imageNamed:@"nickNameLevel"]
                                                       image:nil];
    levelButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    levelButton.left = vipButton.right  +5;
    levelButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    levelButton.centerY = _titleLable.centerY;
    self.levelButton = levelButton;
//    [self addSubview:levelButton];
    

    self.contenLable = [[STLabel alloc] initWithFrame:CGRectMake(self.titleLable.left, self.iconButton.bottom + 5, UIScreenWidth - self.titleLable.left - 10, 63)
                                                 text:@"大家啊死啦死啦地就爱上了觉得苦辣圣诞节按理说进度款拉进来的就是艾迪康阿萨德拉时间多as了解大陆按理说道具卡拉上大家安利圣诞节阿萨德阿基里斯打的"
                                            textColor:nil
                                                 font:14
                                          isSizetoFit:NO
                                        textAlignment:NSTextAlignmentLeft];
//    UIColor * gradualColor =
//    [UIColor colorWithGradientStyle:UIGradientStyleTopToBottom withFrame:self.contenLable.bounds andColors:@[TM_firstTextColor,FlatWhite]];
//    self.contenLable.textColor = gradualColor;
    [self addSubview:self.contenLable];
    
    
    STButton * goodButton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)
                                                      title:@""
                                                 titleColor:SecendTextColor
                                                  titleFont:12
                                               cornerRadius:0
                                            backgroundColor:nil
                                            backgroundImage:nil
                                                      image:[UIImage imageNamed:@"爱心"]];
    self.goodButton = goodButton;
    [self.goodButton setImage:[UIImage imageNamed:@"爱心 _选择"] forState:UIControlStateSelected];
    self.goodButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.goodButton setTitleColor:TM_redColor forState:UIControlStateSelected];
    [self addSubview:self.goodButton];
    self.goodButton.right = UIScreenWidth - 0;
    goodButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.goodButton .centerY = self.iconButton.centerY;
    self.goodButton .right = UIScreenWidth - 15;
    
}
- (void)setModel:(TMComentModel *)model{
    _model = model;
    [self.iconButton sd_setImageWithURL:[NSURL URLWithString:model.image] forState:UIControlStateNormal];
    self.titleLable.text = model.nickname;
    self.timeLable.text = model.date;
    self.contenLable.text = model.content;
    [NSString lableAutoAdjustheightWithLabel:self.contenLable];
    self.contenLable.textColor = SecendTextColor;
    
    model.cus_cellHeight = self.contenLable.bottom + 10;
    self.goodButton.selected = model.islove;
}
@end
