//
//  HomeView.h
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class OrdersPageListView;

@protocol OrdersPageListViewDelegate <NSObject>

@required

- (void)ordersPageListView:(OrdersPageListView *)view requestListWithPage:(NSInteger)page;

@end

@interface OrdersPageListView : UIView

@property (nonatomic, weak) id<OrdersPageListViewDelegate> delegate;
- (void)actionBlock:(TwoDataBlock)block;
- (void)requestListSuccessWithArray:(NSArray *)array;

- (void)requestListFailed;

@end

NS_ASSUME_NONNULL_END
