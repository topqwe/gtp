//
//  PostAdsView.h
//  HHL
//
//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class ExchangeView;

@protocol ExchangeViewDelegate <NSObject>

@required

- (void)exchangeView:(ExchangeView *)view requestListWithPage:(NSInteger)page;

@end

@interface ExchangeView : UIView

@property (nonatomic, weak) id<ExchangeViewDelegate> delegate;
- (void)actionBlock:(ActionBlock)block;

- (void)requestListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page;

- (void)requestListFailed;

@end

NS_ASSUME_NONNULL_END
