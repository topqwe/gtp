//
//  PostAdsView.h
//  HHL
//
//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class PostAdsDetailView;

@protocol PostAdsDetailViewDelegate <NSObject>

@required

- (void)postAdsDetailView:(PostAdsDetailView *)view requestListWithPage:(NSInteger)page;

@end

@interface PostAdsDetailView : UIView
@property (copy, nonatomic) void(^clickGridRowBlock)(NSDictionary * dataModel);
@property (nonatomic, weak) id<PostAdsDetailViewDelegate> delegate;
@property (copy, nonatomic) void(^clickSectionBlock)(IndexSectionType sec, NSString* btnTit);
- (void)requestListSuccessWithArray:(NSArray *)array;

- (void)requestListFailed;
- (void)actionBlock:(ActionBlock)block;
@end

NS_ASSUME_NONNULL_END
