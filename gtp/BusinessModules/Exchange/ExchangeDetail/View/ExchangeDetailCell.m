//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "ExchangeDetailCell.h"
#import "ExchangeDetailModel.h"

@interface ExchangeDetailCell ()
@property (nonatomic, strong) NSMutableArray *btns;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* titleBtn;
@end

@implementation ExchangeDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.contentView.backgroundColor = kWhiteColor;
    self.backgroundView = [[UIView alloc] init];
    
    
    _btns = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.tag =  i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        //        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        
        [button setTitleColor:HEXCOLOR(0x394368) forState:UIControlStateNormal];
        //        [button setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        
        //        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        [_btns addObject:button];
        //        [_btns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    UIButton* bt0 =_btns[0];
    bt0.titleLabel.font = kFontSize(15);
    [bt0 setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    bt0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIButton* bt1 =_btns[1];
    bt1.titleLabel.font = kFontSize(16);
    [bt1 setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    bt1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    bt1.titleLabel.numberOfLines = 1;
    
    
    [_btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:MAINSCREEN_WIDTH/2 leadSpacing:20 tailSpacing:20];
    
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@11);
        make.height.mas_equalTo(@20);
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}


+(instancetype)cellWith:(UITableView*)tabelView{
    ExchangeDetailCell *cell = (ExchangeDetailCell *)[tabelView dequeueReusableCellWithIdentifier:@"ExchangeDetailCell"];
    if (!cell) {
        cell = [[ExchangeDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExchangeDetailCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NSDictionary*)model{
    return 11+21;
}

- (void)richElementsInCellWithModel:(NSDictionary*)paysDic withExchangeType:(ExchangeType)type{
    
    
    UIButton* bt0 =_btns[0];
    UIButton* bt1 =_btns[1];
    [bt0 setTitle:paysDic.allKeys[0] forState:UIControlStateNormal];
    [bt1 setTitle:paysDic.allValues[0] forState:UIControlStateNormal];
    [bt1 setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    
    NSString * statusStr = paysDic.allKeys[0];
    if ( [statusStr isEqualToString:@"哥哥状态："]) {
        
    switch (type) {
        case ExchangeTypePayed:
        {
            
            [bt1 setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
        }
            break;
        case ExchangeTypeHandling:
        {
            
            [bt1 setTitleColor:HEXCOLOR(0xff9238) forState:UIControlStateNormal];
        }
            break;
        case ExchangeTypeBack:
        {
            
            [bt1 setTitleColor:HEXCOLOR(0xd02a2a) forState:UIControlStateNormal];
        }
            break;
        default:{
            [bt1 setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        }
            break;
    }
    }
}

@end
