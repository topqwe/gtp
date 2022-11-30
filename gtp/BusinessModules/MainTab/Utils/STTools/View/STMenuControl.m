//
//  STMenuControl.m
//  blanket
//
//  Created by Mac on 2017/12/5.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STMenuControl.h"

@implementation STMenuControl

- (instancetype)initWithFrame:(CGRect)frame
                    imageName:(NSString *)imageName
                        title:(NSString *)title
                   titleColor:(UIColor *)titleColor{
    if (self == [super initWithFrame:frame]) {
        
//        self.imageButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 44, 44)];
//        self.imageButton.centerX = self.width / 2;
//        [self.imageButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
//        self.imageButton.userInteractionEnabled = NO;
//        [self addSubview:self.imageButton];
        
        self.imageButton = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 44, 44)];
        self.imageButton.centerX = self.width / 2;
        self.imageButton.contentMode = UIViewContentModeScaleAspectFill;
        [self.imageButton setImage:[UIImage imageNamed:imageName]];
        [self addSubview:self.imageButton];
        
        UILabel * titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, self.imageButton.bottom + 10, self.width, 15)];
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.text = title;
        titleLable.font = [UIFont systemFontOfSize:14];
        titleLable.textColor = titleColor;
        titleLable.numberOfLines = 0;;
        self.titleLable = titleLable;                             
        [self addSubview:titleLable];
        [self addTarget:self action:@selector(controlDidSelcted:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
- (void)controlDidSelcted:(STMenuControl*)sender{
    if (self.onSelctedControl) {
        self.onSelctedControl(sender);
        [self st_showImpactFeedbackGenerator:UIImpactFeedbackStyleHeavy];
    }
}
@end
