//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "ExchangeStatusCell.h"
#import "ExchangeModel.h"

@interface ExchangeStatusCell ()
@property (nonatomic, strong) NSMutableArray *btns;


@end

@implementation ExchangeStatusCell
- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    //下分割线
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGContextSetStrokeColorWithColor(context,HEXCOLOR(0xf6f5fa).CGColor);
    CGContextStrokeRect(context,CGRectMake(0, rect.size.height-.5, rect.size.width- 0,2));
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _btns = [NSMutableArray array];
    
    self.backgroundColor = kWhiteColor;
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = NO;
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
    bt0.titleLabel.font = kFontSize(14);
    [bt0 setTitleColor:HEXCOLOR(0x394368) forState:UIControlStateNormal];
    bt0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIButton* bt1 =_btns[1];
    bt1.titleLabel.font = kFontSize(14);
    [bt1 setTitleColor:HEXCOLOR(0x8c96a5) forState:UIControlStateNormal];
    bt1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    UIButton* bt2 =_btns[2];
    bt2.titleLabel.font = kFontSize(15);
    [bt2 setTitleColor:HEXCOLOR(0x394368) forState:UIControlStateNormal];
    
    UIButton* bt3 =_btns[3];
    [bt3 setImage:[UIImage imageNamed:@"btnRight"] forState:UIControlStateNormal];
    [@[bt0,bt1] mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:200 leadSpacing:20 tailSpacing:20];
    
    [@[bt0,bt1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@12);
        make.height.mas_equalTo(@20);
    }];
    
    
    [bt2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(20);
        make.bottom.equalTo(self).offset(-12);
        make.height.mas_equalTo(@20);
    }];
    
    [bt3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.centerY.equalTo(bt2);
        make.height.mas_equalTo(@24);
        make.width.mas_equalTo(@24);
    }];
    
}

- (void)clickItem:(UIButton*)button{
   
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


+(instancetype)cellWith:(UITableView*)tabelView{
    ExchangeStatusCell *cell = (ExchangeStatusCell *)[tabelView dequeueReusableCellWithIdentifier:@"ExchangeStatusCell"];
    if (!cell) {
        cell = [[ExchangeStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExchangeStatusCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(ExchangeSubData*)model{
    return 78.f;
}

- (void)richElementsInCellWithModel:(ExchangeSubData*)model{
    UIButton* bt0 =_btns[0];
    [bt0 setTitle:[model getExchangeTitle] forState:UIControlStateNormal];
    
    UIButton* bt1 =_btns[1];
    [bt1 setTitle:[model getExchangeStatusName] forState:UIControlStateNormal];
    
    UIButton* bt2 =_btns[2];
    [bt2 setTitle:[model getExchangeSubtitle] forState:UIControlStateNormal];
}

@end
