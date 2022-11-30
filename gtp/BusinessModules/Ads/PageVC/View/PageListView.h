//
//  HomeView.h
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/19.
//  Copyright © 2018 杨波. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class PageListView;

@protocol PageListViewDelegate <NSObject>

@required

- (void)pageListView:(PageListView *)view requestListWithPage:(NSInteger)page;

@end

@interface PageListView : UIView

@property (nonatomic, weak) id<PageListViewDelegate> delegate;
- (void)actionBlock:(TableViewDataBlock)block;
- (void)requestListSuccessWithArray:(NSArray *)array;

- (void)requestListFailed;

@end

NS_ASSUME_NONNULL_END
