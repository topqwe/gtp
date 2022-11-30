//
//  JRMenuView.m
//  JRMenu
//
//  Created by Andy on 15/12/31.
//  Copyright © 2015年 Andy. All rights reserved.
//

#import "FunctionMenuView.h"

#define JRMenuHeight 80
#define JRMenuDismissNotification @"JRMenuDismissNotification"
@interface FunctionMenuView ()
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@property (strong,nonatomic)HomeItem* model;
@property (nonatomic, strong)UIView * targetView;
@property (nonatomic, assign)CGFloat jrMenuWidth;
@end
@implementation FunctionMenuView
{
    BOOL hasShow;
    
    UIView * backGroundView;
    UIButton * thumbBtn;
    UIButton * commentBtn;
    UIButton * shareBtn;
    NSArray * nameArray;
    
    UIView * superView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        hasShow = NO;
    }
    return self;
}
- (void)setTargetView:(UIView *)target InView:(UIView *)superview
{
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    self.targetView = target;
    superView = superview;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissOtherJRMenu) name:JRMenuDismissNotification object:nil];
}
- (void)setData:(HomeItem *)model
{
    
//    nameArray = [NSArray arrayWithArray:array];
    _funcBtns = [NSMutableArray array];
    self.jrMenuWidth = 120;
    if (self.subviews != nil && self.subviews.count != 0) {//移除所有子视图
        for (id object in self.subviews) {
            [object removeFromSuperview];
        }
    }
    NSArray* subtitleArray =@[
     @{[NSString stringWithFormat:@"点赞"]:[[NSNumber numberWithInteger:model.is_love]boolValue]? [UIImage imageNamed:@"detail_like_selected"]:[UIImage imageNamed:@"detail_like_normal"]},
     @{@"收藏":[[NSNumber numberWithInteger:model.is_collect]boolValue]? [UIImage imageNamed:@"detail_collect_selected"]:[UIImage imageNamed:@"detail_collect_normal"] }
     ];
     for (int i = 0; i < subtitleArray.count; i++) {
         NSDictionary* dic = subtitleArray[i];

        //添加按钮
        UIButton * itemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        itemBtn.tag = 80000 + i;
        [itemBtn setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        [itemBtn setTitleColor:HEXCOLOR(0x717171) forState:UIControlStateNormal];
        itemBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
//        CGFloat length = [dic.allKeys[0] boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width + 30;
        itemBtn.frame = CGRectMake(0, (i)*(JRMenuHeight/2), self.jrMenuWidth , JRMenuHeight/2);
//        jrMenuWidth += length;
        [itemBtn setImage:dic.allValues[0] forState:UIControlStateNormal];
        [itemBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:13];
        [_funcBtns addObject:itemBtn];
        [self addSubview:itemBtn];
        itemBtn.tag = model.ID;
         
         
        //设置分割线
        if (i < subtitleArray.count - 1) {
            UIView * dividingLine = [[UIView alloc] initWithFrame:CGRectMake( 0.5, JRMenuHeight/2, self.jrMenuWidth-1, 0.5)];
            dividingLine.backgroundColor = HEXCOLOR(0x8FAEB7);
            [self addSubview:dividingLine];
        }
    }
    
    UIButton* btn0 = _funcBtns[0];
    btn0.selected = [[NSNumber numberWithInteger:model.is_love]boolValue];
    [btn0 addTarget:self action:@selector(delayLikeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn2 = _funcBtns[1];
    btn2.selected = [[NSNumber numberWithInteger:model.is_collect]boolValue];
    [btn2 addTarget:self action:@selector(delayCollectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加背景view
    backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.jrMenuWidth, JRMenuHeight)];
    backGroundView.backgroundColor = [UIColor whiteColor];
    [self insertSubview:backGroundView atIndex:0];
//    [self addSubview:backGroundView];
    
//    self.frame = backGroundView.frame;
}
- (void)resetSelfFrame{
    [self setFrame:CGRectMake(self.targetView.frame.origin.x - self.jrMenuWidth +95, self.targetView.frame.origin.y-JRMenuHeight +9, self.jrMenuWidth, JRMenuHeight)];//+35 +5basic
}
- (void)resetButton:(HomeItem*)model{
    UIButton* btn0 = _funcBtns[0];
    btn0.selected = [[NSNumber numberWithInteger:model.is_love]boolValue];
    [btn0 setImage:btn0.isSelected ? [UIImage imageNamed:@"detail_like_selected"]:[UIImage imageNamed:@"detail_like_normal"] forState:UIControlStateNormal];
    
    UIButton* btn2 = _funcBtns[1];
    btn2.selected = [[NSNumber numberWithInteger:model.is_collect]boolValue];
    [btn2 setImage:btn2.isSelected ? [UIImage imageNamed:@"detail_collect_selected"]:[UIImage imageNamed:@"detail_collect_normal"] forState:UIControlStateNormal];
}
- (void)delayLikeClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    
    NSString * str = [NSString stringWithFormat:@"%d",sender.isSelected];
    
    [sender setImage:sender.isSelected ? [UIImage imageNamed:@"detail_like_selected"]:[UIImage imageNamed:@"detail_like_normal"] forState:UIControlStateNormal];
    
    [self performSelector:@selector(dismiss) withObject:sender afterDelay:.5];
//    NSInteger l = self.likes;
//    if (sender.selected) {
//        l +=  1;
//    }else{
//        if (l > 0) {
//            l -=  1;
//        }
//    }
//    self.likes = l;
//    [sender setTitle:[NSString stringWithFormat:@"%ld",(long)self.likes] forState:UIControlStateNormal];
    
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType18] andType:All andWith:@{@"like":str,@"id":@(sender.tag)} success:^(NSDictionary *bdic) {
    //        NSDictionary* result = bdic[@"result"];
            if ([NSString getDataSuccessed:bdic]) {
                
                self.model.is_love =sender.selected ? 1 :0;
//                self.model.likes = self.likes;
                
                if (self.block) {
                    self.block(self.model);
                }
                
            }
            else{
                
            }
        } error:^(NSError *error) {
            
        }];
}

