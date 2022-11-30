//
//  PostAdsView.h
//  HHL
//
//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class PostAdsView;

@protocol PostAdsViewDelegate <NSObject>

@required

- (void)postAdsView:(PostAdsView *)view requestListWithPage:(NSInteger)page;

@end

@interface PostAdsView : UIView
@property (copy, nonatomic) void(^clickGridRowBlock)(NSDictionary * dataModel);
@property (nonatomic, weak) id<PostAdsViewDelegate> delegate;
- (void)actionBlock:(ActionBlock)block;
- (void)requestListSuccessWithArray:(NSArray *)array;

- (void)requestListFailed;

@end

NS_ASSUME_NONNULL_END
