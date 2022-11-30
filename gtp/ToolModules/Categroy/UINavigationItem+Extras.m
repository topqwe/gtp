//
//  UINavigationItem+Extras.m
//  PhoneZhuan
//
//  Created by WIQ on 14-2-17.
//  Copyright (c) 2014年 shen. All rights reserved.
//

#import "UINavigationItem+Extras.h"
#define kTitleColor YBGeneralColor.navigationBarTitleColor //RGBCOLOR(100, 83, 79)
#define kSeachBackgroundColor RGBSAMECOLOR(246)
@implementation UINavigationItem (Extras)

- (UIButton *) createNavtgationItemButton:(CGRect)frame normalImage:(UIImage *)normalImage highlightImage:(UIImage *)highlightImage title:(NSString *)title viewController:(id)viewController action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:normalImage forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 25)];
    [button addTarget:viewController action:action forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

-(void)addNavTitle:(NSString *)title withTitleColor:(UIColor*)titleColor
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200, 36)];
    titleLabel.backgroundColor = kClearColor;
    titleLabel.textColor = titleColor;
    titleLabel.font = kFontSize(18);
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel sizeToFit];
    
    self.titleView = titleLabel;
}

-(void)addCenterSearchNav:(id)target keyWord:(NSString*)keyword actionMethod:(SEL)actionMethod
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(54, 0, MAINSCREEN_WIDTH - 54 -37, 30);
    searchBtn.backgroundColor = kSeachBackgroundColor;
    searchBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [searchBtn setImage:[UIImage imageNamed:@"cityfindicon"] forState:UIControlStateNormal];
    [searchBtn setTitle: keyword.length>0?keyword:@"输入商品名" forState:UIControlStateNormal];///店铺
    [searchBtn setTitleColor:kGrayColor forState:UIControlStateNormal];
    searchBtn.titleLabel.font = kFontSize(15);
    searchBtn.adjustsImageWhenHighlighted= NO;
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 30/2;
    [searchBtn addTarget:target action:actionMethod forControlEvents:UIControlEventTouchUpInside];
    self.titleView = searchBtn;
    
}

-(void)addCenterAligSearchNav:(id)target actionMethod:(SEL)actionMethod withPalaceholdTitle:(NSString*)palaceHoldString
{
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(15, 0, MAINSCREEN_WIDTH - 2*15, 30);
    searchBtn.backgroundColor = kSeachBackgroundColor;
    searchBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 0);
    [searchBtn setImage:[UIImage imageNamed:@"cityfindicon"] forState:UIControlStateNormal];
    [searchBtn setTitle:palaceHoldString forState:UIControlStateNormal];///店铺
    [searchBtn setTitleColor:kGrayColor forState:UIControlStateNormal];
    searchBtn.titleLabel.font = kFontSize(15);
    searchBtn.adjustsImageWhenHighlighted= NO;
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 30/2;
    [searchBtn addTarget:target action:actionMethod forControlEvents:UIControlEventTouchUpInside];
    self.titleView = searchBtn;
    
}

- (void)addDefaultBackButton:(id)viewController actionMethod:(SEL)actionMethod andImage:(UIImage *)titImg
{
    UIButton *bgButton = [self createNavtgationItemButton:CGRectMake(0, 0, 37, 37) normalImage:nil highlightImage:nil title:nil viewController:viewController action:actionMethod];
    UIImage *backImage =titImg;
    
    UIButton *backButton = [self createNavtgationItemButton:CGRectMake( 0, 0, 37, 37) normalImage:backImage highlightImage:backImage title:nil viewController:viewController action:actionMethod];
    
    [bgButton addSubview:backButton];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bgButton];
    self.leftBarButtonItem = leftButtonItem;
}

- (void)addDefaultRightButton:(id)viewController actionMethod:(SEL)actionMethod
{
    UIButton *bgButton = [self createNavtgationItemButton:CGRectMake(0, 0, 44, 44) normalImage:nil highlightImage:nil title:nil viewController:viewController action:actionMethod];
    
    UIImage *itemImage = [UIImage imageNamed:@"rightButtonEvent"];
    UIButton *rightButton = [self createNavtgationItemButton:CGRectMake(17, 10.5, 25, 23) normalImage:itemImage highlightImage:itemImage title:nil viewController:viewController action:actionMethod];
    [bgButton addSubview:rightButton];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:bgButton];
    self.rightBarButtonItem = rightItem;
}



