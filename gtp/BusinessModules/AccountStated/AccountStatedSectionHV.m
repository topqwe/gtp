//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "AccountStatedSectionHV.h"
#define kAccountStatedSectionHVHeight 99//38+5

@interface AccountStatedSectionHV ()
@property(nonatomic,strong)UIImageView* headerSectionLine;
@property (nonatomic, strong) UIButton *tipButton;
@property(nonatomic,strong)UIImageView* sectionLine;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@end

@implementation AccountStatedSectionHV
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[AccountStatedSectionHV class] forHeaderFooterViewReuseIdentifier:AccountStatedSectionHVReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        _funcBtns = [NSMutableArray array];
        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];

        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kAccountStatedSectionHVHeight);
        
        self.headerSectionLine = [[UIImageView alloc]init];
        self.headerSectionLine.backgroundColor = HEXCOLOR(0xf6f5fa);
        [self.contentView addSubview:self.headerSectionLine];
        [self.headerSectionLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.height.equalTo(@8);
            make.leading.trailing.equalTo(@0);
        }];
        
        self.sectionLine = [[UIImageView alloc]init];
        self.sectionLine.backgroundColor = HEXCOLOR(0xf0f1f3);
        [self.contentView addSubview:self.sectionLine];
        [self.sectionLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-44);
            make.height.equalTo(@2);
            make.leading.trailing.equalTo(@0);
        }];
        
        self.tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.tipButton.userInteractionEnabled = NO;
        self.tipButton.adjustsImageWhenHighlighted = NO;
        self.tipButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        [self.tipButton setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        self.tipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.contentView addSubview:self.tipButton];
        [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.sectionLine.mas_top);
            make.top.equalTo(self.headerSectionLine.mas_bottom);
            make.leading.equalTo(@20);
//            make.height.equalTo(@20);
        }];
        
        NSArray* subtitleArray =@[@"",@""];
        for (int i = 0; i < subtitleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag =  i;
            button.adjustsImageWhenHighlighted = NO;
            button.titleLabel.font = kFontSize(15);
//            button.layer.masksToBounds = YES;
//            button.layer.cornerRadius = 6;
//            button.layer.borderWidth = 1;
            
            [button setTitle:subtitleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [_funcBtns addObject:button];
            //        [_fucBtns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        }
        
        
        [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:20 tailSpacing:20];
        
        [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sectionLine.mas_bottom).offset(15);
//            make.bottom.equalTo(self.sectionLine.mas_top);
//            make.top.equalTo(self.headerSectionLine.mas_bottom);
        }];
        
        
    }
    return self;
}


- (void)richElementsInViewWithModel:(NSDictionary*)model{
    self.sectionLine.hidden = NO;
    self.headerSectionLine.hidden = NO;
//    switch (type) {
//        case IndexSectionZero:{
            _headerSectionLine.hidden = NO;
            _sectionLine.hidden = NO;
            UIButton* btn0 =_funcBtns.firstObject;
            [btn0 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
            [btn0 setTitleColor:HEXCOLOR(0xe22323) forState:UIControlStateNormal];
            [btn0 setTitle:[NSString stringWithFormat:@"支出：¥ %@",model[kTit]] forState:UIControlStateNormal];
            btn0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            UIButton* btn1 =_funcBtns.lastObject;
            [btn1 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
            [btn1 setTitleColor:HEXCOLOR(0x21c244) forState:UIControlStateNormal];
            [btn1 setTitle:[NSString stringWithFormat:@"🎂：¥ %@",model[kSubTit]] forState:UIControlStateNormal];
    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
            [self.tipButton setTitle:model[kDate] forState:UIControlStateNormal];
//        }
//            break;
////
//        default:{
//            _headerSectionLine.hidden = NO;
//            _sectionLine.hidden = YES;
//        }
//            break;
//    }
}

- (void)refreshTopic:(UIButton*)sender {
}
+ (CGFloat)viewHeight
{
    return kAccountStatedSectionHVHeight;
}

- (void)richElementsInBalanceSourceHVWithModel:(NSDictionary*)model{
//    [self.tipButton setTitle:model[kDate] forState:UIControlStateNormal];
    self.sectionLine.hidden = true;
    self.contentView.backgroundColor = HEXCOLOR(0xf6f5fa);
    UIButton* btn0 =_funcBtns.firstObject;
    
    [btn0 setTitleColor:HEXCOLOR(0xe22323) forState:UIControlStateNormal];
    [btn0 setTitle:[NSString stringWithFormat:@"%@日",[model[kDate] substringFromIndex:8]] forState:UIControlStateNormal];
    btn0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn0.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    btn0.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [btn0 setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
    
}
+ (CGFloat)balanceSourceHVHeight{
    return kAccountStatedSectionHVHeight/2;
}
@end
