//
//  STPhotoCollectionViewCell.m
//  STTools
//
//  Created by stoneobs on 16/10/10.
//  Copyright © 2016年 stoneobs. All rights reserved.


#import "STPhotoCollectionViewCell.h"
#import "UIView+STPhotoKitTool.h"
#import "UIButton+STPhotoKitSelectedAnimation.h"
#define DEFULT_IMAGE_SIZE CGSizeMake(175.5, 175.5)
@interface STPhotoCollectionViewCell()
@property(nonatomic,strong)UIView                   *vidioView;
@property(nonatomic,strong)UILabel                  *vidioTime;
@property (nonatomic, assign)PHImageRequestID       imageRequestID;
@property(nonatomic,copy)void(^imageViewHandle)(UIImageView *imageView);
@property(nonatomic,copy)void(^buttonHandle)(UIButton *button);
@end
@implementation STPhotoCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initSubviews];
    }
    return self;
    
}
- (void)initSubviews{
    
    [self addSubview:self.imageView];
    self.chosedButton = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4-20-4, 5+4, 20, 20)];
    self.chosedButton.backgroundColor = [UIColor clearColor];
    //图片获取优化
    UIImage * normalImage =  [UIImage imageNamed:@"STPhotoKit.bundle/STPhotoKitImageSelectedOff.png"];
    UIImage * selectedImage = [UIImage imageNamed:@"STPhotoKit.bundle/STPhotoKitImageSelectedOn.png"];
    [self.chosedButton setBackgroundImage:normalImage forState:UIControlStateNormal];
    [self.chosedButton setBackgroundImage:selectedImage forState:UIControlStateSelected];
    [self.chosedButton addTarget:self action:@selector(chosedButtonDidClic:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.chosedButton];
    //视屏
    self.vidioView = [[UIView alloc] initWithFrame:CGRectMake(0, self.imageView.height-10, self.imageView.width, 10)];
    self.vidioView.backgroundColor = [UIColor blackColor];
    UIButton *liveButton = [[UIButton alloc] initWithFrame:CGRectMake(3, 0, 40, 10)];
    [liveButton setTitle:@"vidio" forState:UIControlStateNormal];
    [liveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    liveButton.titleLabel.font = [UIFont systemFontOfSize:8];
    [liveButton setImage:[UIImage imageNamed:@"STPhotoKit.bundle/STPhotoKitVidioButImage.png"] forState:UIControlStateNormal];
    liveButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    liveButton.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
    self.vidioView.hidden = YES;
    [self.vidioView addSubview:liveButton];
    
    
    self.vidioTime = [[UILabel alloc] initWithFrame:CGRectMake(self.imageView.width-26, 0, 25, 10)];
    self.vidioTime.textColor = [UIColor whiteColor];
    self.vidioTime.textAlignment = NSTextAlignmentCenter;
    self.vidioTime.font = [UIFont systemFontOfSize:7];
    [self.vidioView addSubview:self.vidioTime];
    [self.imageView addSubview:self.vidioView];
    
}
#pragma mark --Geter And Seter
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, SCREEN_WIDTH/4-5, SCREEN_WIDTH/4-5)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.userInteractionEnabled = YES;
        
    }
    return _imageView;
}
- (void)imageViewClicHandle:(void (^)(UIImageView *))imageHandle
{
    if (imageHandle) {
        self.imageViewHandle = imageHandle;
    }
}
- (void)chosedButtonClicHandle:(void (^)(UIButton *))buttonHandle
{
    if (buttonHandle) {
        self.buttonHandle = buttonHandle;
    }
}
- (void)setModel:(STPhotoModel *)model
{
    if (model) {
        _model = model;
        self.chosedButton.selected = model.isChosed;
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewClication:)];
        [self.imageView addGestureRecognizer:tapGes];
        if (model.originImage) {
            self.imageView.image = model.originImage;
            return;
        }
        if (model.thumbImage) {
            //如果model 存在图片，那么不请求
            self.imageView.image = model.thumbImage;
            return;
        }
        //资源是视屏
        if (model.asset.mediaType == PHAssetMediaTypeVideo) {
            self.chosedButton.hidden = YES;
            self.vidioView.hidden = NO;
            NSLog(@"%f",model.asset.duration);
            self.vidioTime.text = [self timeForduration:model.asset.duration];
        }
        if (model.asset.mediaType == PHAssetMediaTypeImage) {
            self.chosedButton.hidden = NO;
            self.vidioView.hidden = YES;
        }
 
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        PHImageRequestID imageRequestID  = [[PHImageManager defaultManager] requestImageForAsset:model.asset targetSize:DEFULT_IMAGE_SIZE contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            
            model.thumbImage = result;
            self.imageView.image = model.thumbImage;
            model.requsetID = imageRequestID;//赋值
            //没有图片从icloud下载
            if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
                PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
                option.networkAccessAllowed = YES;
                option.resizeMode = PHImageRequestOptionsResizeModeFast;
                [[PHImageManager defaultManager] requestImageDataForAsset:model.asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                    UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                    resultImage = [self scaleImage:resultImage toSize:CGSizeMake(175.5, 175.5)];
                    model.thumbImage = result;
                    self.imageView.image = model.thumbImage;
                    
                }];
            }
            
        }];
        

        
        
        
    }
}
#pragma mark --Private Method
//计算vidio时长
- (NSString *)getAssetIdentifier:(id)asset {
    
    PHAsset *phAsset = (PHAsset *)asset;
    return phAsset.localIdentifier;
    
}
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
}
#pragma mark --Private Method
//秒转 3：20 这种格式
- (NSString*)timeForduration:(NSTimeInterval)time
{
    NSInteger num = time;
    NSString * hour = [NSString stringWithFormat:@"%ld",num/3600];
    NSString * minte =[NSString stringWithFormat:@"%ld",num/60];
    NSString * secend = [NSString stringWithFormat:@"%ld",num];
    if (hour.integerValue>=1) {
        hour = [self format:hour];
        minte = [NSString stringWithFormat:@"%ld",num%3600/60];
        minte = [self format:minte];
        
        secend = [NSString stringWithFormat:@"%ld",num%3600%60];
        secend = [self format:secend];
        return [NSString stringWithFormat:@"%@:%@:%@",hour,minte,secend];
    }
    
    minte = [NSString stringWithFormat:@"%ld",num/60];
    minte = [self format:minte];
    
    secend = [NSString stringWithFormat:@"%ld",num%60];
    secend = [self format:secend];
    return [NSString stringWithFormat:@"%@:%@",minte,secend];
    
    
}
-(NSString*)format:(NSString*)one
{
    if (one.integerValue < 10) {
        return [NSString stringWithFormat:@"0%@",one];
    }
    return one;
}
#pragma mark --Action Method
-(void)imageViewClication:(UIImageView*)sender
{
    if (self.imageViewHandle) {
        _imageViewHandle(sender);
    }
}
- (void)chosedButtonDidClic:(UIButton*)sender{
    
    if (self.buttonHandle) {
        self.buttonHandle(sender);
    }
}
@end
