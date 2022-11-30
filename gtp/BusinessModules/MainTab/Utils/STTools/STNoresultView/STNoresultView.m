//
//  STNoresultView.m
//  KunLun
//
//  Created by Mac on 2017/11/27.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "STNoresultView.h"
@interface  STNoresultView()
@property(nonatomic, strong) STButton                     *button;
@end
@implementation STNoresultView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                  buttonTitle:(NSString *)buttonTitle
                 buttonHandle:(void (^)(NSString *))handle{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView * iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,self.frame.size.width, 200)];
        iconImageView.image = [UIImage imageNamed:@"img_empty"];
        iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:iconImageView];

        STLabel * titleLable = [[STLabel alloc] initWithFrame:CGRectMake(0, iconImageView.st_bottom + 20, self.st_width, 15)
                                                         text:title
                                                    textColor:SecendTextColor
                                                         font:13
                                                  isSizetoFit:NO
                                                textAlignment:NSTextAlignmentCenter];
        [self addSubview:titleLable];
        self.titleLable = titleLable;
        
        
        STButton * buyButton = [[STButton alloc] initWithFrame:CGRectMake(0, titleLable.st_bottom + 15, self.width, 44)
                                                         title:buttonTitle
                                                    titleColor:UIColor.blackColor
                                                     titleFont:15
                                                  cornerRadius:5
                                               backgroundColor:TM_backgroundColor
                                               backgroundImage:nil
                                                         image:nil];
        buyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        [buyButton st_setBorderWith:1 borderColor:TM_ThemeBackGroundColor cornerRadius:5];
        buyButton.st_centerX = self.st_width / 2;
        buyButton.backgroundColor = UIColor.clearColor;
        [buyButton setClicAction:^(UIButton *sender) {
            if (handle) {
                handle(sender.currentTitle);
            }
        }];
        self.menuButton = buyButton;
        [self addSubview:buyButton];
        self.clipsToBounds = YES;
        self.st_centerX = UIScreenWidth / 2;
        self.button = buyButton;
//        buyButton.hidden = !buttonTitle.length;
    }
    return self;
}
- (void)setBorderColor:(UIColor *)borderColor{
    _borderColor = borderColor;
    [self.button st_setBorderWith:1 borderColor:borderColor cornerRadius:5];
}
@end
