//
//  TMDynamicCollectionViewCell.m
//  Marriage
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "TMDynamicCollectionViewCell.h"
@interface TMDynamicCollectionViewCell()

@end
@implementation TMDynamicCollectionViewCell
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
    self.itemImageView = [UIImageView new];
    self.itemImageView.backgroundColor = TM_backgroundColor;
    self.itemImageView.image = [UIImage imageNamed:@"1"];
    self.itemImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.itemImageView.clipsToBounds = YES;
    self.itemImageView.layer.cornerRadius = 2;
    [self addSubview:self.itemImageView];
    [self.itemImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.mas_equalTo(self);
    }];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 19, 23)];
    imageView.image = [UIImage imageNamed:@"播放"];
    [self addSubview:imageView];
    self.playView = imageView;
}
- (void)layoutSubviews{
    self.playView.centerX = self.width/2;
    self.playView.centerY = self.height/2;
}
- (void)setVideoModel:(TMDynamicVideoModel *)videoModel{
    _videoModel = videoModel;
    self.playView.hidden = NO;
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:videoModel.image]];
}
- (void)setImageModel:(TMDynamicImageModel *)imageModel{
    _imageModel = imageModel;
    self.playView.hidden = YES;
    [self.itemImageView sd_setImageWithURL:[NSURL URLWithString:imageModel.max]];
}
@end
