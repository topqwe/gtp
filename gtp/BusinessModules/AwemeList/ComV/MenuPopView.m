//
//  MenuPopView.m
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "MenuPopView.h"

@interface MenuPopView ()

@property (nonatomic, copy) NSArray *titles;

@end


@implementation MenuPopView

- (instancetype)initWithTitles:(NSArray *)titles {
    self = [super init];
    if(self) {
        _titles = [[titles reverseObjectEnumerator] allObjects];
        self.frame = MAINSCREENFRAME;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)]];
        _container = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, (titles.count + 1) * 70)];
        _container.backgroundColor = [UIColor clearColor];
        [self addSubview:_container];
        
        _cancel = [[UIButton alloc] initWithFrame:CGRectMake(8, _container.frame.size.height - 63, ScreenWidth - 16, 55)];
        [_cancel setTitle:@"取消" forState:UIControlStateNormal];
        [_cancel setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _cancel.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
        _cancel.layer.cornerRadius = 10;
        _cancel.backgroundColor = [UIColor whiteColor];
        [_container addSubview:_cancel];
        [_cancel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)]];
        
        __weak __typeof(self) wself = self;
        [_titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(8, wself.container.frame.size.height - 63 * (idx+2), ScreenWidth - 16, 55)];
            [button setTitle:wself.titles[idx] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
            button.layer.cornerRadius = 10;
            button.backgroundColor = RGBA(255.0, 255.0, 255.0, 0.8);
            button.tag = idx;
            [button addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(action:)]];
            [wself.container addSubview:button];
        }];
    }
    return self;
}

-(void)action:(UITapGestureRecognizer *)sender {
    if(_onAction) {
        _onAction(sender.view.tag);
        [self dismiss];
    }
}

-(void)cancel:(UITapGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:_container];
    if(![_container.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
    point = [sender locationInView:_cancel];
    if([_cancel.layer containsPoint:point]) {
        [self dismiss];
        return;
    }
}

- (void)show {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    [window addSubview:self];
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y - frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.15f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         CGRect frame = self.container.frame;
                         frame.origin.y = frame.origin.y + frame.size.height;
                         self.container.frame = frame;
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}

@end
