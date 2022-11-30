//
//  STPopMenuViewController.m
//  GrapeGold
//
//  Created by Mac on 2018/5/7.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "STPopMenuViewController.h"

@interface STPopMenuViewController ()<UIPopoverPresentationControllerDelegate>
@property(nonatomic, strong) NSMutableArray                     *buttonsArray;/**< 数组 */
@property(nonatomic, strong) NSMutableArray                     *lineArray;/**< 线数组 */
@end

@implementation STPopMenuViewController
- (instancetype)initWithSize:(CGSize)size targetView:(UIView *)targetView{
    if (self == [super init]){
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.preferredContentSize =  size;
        self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        //设置pop基于控件的位置，因为如果箭头在上面那么默认位置就是控件下边的中线，所以这里用bounds就好
        self.popoverPresentationController.backgroundColor = UIColor.clearColor;
        self.popoverPresentationController.delegate = self;
        self.popoverPresentationController.sourceRect = targetView.bounds;
        self.popoverPresentationController.sourceView = targetView;
    }
    return self;
}
- (void)setTitlesArray:(NSArray<NSString *> *)titlesArray{
    _titlesArray = titlesArray;
    [self configSubView];
}
- (void)setTitleColor:(UIColor *)titleColor{
    _titleColor = titleColor;
    for (UIButton * buttton in self.buttonsArray) {
        [buttton setTitleColor:titleColor forState:UIControlStateNormal];
    }
}
- (void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    for (UIView * line in self.lineArray) {
        line.backgroundColor = lineColor;
    }
}
- (void)setItemBackgourndColor:(UIColor *)itemBackgourndColor{
    _itemBackgourndColor = itemBackgourndColor;
    for (UIButton * buttton in self.buttonsArray) {
        [buttton setBackgroundColor:itemBackgourndColor];
    }
}
- (void)setItemColor:(UIColor *)color atIndex:(NSInteger)index{
    if (self.buttonsArray) {
        UIButton * button = self.buttonsArray[index];
        [button setTitleColor:color forState:UIControlStateNormal];
    }
    
}
- (void)setArrowsBackgourndColor:(UIColor *)arrowsBackgourndColor{
    _arrowsBackgourndColor = arrowsBackgourndColor;
    self.popoverPresentationController.backgroundColor = arrowsBackgourndColor;
}
#pragma mark --subView
- (void)configSubView{
    // self.view.backgroundColor = FlatOrange;
    for (UIButton * button in self.buttonsArray) {
        [button removeFromSuperview];
    }
    for (UIView * line in self.lineArray) {
        [line removeFromSuperview];
    }
    self.lineArray = [NSMutableArray new];
    self.buttonsArray = [NSMutableArray new];
    CGFloat buttonWith = self.preferredContentSize.width;
    CGFloat buttonHeight = self.preferredContentSize.height / self.titlesArray.count;
    CGFloat top = 0;
    for (NSInteger i = 0 ; i < self.titlesArray.count; i ++) {
        NSString * title = self.titlesArray[i];
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, top, buttonWith, buttonHeight);
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(onSelctedItemButton:) forControlEvents:UIControlEventTouchUpInside];
        if (self.titleColor) {
            [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        }
        if (self.itemBackgourndColor) {
            button.backgroundColor = self.itemBackgourndColor;
        }
        [self.view addSubview:button];
        [self.buttonsArray addObject:button];
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, buttonHeight -0.8, buttonWith, 0.8)];
        if (self.lineColor) {
            line.backgroundColor = self.lineColor;
        }
        [button addSubview:line];
        [self.lineArray addObject:line];
        top = i * buttonHeight +  buttonHeight;
    }
}
#pragma mark ----UIPopoverPresentationControllerDelegate
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController*)controller{
    //返回UIModalPresentationNone就不是全屏
    return UIModalPresentationNone;
}
#pragma mark --Action Method
- (void)onSelctedItemButton:(UIButton*)sender{
    NSInteger index = [self.buttonsArray indexOfObject:sender];
    NSString *title = sender.currentTitle;
    __weak typeof(self) weakSelf =  self;
    
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.onSelctedItemHandle) {
            self.onSelctedItemHandle(weakSelf, index, title);
        }
        
    }];
    
}
@end

