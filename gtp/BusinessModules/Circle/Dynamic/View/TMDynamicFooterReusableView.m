//
//  TMDynamicHeeaderReusableView.m
//  Marriage
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "TMDynamicFooterReusableView.h"
#define insetX 70
@interface TMDynamicFooterReusableView()
@property(nonatomic, strong) STLabel                     *timeLable;/**< 时间 */

@end
@implementation TMDynamicFooterReusableView
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

    
    CGFloat lableWith = UIScreenWidth - 10 - 70;
    STLabel * timeLable = [[STLabel alloc] initWithFrame:CGRectMake(70 , 0, lableWith, 44)
                                                     text:@"2018年04月23日14:24:40"
                                                textColor:SecendTextColor
                                                     font:12
                                              isSizetoFit:NO
                                            textAlignment:NSTextAlignmentLeft];
    self.timeLable = timeLable;
    [self addSubview:self.timeLable];


    
    
    STButton * goodButton = [[STButton alloc] initWithFrame:CGRectMake(insetX, 0, 60, 44)
                                                         title:@"78"
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
    
    STButton * commengButton = [[STButton alloc] initWithFrame:CGRectMake(insetX, 0, 60, 44)
                                                         title:@"78"
                                                    titleColor:SecendTextColor
                                                     titleFont:12
                                                  cornerRadius:0
                                               backgroundColor:nil
                                               backgroundImage:nil
                                                         image:[UIImage imageNamed:@"评论"]];
    self.commentButton = commengButton;
    [self.commentButton setImage:[UIImage imageNamed:@"评论"] forState:UIControlStateSelected];
    self.commentButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.commentButton setTitleColor:TM_redColor forState:UIControlStateSelected];
    [self addSubview:self.commentButton];
    commengButton.right = self.goodButton.left-0;
    commengButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    STButton * shareButton = [[STButton alloc] initWithFrame:CGRectMake(insetX, 0, 60, 44)
                                                         title:@"分享"
                                                    titleColor:SecendTextColor
                                                     titleFont:12
                                                  cornerRadius:0
                                               backgroundColor:nil
                                               backgroundImage:nil
                                                         image:[UIImage imageNamed:@"send_press"]];
    self.shareButton = shareButton;
    [self.shareButton setImage:[UIImage imageNamed:@"send_press"] forState:UIControlStateSelected];
    self.shareButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [self.shareButton setTitleColor:TM_redColor forState:UIControlStateSelected];
    [self addSubview:self.shareButton];
    [self.shareButton setClicAction:^(UIButton *sender) {
        [TMUtils onSelctedShareButton];
    }];
    shareButton.right = self.commentButton.left-0;
    shareButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    self.timeLable.width = self.shareButton.left - 0;
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 120)];
    imageView.image = [UIImage imageNamed:@""];
    [self addSubview:imageView];
    self.adverImageView = imageView;
    imageView.backgroundColor = TM_backgroundColor;

    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onSelectedBanner:)];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:tap];
}
- (void)onSelectedBanner:(UITapGestureRecognizer*)tap{

    BVAdverModel * model =  self.model.cus_adver;
    [TMUtils gotoAdverController:model];
    
}

- (void)layoutSubviews{
    self.adverImageView.bottom = self.height;
}
- (void)setModel:(TMDynamicModel *)model{
    _model = model;
    self.timeLable.text = model.time;
    [self.commentButton setTitle:model.comment_num forState:UIControlStateNormal];
    [self.goodButton setTitle:model.love forState:UIControlStateNormal];
    self.goodButton.selected = model.islove;
    
    self.adverImageView.hidden = model.cus_adver?NO:YES;
    [self.adverImageView sd_setImageWithURL:[NSURL URLWithString:model.cus_adver.image]];
    self.adverImageView.height = model.cus_imageHeight;
}
@end

