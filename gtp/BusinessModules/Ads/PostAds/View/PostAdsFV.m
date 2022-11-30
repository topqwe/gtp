//  HHL
//
//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "PostAdsFV.h"

@interface PostAdsFV ()
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *selectedBtns;
@property (nonatomic, strong) UIButton *ruleButton;
@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, copy) ActionBlock block;

@end

@implementation PostAdsFV

- (instancetype)initWithFrame:(CGRect)frame WithModel:(NSArray*)titleArray{
    self = [super initWithFrame:frame];
    if (self) {
        _btns = [NSMutableArray array];
        _selectedBtns = [NSMutableArray array];
        self.backgroundColor = kWhiteColor;
        
        for (int i = 0; i < titleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag =  i;
        
            button.titleLabel.font = [UIFont systemFontOfSize:14];
//            button.layer.masksToBounds = YES;
//            button.layer.cornerRadius = 17.5;
//            button.layer.borderWidth = 0.5;
//            button.layer.borderColor = RGBCOLOR(225, 218, 216).CGColor;
            [button setTitle:titleArray[i] forState:UIControlStateNormal];
            
            [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    //        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            
            [button setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"checkbox-checked"] forState:UIControlStateSelected];
            
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            [_btns addObject:button];
            [_btns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    UIButton* bt0 =_btns[0];
    bt0.selected = YES;
    UIButton* bt1 =_btns[1];
    bt1.selected = YES;
    
    [_selectedBtns addObjectsFromArray:@[bt0,bt1]];
    UIButton* bt2 =_btns[2];
        
    [@[_btns[0],_btns[1]] mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:15 leadSpacing:0 tailSpacing:140];
        
    [@[_btns[0],_btns[1]] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(24);
//            make.centerY.equalTo(self);
//            make.width.mas_equalTo(@20);
            make.height.mas_equalTo(@15);
        }];

    
    [_btns[2] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(80);
            make.top.equalTo(bt1.mas_bottom).offset(50);
            make.height.mas_equalTo(@17);
        }];
        
    _ruleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _ruleButton.tag = EnumActionTag3;
    _ruleButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [_ruleButton setTitle:@"《规则》" forState:UIControlStateNormal];
    [_ruleButton setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    [_ruleButton addTarget:self action:@selector(postAdsAndRuleButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_ruleButton];
    [_ruleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bt2.mas_right).offset(0);
        make.top.equalTo(bt2.mas_top);
        make.height.mas_equalTo(@15);
    }];
    
    
    _line1 = [[UIImageView alloc]init];
    _line1.backgroundColor = HEXCOLOR(0xe6e6e6);
    [self addSubview:_line1];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
//   make.centerX.equalTo(self);
        make.top.equalTo(self.ruleButton.mas_bottom).offset(20);
        make.height.equalTo(@.5);
        make.width.equalTo(@(MAINSCREEN_WIDTH));
    }];
    
    
    _postAdsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _postAdsButton.tag = EnumActionTag4;
    _postAdsButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_postAdsButton setTitle:@"发布勃勃生机" forState:UIControlStateNormal];
    [_postAdsButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _postAdsButton.layer.masksToBounds = YES;
    _postAdsButton.layer.cornerRadius = 4;
    _postAdsButton.layer.borderWidth = 0;
//        _postAdsButton.layer.borderColor = HEXCOLOR(0x9b9b9b).CGColor;
   
    [_postAdsButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x9b9b9b)] forState:UIControlStateNormal];
    _postAdsButton.userInteractionEnabled = YES;
    [_postAdsButton addTarget:self action:@selector(postAdsAndRuleButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_postAdsButton];
    [_postAdsButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.line1.mas_bottom).offset(6);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(@42);
        make.width.mas_equalTo(@327);
    }];
    }
    return self;
}


- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)postAdsAndRuleButtonClickItem:(UIButton*)button{
    if (self.block) {
        self.block(@(button.tag));
    }
}

- (void)clickItem:(UIButton*)button{
    NSString* btnTit = @"";
    button.selected = !button.selected;
    if (button.selected) {
//        for (UIButton *btn in self.btns) {
//            btn.selected = NO;
//        }
        UIButton *tagBtn = [self.btns objectAtIndex:button.tag];
        tagBtn.selected = YES;
        
        btnTit = button.titleLabel.text;
        [_selectedBtns addObject:tagBtn];
    } else {
        btnTit = @"";
        [_selectedBtns removeObject:button];
    }
    
    if ([_selectedBtns containsObject:_btns[2]]) {
        [_postAdsButton setBackgroundImage:[UIImage imageWithColor:[YBGeneralColor themeColor]] forState:UIControlStateNormal];
        _postAdsButton.userInteractionEnabled = YES;
        
    }else{
        [_postAdsButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x9b9b9b)] forState:UIControlStateNormal];
        _postAdsButton.userInteractionEnabled = NO;
    }
    if (self.block) {
        self.block(@(button.tag));
    }
}
- (void)richElementsInHeaderWithModel:(NSDictionary*)data{
    
}
@end
