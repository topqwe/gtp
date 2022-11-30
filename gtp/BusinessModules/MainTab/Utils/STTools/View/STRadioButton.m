//
//  STRadioButton.m
//  STTools
//  Created by stoneobs on 16/3/17.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STRadioButton.h"
#define STRadioButtonNormalImage [UIImage imageNamed:@"icon_unselected"]
#define STRadioButtonSlectedImage [UIImage imageNamed:@"icon_selected"]
@interface STRadioButton()
@property(nonatomic,strong)NSMutableArray<UIButton*>        *butArray;
@end
@implementation STRadioButton
- (instancetype)initWithFrame:(CGRect)frame
                       titles:(NSArray *)titles
                     itemSize:(CGSize)itemSize
                    itemInset:(UIEdgeInsets)itemInset{
    if (self == [super initWithFrame:frame]) {
        
        self.butArray = [[NSMutableArray alloc] init];
        CGFloat buttonWitdh = itemSize.width;
        CGFloat buttonHeight = itemSize.height;
        NSInteger count = titles.count;
        CGFloat topInset = itemInset.top;
        CGFloat leftInset = itemInset.left;
        CGFloat top = topInset;
        CGFloat left = leftInset;
        for (int i = 0; i < count; i++) {
            UIButton * but = [[UIButton alloc]initWithFrame:CGRectMake(left, top,buttonWitdh, buttonHeight)];
            [but setImage:STRadioButtonSlectedImage forState:UIControlStateSelected];
            [but setImage:STRadioButtonNormalImage forState:UIControlStateNormal];
            [but setTitle:titles[i] forState:UIControlStateNormal];
            [but setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            but.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            but.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
            [but addTarget:self action:@selector(onSlectedButton:) forControlEvents:UIControlEventTouchUpInside];
            but.tag = 10000 + i;
            [but.titleLabel setFont:[UIFont systemFontOfSize:15]];
            [self addSubview:but];
            [self.butArray addObject:but];
            if (but.right > UIScreen.mainScreen.bounds.size.width) {
                but.left = leftInset;
                top = but.bottom + topInset;
                but.top = top;
            }
            left = but.right + leftInset;
            self.height = but.bottom + topInset;
        }
        
    }
    return self;
    
}
#pragma mark --Action Method
-  (void)onSlectedButton:(UIButton*)sender
{
    UIButton * but = sender;
    for (UIButton * button in self.butArray) {
        button.selected = NO;
    }
    but.selected = YES;
    _chosedIndex  = but.tag - 10000;
}
#pragma mark --Getter And Setter
- (void)setChosedIndex:(NSInteger)chosedIndex{
   
    for (UIButton * button in self.butArray) {
        button.selected = NO;
        if (button.tag - 10000 == chosedIndex) {
            button.selected = YES;
            self.chosedTitle = button.currentTitle;
             _chosedIndex = chosedIndex;
        }
    }
}
- (void)setChosedTitle:(NSString *)chosedTitle{
   
    for (UIButton * button in self.butArray) {
        button.selected = NO;
        if ([button.currentTitle isEqualToString:chosedTitle]) {
            button.selected = YES;
            self.chosedIndex = button.tag - 10000;
            _chosedTitle = chosedTitle;
        }
    }
}
- (void)setTitleColor:(UIColor *)titleColor
{
    _titleColor = titleColor;
    for (UIButton * but in self.butArray) {
        [but setTitleColor:titleColor forState:UIControlStateNormal];
    }
}
- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor
{
    _selectedTitleColor = selectedTitleColor;
    for (UIButton * but in self.butArray) {
        [but setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    }

}
- (NSArray *)buttonArray{
    return self.butArray.mutableCopy;
}
@end