-(void)addRightButtons:(id)target withFirstBtnImage:(UIImage *)image1 andFirstBtnTitle:(NSString *)title1 withSecondBtnImage:(UIImage *)image2 andSecondBtnTitle:(NSString *)title2{
//    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [rightButton setFrame:CGRectMake(0, 0, 37, 37)];
//    rightButton.tag = 888;
//    [rightButton setImage:image forState:UIControlStateNormal];
//    [rightButton setTitle:title forState:UIControlStateNormal];
//    
//    rightButton.titleLabel.font  = kFontSize(17);
//    [rightButton setTitleColor:kTitleColor forState:UIControlStateNormal] ;
//    rightButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    
//    rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//    rightButton.adjustsImageWhenHighlighted= NO;
//    
//    [rightButton addTarget:target action:@selector(rightButtonEvent)forControlEvents:UIControlEventTouchUpInside];//function rightButtonEvent must add
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
//    self.rightBarButtonItem = rightItem;
    
    UIButton *informationCardBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    informationCardBtn.tag = 80;
    [informationCardBtn addTarget:self action:@selector(firstRightButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [informationCardBtn setImage:image1 forState:UIControlStateNormal];
    [informationCardBtn setTitle:title1 forState:UIControlStateNormal];
    
    informationCardBtn.titleLabel.font  = kFontSize(17);
    [informationCardBtn setTitleColor:kTitleColor forState:UIControlStateNormal];

    [informationCardBtn sizeToFit];
    UIBarButtonItem *informationCardItem = [[UIBarButtonItem alloc] initWithCustomView:informationCardBtn];
    
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedSpaceBarButtonItem.width = 18;
    
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.tag = 81;
    [settingBtn addTarget:self action:@selector(secondRightButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
    [settingBtn setImage:image2 forState:UIControlStateNormal];
    [settingBtn setTitle:title2 forState:UIControlStateNormal];
    
    settingBtn.titleLabel.font  = kFontSize(17);
    [settingBtn setTitleColor:kTitleColor forState:UIControlStateNormal];
    [settingBtn sizeToFit];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
    
    
    self.rightBarButtonItems  = @[informationCardItem,fixedSpaceBarButtonItem,settingBtnItem];
    
}

-(void)addCustomLeftButton:(id)target withImage:(UIImage *)image andTitle:(NSString *)title{
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.tag = 999;
    [leftButton setFrame:CGRectMake(0, 0, 54, 54)];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton setTitle:title forState:UIControlStateNormal];
    
    leftButton.titleLabel.font  = kFontSize(17);
    [leftButton setTitleColor:HEXCOLOR(0xf4f4f4) forState:UIControlStateNormal] ;
    leftButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    leftButton.adjustsImageWhenHighlighted= NO;
    [leftButton addTarget:target action:@selector(leftButtonEvent)forControlEvents:UIControlEventTouchUpInside];   //function leftButtonEvent must add
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.leftBarButtonItem = leftItem;
}

-(void)addCustomRightButton:(id)target withImage:(UIImage *)image andTitle:(NSString *)title{
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 44, 44)];
    rightButton.tag = 888;
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton setTitle:title forState:UIControlStateNormal];
    
    rightButton.titleLabel.font  = kFontSize(17);
    [rightButton setTitleColor:kTitleColor forState:UIControlStateNormal] ;
    rightButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;

    rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    rightButton.adjustsImageWhenHighlighted= NO;
    
    [rightButton addTarget:target action:@selector(rightButtonEvent)forControlEvents:UIControlEventTouchUpInside];//function rightButtonEvent must add
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.rightBarButtonItem = rightItem;
}



- (void)addCustomNaviButtonWithIsRight:(BOOL)isRight image:(UIImage *)image title:(NSString *)title target:(id)target action:(SEL)action {
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 37, 37)];
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton setTitle:title forState:UIControlStateNormal];
    rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    rightButton.adjustsImageWhenHighlighted= NO;
    
    [rightButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    if (isRight) {
        self.rightBarButtonItem = rightItem;
    }else{
        self.leftBarButtonItem = rightItem;
    }
    
}

- (void)addSimpleTitleView:(NSString *)title FontSize:(UIFont *)font MaxWidth:(float)maxWidth MaxHeight:(float)maxHeight{
    UILabel * tl = nil;
    if (self.titleView && [self.titleView isKindOfClass:[UILabel class]]) {
        tl = (UILabel *) self.titleView;
        tl.text = title;
        tl.textAlignment=NSTextAlignmentCenter;
        [tl autoHeightWithin:maxHeight];
    }else{
        
        tl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, maxWidth, maxHeight)];
        tl.text = title;
        tl.textColor = [UIColor whiteColor];
        tl.backgroundColor = [UIColor clearColor];
        tl.textAlignment=NSTextAlignmentCenter;
        tl.font = font;
        [tl autoHeightWithin:maxHeight];
        self.titleView = tl;
    }
    tl.textColor = kTitleColor;
    tl.font = [UIFont systemFontOfSize:18];
}

- (void)addForumContentNavTitleView:(id)owner selector:(SEL)selector title:(NSString *)title
{
    UIButton *btnBg = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnBg addTarget:owner action:selector forControlEvents:UIControlEventTouchUpInside];
    [btnBg setBackgroundColor:[UIColor clearColor]];
    [btnBg setFrame:CGRectMake(0, 0, 100, 45)];
    
    
    CGSize size;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        NSDictionary *attributes = @{NSFontAttributeName:btnBg.titleLabel.font};
        CGRect rectSize = [title boundingRectWithSize:CGSizeMake(90, MAXFLOAT)
                                            options:NSStringDrawingUsesLineFragmentOrigin
                                         attributes:attributes
                                            context:nil];
        size = CGSizeMake(rectSize.size.width, rectSize.size.height);
    }
//    else
//    {
//        size = [title
//                  sizeWithFont:btnBg.titleLabel.font
//                  constrainedToSize:CGSizeMake(90, MAXFLOAT)
//                  lineBreakMode:NSLineBreakByWordWrapping];
//
//    }
    
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    [lblTitle setTextAlignment:NSTextAlignmentLeft];
    [lblTitle setText:title];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setFont:[UIFont systemFontOfSize:18]];
    [lblTitle setTextColor:kTitleColor];
    [btnBg addSubview:lblTitle];
    
    [lblTitle setFrame:CGRectMake(50- size.width/2, 0, size.width, 45)];
    //10 × 8
    if (size.width > 90) {
        size.width = 90;
    }
    UIImageView *imageArrow = [[UIImageView alloc] initWithFrame:CGRectMake(lblTitle.origin.x + size.width +3, 18, 11, 11)];
    [imageArrow setImage:[UIImage imageNamed:@"newDown"]];
    [btnBg addSubview:imageArrow];
    
    self.titleView = btnBg;
}

- (void)firstRightButtonEvent:(UIButton*)sender{
    
}
- (void)secondRightButtonEvent:(UIButton*)sender{
    
}
- (void)leftButtonEvent{
    
}
- (void)rightButtonEvent{
    
}
@end

