//
//  STPhotoBaseTableViewCell.m
//  STNewTools
//
//  Created by stoneobs on 17/3/1.
//  Copyright © 2017年 stoneobs. All rights reserved.
//

#import "STPhotoBaseTableViewCell.h"
#import "UIView+STPhotoKitTool.h"
@interface STPhotoBaseTableViewCell()
@property(nonatomic,strong)UIImageView            *mainImageView;

/**
 背后第一张图片
 */
@property(nonatomic,strong)UIImageView            *imageViewTwo;
@property(nonatomic,strong)UIImageView            *imageViewThree;
@property(nonatomic,strong)UILabel                *titleLable;
@property(nonatomic,strong)UILabel                *countLable;
@end

@implementation STPhotoBaseTableViewCell
+ (CGFloat)height
{
    return   70;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initSubviews];
    }
    return self;
}

- (void)initSubviews{

    self.imageViewThree = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 76, 76)];
    self.imageViewThree.centerX = 15 + 50;
//    [self addSubview:self.imageViewThree];
    
    self.imageViewTwo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 78, 78)];
    self.imageViewTwo.centerX = 15 + 50;
//    [self addSubview:self.imageViewTwo];
    
    self.mainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
//    self.mainImageView.centerX = 15 + 50;
    self.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:self.mainImageView];
    
    self.mainImageView.clipsToBounds = YES;
    self.imageViewThree.clipsToBounds = YES;
    self.imageViewTwo.clipsToBounds = YES;
    

    self.titleLable = [[UILabel alloc] initWithFrame:CGRectMake(_mainImageView.right  + 15, _mainImageView.top + 20, 200, 16)];
    self.titleLable.font = [UIFont systemFontOfSize:16];
    self.titleLable.textColor = FirstTextColor;
    self.titleLable.textAlignment = NSTextAlignmentLeft;
    [self addSubview:self.titleLable];
    
    self.countLable = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLable.right  + 10, _titleLable.bottom + 10, 200, 13)];
    self.countLable.font = [UIFont systemFontOfSize:13];
    self.countLable.textColor = FirstTextColor;
    self.countLable.textAlignment = NSTextAlignmentLeft;
//    [self addSubview:self.countLable];
    

}
- (void)setModel:(PHAssetCollection *)model
{
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:model options:nil];
    PHAsset * mainAsset = fetchResult.lastObject;
    
    if (fetchResult.count > 2) {
        PHAsset * twoAsset = fetchResult[1];
        [[PHImageManager defaultManager] requestImageForAsset:twoAsset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.imageViewTwo.image = result;
        }];
    }
    if (fetchResult.count > 3) {
         PHAsset * threeAsset = fetchResult[2];
        [[PHImageManager defaultManager] requestImageForAsset:threeAsset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            self.imageViewThree.image = result;
        }];
    }
   
    NSMutableAttributedString *nameString = [[NSMutableAttributedString alloc] initWithString:model.localizedTitle attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor blackColor]}];
    NSAttributedString *countString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"  (%zd)",fetchResult.count] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    [nameString appendAttributedString:countString];
    self.titleLable.attributedText = nameString;
    //标题
//    NSString * title = model.localizedTitle;
//    self.titleLable.text = title;
//    //数量
//    NSInteger count = fetchResult.count;
//    self.countLable.text = [NSString stringWithFormat:@"%ld",count];

    [[PHImageManager defaultManager] requestImageForAsset:mainAsset targetSize:CGSizeMake(300, 300) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.mainImageView.image = result;
    }];


    


}
@end
