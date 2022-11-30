//
//  TMImageAdjustView.m
//  WeddingTime
//
//  Created by Mac on 2018/11/13.
//  Copyright © 2018 stoneobs.qq.com. All rights reserved.
//

#import "TMImageAdjustView.h"
@interface TMImageAdjustView()
@property(nonatomic, strong) NSMutableArray                     *originDownLoadArray;/**< 初始downLoad */
@property(nonatomic, assign) BOOL                         didDownloadAll;/**< 是否全部下载完 */
@end
@implementation TMImageAdjustView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        self.maxDuring = 15;
    }
    return self;
}
#pragma mark --subView
- (void)beginLoadUrls:(NSArray<NSString *> *)urls{
    self.originDownLoadArray = [NSMutableArray new];
    self.hidden = YES;
    self.didDownloadAll = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.maxDuring * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.didDownloadAll) {
            [self refreshImageView];
        }
        
    });
    for (NSString * realUrl in urls) {
        TMImageDownloadModel * model = TMImageDownloadModel.new;
        model.url = realUrl;
        [self.originDownLoadArray addObject:model];
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:realUrl] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
            
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            
            if (image) {
                CGFloat bilie = image.size.height /  image.size.width;
                CGFloat imageWith = self.width - self.itemInset.left -  self.itemInset.right;
                CGFloat height = bilie * imageWith;
                model.height = height;
            }else{
               model.height = 200;
            }

            
            

            model.didDownload = YES;
            if ([self judgeIsDownLoad]) {
                self.didDownloadAll = YES;
                [self refreshImageView];
            }
        }];
    }
    
}
- (BOOL)judgeIsDownLoad{
    BOOL downLoad = YES;
    for (TMImageDownloadModel * model in self.originDownLoadArray) {
        if (!model.didDownload) {
            return NO;
        }
    }
    return downLoad;
}
- (void)refreshImageView{
    for (UIView * subView in self.subviews) {
        [subView removeFromSuperview];
    }
    NSMutableArray * displayDownLoadArray = NSMutableArray.new;
    CGFloat top = self.itemInset.top;
    for (NSInteger i = 0; i < self.originDownLoadArray.count; i ++) {
        TMImageDownloadModel * model = self.originDownLoadArray[i];
        if (model.didDownload) {
            [displayDownLoadArray addObject:model];
            UIImageView * imageView = [[UIImageView alloc] init];
            
            
            imageView.frame = CGRectMake(self.itemInset.left,
                                         self.itemInset.top,
                                         self.width - self.itemInset.left - self.itemInset.right,
                                         model.height);
            [imageView sd_setImageWithURL:[NSURL URLWithString:model.url]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.top = top;
            top = imageView.bottom + self.itemInset.bottom;
            [self addSubview:imageView];
            
        }

    }
    self.height = top;
    self.hidden = NO;
    if (self.allImageViewDisplayHandle) {
        self.allImageViewDisplayHandle(self,displayDownLoadArray, self.originDownLoadArray);
    }
}
@end

@implementation TMImageDownloadModel

@end
