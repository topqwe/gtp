//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "ModifyAdsSectionHeaderView.h"
#define kModifyAdsHeightForHeaderInSections  50//19+25+19
@interface ModifyAdsSectionHeaderView()
@property (nonatomic, strong) NSMutableArray *btns;
@property(nonatomic,strong)UIImageView* sectionLine;
@end

@implementation ModifyAdsSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[ModifyAdsSectionHeaderView class] forHeaderFooterViewReuseIdentifier:ModifyAdsSectionHeaderReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];

        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kModifyAdsHeightForHeaderInSections);
        
        _btns = [NSMutableArray array];
        
        self.backgroundColor = kWhiteColor;
        
        for (int i = 0; i < 2; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag =  i;
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//            [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:button];
            [_btns addObject:button];
        }
        UIButton* bt0 =_btns[0];
        bt0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;

        UIButton* bt1 =_btns[1];
        bt1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        
        [@[_btns[0],_btns[1]] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:MAINSCREEN_WIDTH/2 leadSpacing:20 tailSpacing:20];
        
        [@[_btns[0],_btns[1]] mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@13);
            make.height.mas_equalTo(@24);
        }];
        
        _sectionLine = [[UIImageView alloc]init];
        _sectionLine.backgroundColor = HEXCOLOR(0xf0f1f3);
        [self.contentView addSubview:self.sectionLine];
        [_sectionLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self).offset(0);
            make.top.equalTo(bt1.mas_bottom).offset(13);
            make.height.mas_equalTo(@.5);
        }];
        
        
    }
    return self;
}


- (void)setDataWithType:(IndexSectionType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle withImg:(NSString*)img{
    UIButton* bt0 =_btns[0];
    [bt0 setTitle:title forState:UIControlStateNormal];
    UIButton* bt1 =_btns[1];
    [bt1 setTitle:subTitle forState:UIControlStateNormal];
    
    switch (type) {
            
        case IndexSectionZero:
        {
            [bt0 setTitleColor:HEXCOLOR(0x394368) forState:UIControlStateNormal];
            bt0.titleLabel.font = kFontSize(17);
            [bt1 setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
            bt1.titleLabel.font = kFontSize(17);

        }
            break;
        default:{
            
            
        }
            break;
    }
}

+ (CGFloat)viewHeight
{
    return 51;
}
@end


@interface ModifyAdsSectionFooterView ()

@property (nonatomic, copy) ActionBlock block;

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *selectedBtns;

@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@end


@implementation ModifyAdsSectionFooterView

+ (void)sectionFooterViewWith:(UITableView*)tableView{
    [tableView registerClass:[ModifyAdsSectionFooterView class] forHeaderFooterViewReuseIdentifier:ModifyAdsSectionFooterReuseIdentifier];
}
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self _initObject];
    }
    return self;
}

- (void)_initObject
{
    
    self.contentView.backgroundColor = kWhiteColor;
    self.backgroundView = [[UIView alloc] init];
    
    //self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kOrderDetailHeightForHeaderInSections);
    _btns = [NSMutableArray array];
    
    _selectedBtns = [NSMutableArray array];
    
    _funcBtns = [NSMutableArray array];
    
    self.backgroundColor = kWhiteColor;
    NSArray* titleArray =@[@"需要",@"不与"];
    for (int i = 0; i < titleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
//                    button.layer.masksToBounds = YES;
//                    button.layer.cornerRadius = 17.5;
//                    button.layer.borderWidth = 0.5;
//                    button.layer.borderColor = RGBCOLOR(225, 218, 216).CGColor;
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        //        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        
        [button setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"checkbox-checked"] forState:UIControlStateSelected];
        
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        [_btns addObject:button];
        [_btns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    UIButton* bt0 =_btns[0];
    bt0.selected = YES;
    UIButton* bt1 =_btns[1];
    bt1.selected = YES;
    
    [_selectedBtns addObjectsFromArray:@[bt0,bt1]];
    
    
    [_btns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:15 leadSpacing:10 tailSpacing:72];
    
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self).offset(24);
        make.height.mas_equalTo(@15);
    }];

    _line1 = [[UIImageView alloc]init];
    _line1.backgroundColor = HEXCOLOR(0xe6e6e6);
    [self addSubview:_line1];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self).offset(0);
        make.top.equalTo(bt1.mas_bottom).offset(23);
        make.height.mas_equalTo(@.5);
    }];
    
//    return;
    NSArray* subtitleArray =@[@"修改勃勃生机",@"朋友"];
    for (int i = 0; i < subtitleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i+2;
        
        button.titleLabel.font = kFontSize(15);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        button.layer.borderWidth = 1;
        button.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        [button setTitle:subtitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        [_funcBtns addObject:button];
//        [_fucBtns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    UIButton* bt2 =_funcBtns.firstObject;
    [bt2 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    [bt2 setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    
    
    UIButton* bt3 =_funcBtns.lastObject;
    [bt3 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
    [bt3 setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:16 tailSpacing:16];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
 make.top.equalTo(self.line1.mas_bottom).offset(3.5);
        
        make.height.mas_equalTo(@42);
    }];
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
    if ([_selectedBtns containsObject:_btns[0]]) {
//        [_postAdsButton setBackgroundImage:[UIImage imageWithColor:[YBGeneralColor themeColor]] forState:UIControlStateNormal];
//        _postAdsButton.userInteractionEnabled = YES;
        
    }else{
//        [_postAdsButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x9b9b9b)] forState:UIControlStateNormal];
//        _postAdsButton.userInteractionEnabled = NO;
    }
    if (self.block)
    {
        self.block(@(button.tag));
    }
}
- (void)funAdsButtonClickItem:(UIButton*)button{
    if (self.block)
    {
        self.block(@(button.tag));
    }
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)setDataWithType:(IndexSectionType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle{
    
    
    switch (type) {
        case IndexSectionTwo:
        {
            
        }
            break;
        default:
        {
            
        }
            break;
    }
}



+ (CGFloat)viewHeightWithType:(IndexSectionType)type
{
    switch (type) {
        
       
        case IndexSectionTwo:
        {
            return 137;
        }
            break;
        default:
            return 180;
            break;
    }
}
@end
