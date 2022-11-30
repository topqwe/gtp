//
//  UIViewController+st_starWarAnimation.m
//  blanket
//
//  Created by Mac on 2018/11/20.
//  Copyright © 2018 stoneobs@icloud.com. All rights reserved.
//

#import "UIViewController+st_starWarAnimation.h"
#import "UIImage+STTools.h"
@implementation UIViewController (st_starWarAnimation)
- (void)st_rootViewControllerChangeAnimationToViewController:(UIViewController *)toViewController completion:(void (^)(void))completion{
    
    
    if (toViewController) {
        UIImage * fromimage = [UIImage st_snapshot:self.view.window];
        StarWarAnimationViewController * animationVC = [[StarWarAnimationViewController alloc] initWithImage:fromimage];
        [self presentViewController:animationVC animated:NO completion:^{
            UIView * toview;
            if ([toViewController isKindOfClass:UINavigationController.class]) {
                toview = toViewController.childViewControllers.lastObject.view;
            }else{
                toview = toViewController.view;
            }
//            toview = toViewController.view;
            UIImage * image = [UIImage st_snapshot:toview];
            UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
            imageView.image = image;
            if (self.navigationController) {
                [self.navigationController.view addSubview:imageView];
            }else{
                [self.view addSubview:imageView];
            }
        }];
        

        [animationVC dismissViewControllerAnimated:YES completion:^{
            [UIApplication sharedApplication].keyWindow.rootViewController = toViewController;
            if (completion) {
                completion();
            }
        }];
    }
    

}
- (void)st_showNavgationControllerpopAnimationToRoot:(BOOL)toroot completion:(void (^)(void))completion{
    if (self.navigationController.childViewControllers.count) {
        UIImage * fromimage = [UIImage st_snapshot:self.view.window];
        StarWarAnimationViewController * animationVC = [[StarWarAnimationViewController alloc] initWithImage:fromimage];
        [self presentViewController:animationVC animated:NO completion:^{
            if (toroot) {
                [self.navigationController popToRootViewControllerAnimated:NO];
            }else{
                [self.navigationController popViewControllerAnimated:NO];
            }
        }];

        [animationVC dismissViewControllerAnimated:YES completion:^{
            if (completion) {
                completion();
            }
        }];
    }


}
- (void)st_showDismissAnimationCompletion:(void (^)(void))completion{

    UIImage * fromimage = [UIImage st_snapshot:self.view.window];

    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = fromimage;
    
    UIViewController * rootVc = UIApplication.sharedApplication.delegate.window.rootViewController;
    [rootVc.view addSubview:imageView];
    [self dismissViewControllerAnimated:NO completion:^{
        StarWarAnimationViewController * animationVC = [[StarWarAnimationViewController alloc] initWithImage:fromimage];
        [rootVc presentViewController:animationVC animated:NO completion:^{
            [imageView removeFromSuperview];
            [animationVC dismissViewControllerAnimated:YES completion:^{
                if (completion) {
                    completion();
                }
            }];
        }];

    }];
    
}

@end
