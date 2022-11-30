//
//  STImagePickerController.m
//  STTools
//
//  Created by stoneobs on 16/10/9.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STImagePickerController.h"
#import "STPhotoBaseViewController.h"

@interface STImagePickerController ()
/**
 完成回调，是包含一组STPhotoModel的数组
 */
@property(nonatomic,copy)STImagePickerControllerFinshed  handle;
@end

@implementation STImagePickerController

- (instancetype)initWithDefultRootVCHandle:(STImagePickerControllerFinshed)handle
{
    
    if (handle) {
        _handle = handle;
    }
    //选择完毕之后会发送通知，此处接受
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinshChosed:) name:STPHOTOKIT_FINSH_CHOSED_NOTIFICATION object:nil];
    self.maxImageChosed = NSUIntegerMax;
    return [self initWithRootViewController:[STPhotoBaseViewController new]];
    
    
    
}
- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    if (self = [super initWithRootViewController:rootViewController]) {
        self.interactivePopGestureRecognizer.delegate=(id)self;
        [self.navigationBar setBarTintColor:[UIColor whiteColor]];
        self.navigationBar.backgroundColor = [UIColor whiteColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}];
        //title
       // [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont boldSystemFontOfSize:17]}];
    }
    return self;
    
}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark --Geter And Seter
- (void)setDidChosedMaxImages:(void (^)(NSInteger))didChosedMaxImages{

    if (didChosedMaxImages) {
        if (self.maxImageChosed == NSUIntegerMax || self.maxImageChosed == 0) {
            NSLog(@"block 生效 需要 maxImageChosed参数 大于 0  ");
        }else{
            _didChosedMaxImages = didChosedMaxImages;
        }
        
        
    }
}
- (void)setNavagationBarTintColor:(UIColor *)navagationBarTintColor{
    
    if (navagationBarTintColor) {
        self.navigationBar.barTintColor = navagationBarTintColor;
        _navagationBarTintColor = navagationBarTintColor;
    }
}
#pragma mark --override Method
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    
    if (self.childViewControllers.count>0) {
        self.hidesBottomBarWhenPushed = YES;
        //设置返回键
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(popToLastViewController)  forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:[UIImage imageNamed:@"STPhotoKit.bundle/STPhotoKitNav_back.png"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"STPhotoKit.bundle/STPhotoKitNav_back.png"] forState:UIControlStateHighlighted];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
        btn.frame = CGRectMake(0, 0, 44, 44);
        viewController.navigationItem.leftBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:btn];
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark --Private Method
- (void)didFinshChosed:(NSNotification*)sender{
    
    NSArray <STPhotoModel*>* array = sender.object;
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.handle) {
            self.handle(array);
        }
    }];
    
}
- (void)popToLastViewController{
    
    [self popViewControllerAnimated:YES];
}





@end
