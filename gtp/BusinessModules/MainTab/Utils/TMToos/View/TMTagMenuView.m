//
//  TMTagMenuView.m
//  STToolsMaker
//
//  Created by Mac on 2018/11/13.
//  Copyright © 2018 stoneobs.qq.com. All rights reserved.
//

#import "TMTagMenuView.h"

@interface TMTagMenuView()
@property(nonatomic, strong) NSMutableArray                     *buttonsArray;/**< 控件集合 */
@end
@implementation TMTagMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cornerRadius = -0.1;
        self.buttonsArray = [NSMutableArray new];
        _direction = TMTagMenuViewDirectionVertical;
    }
    return self;
}
- (void)setAllArray:(NSArray *)allArray{
    _allArray = allArray;
    [self configSubView];
}
- (void)setDirection:(TMTagMenuViewDirection)direction{
    _direction = direction;
    [self configSubView];
}
- (void)setChosedArray:(NSArray *)chosedArray{
    _chosedArray = chosedArray;
    for (UIButton * button in self.buttonsArray) {
        if ([chosedArray containsObject:button.currentTitle]) {
            [button st_setBorderWith:1 borderColor:self.buttonSelectedBoderColor cornerRadius:self.cornerRadius];
            button.backgroundColor  = self.buttonSelctedBackGroundColor;
            button.selected = YES;
        }else{
            button.selected = NO;
            [button st_setBorderWith:1 borderColor:self.buttonBoderColor cornerRadius:self.cornerRadius];
            button.backgroundColor  = self.buttonBackGroundColor;
        }
    }
    
}
- (NSArray *)finshChosedArray{
    NSMutableArray * array = [NSMutableArray new];
    for (UIButton * button in self.buttonsArray) {
        if (button.selected) {
            [array addObject:button.currentTitle];
        }
    }
    return array.copy;
}
- (void)setForceButtonWitdh:(CGFloat)forceButtonWitdh{
    _forceButtonWitdh = forceButtonWitdh;
    [self clearSubView];
    self.allArray = self.allArray;
}
- (void)setButTitleColor:(UIColor *)butTitleColor{
    _butTitleColor = butTitleColor;
    [self clearSubView];
    self.allArray = self.allArray;
}
- (void)setButTitleSelectedColor:(UIColor *)butTitleSelectedColor{
    _butTitleSelectedColor = butTitleSelectedColor;
    [self clearSubView];
    self.allArray = self.allArray;
}
- (void)setButtonBackGroundColor:(UIColor *)buttonBackGroundColor{
    _buttonBackGroundColor = buttonBackGroundColor;
    [self clearSubView];
    self.allArray = self.allArray;
}
- (void)setButtonSelctedBackGroundColor:(UIColor *)buttonSelctedBackGroundColor{
    _buttonSelctedBackGroundColor = buttonSelctedBackGroundColor;
    [self clearSubView];
    self.allArray = self.allArray;
}
- (void)setButtonBoderColor:(UIColor *)buttonBoderColor{
    _buttonBoderColor = buttonBoderColor;
    [self clearSubView];
    self.allArray = self.allArray;
}
- (void)setButtonSelectedBoderColor:(UIColor *)buttonSelectedBoderColor{
    _buttonSelectedBoderColor = buttonSelectedBoderColor;
    [self clearSubView];
    self.allArray = self.allArray;
}
- (void)setButtonBackGroundImage:(UIImage *)buttonBackGroundImage{
    _buttonBackGroundImage = buttonBackGroundImage;
    [self clearSubView];
    self.allArray = self.allArray;
}
- (void)setButtonSelectedBackGroundImage:(UIImage *)buttonSelectedBackGroundImage{
    _buttonSelectedBackGroundImage = buttonSelectedBackGroundImage;
    [self clearSubView];
    self.allArray = self.allArray;
}
- (void)setForceButtonHeight:(CGFloat)forceButtonHeight{
    _forceButtonHeight = forceButtonHeight;
    [self clearSubView];
    self.allArray = self.allArray;
}
- (void)setInset:(CGFloat)inset{
    _inset = inset;
    [self clearSubView];
    self.allArray = self.allArray;
}
- (void)clearSubView{
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
}
#pragma mark --subView
- (void)configSubView{
    for (UIButton * button in self.buttonsArray) {
        [button removeFromSuperview];
    }
    self.buttonsArray = NSMutableArray.new;
#define itemHeight 40
#define itemInsetX 10
#define itemInsetY 10
#define itemcornerRadius itemHeight/2
    __weak typeof(self) weakSelf =  self;
    CGFloat left  = itemInsetX;
    CGFloat top = itemInsetY;
    
    CGFloat insetX  = itemInsetX;
    CGFloat insetY = itemInsetY;
    if (self.inset) {
        insetX = self.inset;
        insetY = self.inset;
        left = insetX;
        top = insetY;
    }
    CGFloat yuanjiao = itemcornerRadius;
    CGFloat height = itemHeight;
    
    if (self.forceButtonHeight) {
        height = _forceButtonHeight;
    }
    if (_cornerRadius >= 0) {
        yuanjiao = _cornerRadius;
    }
    
    for (NSInteger i = 0 ; i < self.allArray.count; i ++) {
        NSString * title = self.allArray[i];
        STButton * buyButton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, 30, height)
                                                         title:title
                                                    titleColor:SecendTextColor
                                                     titleFont:14
                                                  cornerRadius:yuanjiao
                                               backgroundColor:nil
                                               backgroundImage:nil
                                                         image:nil];
        buyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        [buyButton setTitleColor:TM_YellowBackGroundColor forState:UIControlStateSelected];
        [buyButton setClicAction:^(UIButton *sender) {
            [weakSelf onSelctedItemButton:sender];
        }];
        buyButton.titleLabel.numberOfLines = 0;
        [buyButton sizeToFit];
        buyButton.width = buyButton.width + 20  +  10;
        buyButton.height = height;
        buyButton.tag = 10000 + i;
        
        if (self.forceButtonWitdh) {
            buyButton.width = _forceButtonWitdh;
        }
        if (self.butTitleColor) {
            [buyButton setTitleColor:self.butTitleColor forState:UIControlStateNormal];
        }
        if (self.butTitleSelectedColor) {
            [buyButton setTitleColor:self.butTitleSelectedColor forState:UIControlStateSelected];
        }
        if (self.buttonBackGroundImage) {
            [buyButton setBackgroundImage:self.buttonBackGroundImage forState:UIControlStateNormal];
        }
        if (self.buttonSelectedBackGroundImage) {
            [buyButton setBackgroundImage:self.buttonSelectedBackGroundImage forState:UIControlStateSelected];
        }
        [self.buttonsArray addObject:buyButton];
        [self addSubview:buyButton];
        
        //选中
        if ([self.chosedArray containsObject:title]) {
            if (self.buttonSelctedBackGroundColor) {
                buyButton.backgroundColor = self.buttonSelctedBackGroundColor;
            }
            
        }else{
            if (self.buttonBackGroundColor) {
                buyButton.backgroundColor = self.buttonBackGroundColor;
            }
        }
        buyButton.left = left;
        buyButton.top = top;
        
        if (self.direction == TMTagMenuViewDirectionVertical) {
            left = buyButton.right + insetX;
            if (buyButton.right >  self.width) {
                buyButton.left = insetX;
                left = buyButton.right + insetX;
                top = buyButton.bottom + insetX;
                buyButton.top = top;
            }
        }else{
            left = buyButton.right + insetX;
        }

        [buyButton st_setBorderWith:1 borderColor:SecendTextColor cornerRadius:yuanjiao];
        if (self.buttonBoderColor) {
            [buyButton st_setBorderWith:1 borderColor:self.buttonBoderColor cornerRadius:yuanjiao];
        }
        if ([self.chosedArray containsObject:title]) {
            [buyButton st_setBorderWith:1 borderColor:TM_YellowBackGroundColor cornerRadius:yuanjiao];
            if (self.buttonSelectedBoderColor) {
                [buyButton st_setBorderWith:1 borderColor:self.buttonSelectedBoderColor cornerRadius:yuanjiao];
            }
            buyButton.selected = YES;
        }
        
        self.height = buyButton.bottom + insetY;
        if (self.direction == TMTagMenuViewDirectionHorizontal) {
            self.width = buyButton.right + insetY;
        }
    }
}

