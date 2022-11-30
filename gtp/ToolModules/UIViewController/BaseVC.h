//
//  BaseVC.h
//  gtp
//
//  Created by GT on 2019/1/8.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseVC : UIViewController
@property (nonatomic ,strong) UIButton *rightBtn;
- (void)naviRightBtnEvent:(UIButton *)sender;
- (void)levSuccessMethod;
- (void)loginSuccessBlockMethod;
- (BOOL)isloginBlock;
-(void)locateTabBar:(NSInteger)index;
- (void)changeUrlEnvironment;
- (void) setBackgroundImage:(NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