- (void)delayCollectClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    NSString * str = [NSString stringWithFormat:@"%d",sender.isSelected];
    
    [sender setImage:sender.isSelected ? [UIImage imageNamed:@"detail_collect_selected"]:[UIImage imageNamed:@"detail_collect_normal"] forState:UIControlStateNormal];
    [self performSelector:@selector(dismiss) withObject:sender afterDelay:.5];
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType19] andType:All andWith:@{@"collect":str,@"id":@(sender.tag)} success:^(NSDictionary *bdic) {
    //        NSDictionary* result = bdic[@"result"];
            if ([NSString getDataSuccessed:bdic]) {
                
                self.model.is_collect =sender.selected ? 1 :0;
                
                if (self.block) {
                    self.block(self.model);
                }
            }
            else{
                if (bdic&&
                    [bdic.allKeys containsObject:@"msg"]) {
                    NSString* str = [NSString stringWithFormat:@"%@",bdic[@"msg"]];
                    [YKToastView showToastText:str];
                }
                
                [sender setImage:[UIImage imageNamed:@"detail_collect_normal"] forState:UIControlStateNormal];
            }
        } error:^(NSError *error) {
            
        }];//kf_url
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (void)show
{
    if (!hasShow) {
        [FunctionMenuView dismissAllJRMenu];
        
        [superView bringSubviewToFront:self];
        hasShow = YES;
//        self.frame = CGRectMake(self.targetView.frame.origin.x, self.targetView.frame.origin.y, 0, JRMenuHeight);
//        [UIView animateWithDuration:.1 animations:^{
            [self setFrame:CGRectMake(self.targetView.frame.origin.x - self.jrMenuWidth +95, self.targetView.frame.origin.y-JRMenuHeight +9, self.jrMenuWidth, JRMenuHeight)];//+35 +5basic
//            [self setFrame:CGRectMake(targetView.frame.origin.x + jrMenuWidth, targetView.frame.origin.y+JRMenuHeight, jrMenuWidth, JRMenuHeight)];
//        }];
    }else{
        [self dismiss];
    }
    
}
- (void)dismiss
{
    if (hasShow) {
        hasShow = NO;
//        [UIView animateWithDuration:.1 animations:^{
            [self setFrame:CGRectMake(self.targetView.frame.origin.x, self.targetView.frame.origin.y, 0, JRMenuHeight)];
            [self setFrame:CGRectZero];
//        }];
    }
    
}
- (void)dismissOtherJRMenu
{
    if (hasShow) {
        [self dismiss];
    }
}
+ (void)dismissAllJRMenu
{
    [[NSNotificationCenter defaultCenter] postNotificationName:JRMenuDismissNotification object:nil];
}
@end

