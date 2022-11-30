//
//  PostAdsView.h
//  HHL
//
//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class ModifyAdsView;

@protocol ModifyAdsViewDelegate <NSObject>

@required

- (void)modifyAdsView:(ModifyAdsView *)view requestListWithPage:(NSInteger)page;

@end

@interface ModifyAdsView : UIView
@property (copy, nonatomic) void(^clickGridRowBlock)(NSDictionary * dataModel);
@property (nonatomic, weak) id<ModifyAdsViewDelegate> delegate;
@property (copy, nonatomic) void(^clickSectionBlock)(IndexSectionType sec, NSString* btnTit);
- (void)requestListSuccessWithArray:(NSArray *)array;

- (void)requestListFailed;
- (void)actionBlock:(ActionBlock)block;
@end

NS_ASSUME_NONNULL_END
