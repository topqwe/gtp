//
//  PostAdsView.h
//  gtp
//
//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class DataStatisticsView;

@protocol DataStatisticsViewDelegate <NSObject>

@required

- (void)dataStatisticsView:(DataStatisticsView *)view requestListWithPage:(NSInteger)page;

@end

@interface DataStatisticsView : UIView
@property (copy, nonatomic) void(^clickGridRowBlock)(NSDictionary * dataModel);
@property (nonatomic, weak) id<DataStatisticsViewDelegate> delegate;
@property (copy, nonatomic) void(^clickSectionBlock)(IndexSectionType sec, NSString* btnTit);
- (void)requestListSuccessWithArray:(NSArray *)array;

- (void)requestListFailed;

@end

NS_ASSUME_NONNULL_END
