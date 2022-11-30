//
//  BLAnimationControllerViewController.m
//  blanket
//
//  Created by Mac on 2018/11/20.
//  Copyright © 2018 stoneobs@icloud.com. All rights reserved.
//

#import "StarWarAnimationViewController.h"

@interface StarWarAnimationViewController ()<UIViewControllerTransitioningDelegate>
@property(nonatomic, strong) UIImage                     *image;/**< <##> */
@end

@implementation StarWarAnimationViewController
- (instancetype)initWithImage:(UIImage*)image
{
    self = [super init];
    if (self) {
        self.image = image;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.transitioningDelegate = self;
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.image = self.image;
    [self.view addSubview:imageView];
    // Do any additional setup after loading the view.
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return StarWarsGLAnimator.new;
}

@end
