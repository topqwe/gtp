//
//  PostAdsView.h
//  HHL
//
//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class ExchangeDetailView;

@protocol ExchangeDetailViewDelegate <NSObject>

@required

- (void)exchangeDetailView:(ExchangeDetailView *)view requestListWithPage:(NSInteger)page;

@end

@interface ExchangeDetailView : UIView
@property (copy, nonatomic) void(^clickGridRowBlock)(NSDictionary * dataModel);
@property (nonatomic, weak) id<ExchangeDetailViewDelegate> delegate;
@property (copy, nonatomic) void(^clickSectionBlock)(IndexSectionType sec, NSString* btnTit);
- (void)requestListSuccessWithArray:(NSArray *)array;

- (void)requestListFailed;

@end

NS_ASSUME_NONNULL_END
