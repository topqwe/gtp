
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class HomeView;

@protocol HomeViewDelegate <NSObject>

@required

- (void)homeView:(HomeView *)view requestHomeListWithPage:(NSInteger)page;

@end

@interface HomeView : UIView
- (void)actionBlock:(TwoDataBlock)block;
@property (nonatomic, weak) id<HomeViewDelegate> delegate;

- (void)requestHomeListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page;

- (void)requestHomeListFailed;

@end

NS_ASSUME_NONNULL_END