- (void)onSelctedItemButton:(UIButton*)sender{
    CGFloat yuanjiao = itemcornerRadius;
    if (_cornerRadius >= 0) {
        yuanjiao = _cornerRadius;
    }
    if (self.allowsMultipleSelection) {
        sender.selected = !sender.selected;
        [sender st_setBorderWith:1 borderColor:TM_YellowBackGroundColor cornerRadius:yuanjiao];
        if (sender.selected) {
            if (self.buttonSelectedBoderColor) {
                [sender st_setBorderWith:1 borderColor:self.buttonSelectedBoderColor cornerRadius:yuanjiao];
            }
            if (self.buttonSelctedBackGroundColor) {
                sender.backgroundColor = self.buttonSelctedBackGroundColor;
            }
        }else{
            if (self.buttonBoderColor) {
                [sender st_setBorderWith:1 borderColor:self.buttonBoderColor cornerRadius:yuanjiao];
            }
            if (self.buttonBackGroundColor) {
                sender.backgroundColor = self.buttonBackGroundColor;
            }
        }
        
    }else{
        NSInteger index = sender.tag - 10000;
        if (self.onSlectedTagView) {
            self.onSlectedTagView(self, sender.currentTitle,index);
        }
        for (UIButton * button in self.buttonsArray) {
            button.selected = NO;
            sender.selected = YES;
            if (button.selected) {
                [sender st_setBorderWith:1 borderColor:TM_YellowBackGroundColor cornerRadius:yuanjiao];
                if (self.buttonSelectedBoderColor) {
                    [button st_setBorderWith:1 borderColor:self.buttonSelectedBoderColor cornerRadius:yuanjiao];
                }
                if (self.buttonSelctedBackGroundColor) {
                    button.backgroundColor = self.buttonSelctedBackGroundColor;
                }
                
            }else{
                [button st_setBorderWith:1 borderColor:SecendTextColor cornerRadius:yuanjiao];
                if (self.buttonBoderColor) {
                    [button st_setBorderWith:1 borderColor:self.buttonBoderColor cornerRadius:yuanjiao];
                }
                if (self.buttonBackGroundColor) {
                    button.backgroundColor = self.buttonBackGroundColor;
                }
            }
        }
    }
    
    
}
- (void)cancleSelctedAllItem{
    CGFloat yuanjiao = itemcornerRadius;
    if (_cornerRadius >= 0) {
        yuanjiao = _cornerRadius;
    }
    for (UIButton * button in self.buttonsArray) {
        button.selected = NO;
        if (button.selected) {
            [button st_setBorderWith:1 borderColor:TM_YellowBackGroundColor cornerRadius:yuanjiao];
            if (self.buttonSelectedBoderColor) {
                [button st_setBorderWith:1 borderColor:self.buttonSelectedBoderColor cornerRadius:yuanjiao];
            }
            if (self.buttonSelctedBackGroundColor) {
                button.backgroundColor = self.buttonSelctedBackGroundColor;
            }
            
        }else{
            [button st_setBorderWith:1 borderColor:SecendTextColor cornerRadius:yuanjiao];
            if (self.buttonBoderColor) {
                [button st_setBorderWith:1 borderColor:self.buttonBoderColor cornerRadius:yuanjiao];
            }
            if (self.buttonBackGroundColor) {
                button.backgroundColor = self.buttonBackGroundColor;
            }
        }
    }
}
- (UIButton *)findButtonWithTitle:(NSString *)title{
    for (UIButton * button in self.buttonsArray) {
        if ([button.currentTitle isEqualToString:title]) {
            return button;
        }
    }
    return nil;
}
@end
