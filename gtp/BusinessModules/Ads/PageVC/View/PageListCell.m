//
//  SPCell.m
//  PPOYang
//
//  Created by WIQ on 2017/7/25.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "PageListCell.h"
#import "PageModel.h"
@interface PageListCell ()
@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *adIdLab;

@property (nonatomic, strong) UIImageView *line1;

@property (nonatomic, strong) UILabel *typeLab;

@property (nonatomic, strong) UILabel *balanceLab;
@property (nonatomic, strong) UILabel *saledLab;

@property (nonatomic, strong) UIImageView *line2;

@property (nonatomic, strong) UILabel *distributeTimeLab;
@property (nonatomic, strong) UILabel *modifyTimeLab;

@property (nonatomic, strong) UILabel *statusLab;

@property (nonatomic, strong) UIView *payMethodView;
@property (nonatomic, strong) UILabel *payMethodLab;
@property (nonatomic, strong) UIImageView* zIV;
@property (nonatomic, strong) UIImageView* wIV;
@property (nonatomic, strong) UIImageView* cIV;
@property (nonatomic, strong) NSMutableArray* payIvs;
@property (nonatomic, strong) NSMutableArray* statusBtns;
@property (nonatomic, copy) TwoDataBlock block;
@property (nonatomic, strong) id modle;
@end

@implementation PageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self richEles];
    }
    return self;
}


- (void)richEles{
    
    
    _adIdLab = [[UILabel alloc]init];
    [self.contentView addSubview:_adIdLab];
    [_adIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.contentView).offset(20);
       make.top.equalTo(self.contentView).offset(15);
        make.height.equalTo(@21);
    }];
    
    _line1 = [[UIImageView alloc]init];
    [self.contentView addSubview:_line1];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.adIdLab);
       make.trailing.equalTo(@0); make.top.equalTo(self.adIdLab.mas_bottom).offset(10);
        make.height.equalTo(@.5);
    }];
    
    _typeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_typeLab];
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.adIdLab);
   make.top.equalTo(self.line1.mas_bottom).offset(8.5);
        make.height.equalTo(self.adIdLab);
//        make.width.equalTo(@190);
    }];
    
    _balanceLab = [[UILabel alloc]init];
    [self.contentView addSubview:_balanceLab];
    [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.equalTo(self.typeLab); make.top.equalTo(self.typeLab.mas_bottom).offset(10);
        make.height.equalTo(self.typeLab);
    }];

    
    _saledLab = [[UILabel alloc]init];
    [self.contentView addSubview:_saledLab];
    [_saledLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.balanceLab); make.top.equalTo(self.balanceLab.mas_bottom).offset(3);
        make.height.equalTo(self.balanceLab);
        
    }];
    
    _line2 = [[UIImageView alloc]init];
    [self.contentView addSubview:_line2];
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.saledLab);
       make.trailing.equalTo(@0); make.top.equalTo(self.saledLab.mas_bottom).offset(11);
        make.height.equalTo(@.5);
    }];
    
    _distributeTimeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_distributeTimeLab];
    [_distributeTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.line2);
        make.top.equalTo(self.line2.mas_bottom).offset(9.5);
        make.height.equalTo(@16);
    }];
    
    _modifyTimeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_modifyTimeLab];
    [_modifyTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.distributeTimeLab); make.top.equalTo(self.distributeTimeLab.mas_bottom).offset(2);
        make.height.equalTo(self.distributeTimeLab);
        make.bottom.equalTo(self.contentView).offset(-8);
    }];
    
    _statusLab = [[UILabel alloc]init];
    [self.contentView addSubview:_statusLab];
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adIdLab);
        make.height.equalTo(self.adIdLab);
        make.trailing.equalTo(@-22);
    }];
    
    
    _statusBtns = [NSMutableArray array];
    for (int i=0; i<3; i++) {
        UIButton *statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        statusBtn.layer.cornerRadius = 4;
        statusBtn.layer.borderColor = [YBGeneralColor themeColor].CGColor;
        [statusBtn setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
        [statusBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
        statusBtn.layer.borderWidth = 1;
        statusBtn.clipsToBounds = YES;
        statusBtn.tag = i;
        [self.contentView addSubview:statusBtn];
        [statusBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        [_statusBtns addObject:statusBtn];
    }
    
    [_statusBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:50 leadSpacing:MAINSCREEN_WIDTH-3*50-2*7-10 tailSpacing:10];
    
    [_statusBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-13);
//        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@28);
    }];

    
}

- (void)clickItem:(UIButton*)button{
    if (self.block) {
        self.block(@(button.tag),_modle);
    }
}
- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _adIdLab.textAlignment = NSTextAlignmentLeft;
    _adIdLab.font = [UIFont boldSystemFontOfSize:15];;
    _adIdLab.textColor = HEXCOLOR(0x394368);
    
    _line1.backgroundColor = HEXCOLOR(0xf0f1f3);
    _typeLab.textAlignment = NSTextAlignmentCenter;
    _typeLab.font = kFontSize(13);
    _typeLab.textColor = HEXCOLOR(0x4c7fff);
    _typeLab.backgroundColor = HEXCOLOR(0xedf2ff);
    _typeLab.layer.masksToBounds = YES;
    _typeLab.layer.cornerRadius = 2;
    
    _balanceLab.textAlignment = NSTextAlignmentLeft;
    _balanceLab.font = kFontSize(14);
    _balanceLab.textColor = HEXCOLOR(0x394368);
    
    _saledLab.textAlignment = NSTextAlignmentLeft;
    _saledLab.font = kFontSize(14);
    _saledLab.textColor = HEXCOLOR(0x394368);
    
    _line2.backgroundColor = HEXCOLOR(0xf0f1f3);
    
    _distributeTimeLab.textAlignment = NSTextAlignmentLeft;
    _distributeTimeLab.font = kFontSize(11);
    _distributeTimeLab.textColor = HEXCOLOR(0x666666);
    
    _modifyTimeLab.textAlignment = NSTextAlignmentLeft;
    _modifyTimeLab.font = kFontSize(11);
    _modifyTimeLab.textColor = HEXCOLOR(0x666666);
    
    _statusLab.textAlignment = NSTextAlignmentRight;
    _statusLab.font = [UIFont boldSystemFontOfSize:15];
    _statusLab.textColor =  HEXCOLOR(0x8c96a5);
}


+(instancetype)cellWith:(UITableView*)tabelView{
    static NSString *CellIdentifier = @"PageListCell";
    PageListCell *cell = (PageListCell *)[tabelView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[PageListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 15+21+19+21+10+20+3+20+21+16+2+16+8;
}

- (void)richElementsInCellWithModel:(PageItem*)model{
    _modle = model;
    _adIdLab.text = [NSString stringWithFormat:@"勃勃生机ID：%@",@"201811110001"];
    
    _balanceLab.text = [NSString stringWithFormat:@"剩余总数：%@",@"100000.00"];
    _saledLab.text = [NSString stringWithFormat:@"已售总数：%@",@"900000.00"];
    
    _distributeTimeLab.text = [NSString stringWithFormat:@"发布时间：%@",@"2018-9-10 09:00"];
    _modifyTimeLab.text = [NSString stringWithFormat:@"最后修改时间：%@",@"2018-9-10 09:00"];
    
    _statusLab.text = @"上架中";
    NSArray* btnTitles = @[@"编辑",@"上架",@"朋友"];
    for (int i=0; i<3; i++) {
        UIButton* btn = _statusBtns[i];
        [btn setTitle:btnTitles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = kFontSize(13);
        [btn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    }
    [self layoutTypeLabelWithModel:model];
    [self layoutPayMethodViewsWithModel:model];
}
- (void)layoutTypeLabelWithModel:(PageItem*)model{
    _typeLab.text = [NSString stringWithFormat:@"类型：%@ %@",@"",@"201800"];
    CGFloat typeStringWidth =  [NSString getTextWidth:_typeLab.text withFontSize:kFontSize(13) withHeight:21];
    [_typeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(typeStringWidth+6));
    }];
}
- (void)layoutPayMethodViewsWithModel:(PageItem*)model{
    _payIvs = [NSMutableArray array];
    
    if (_payMethodView) {
        [_payMethodView removeFromSuperview];
    }
    _payMethodView = [[UIView alloc]init];
    [self.contentView addSubview:_payMethodView];
    [_payMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saledLab);
        make.height.equalTo(self.saledLab);
        make.trailing.equalTo(@-14);
    }];
    
    
    _zIV = [[UIImageView alloc] init];
    _zIV.image = [UIImage imageNamed:@""];
    [self.payMethodView addSubview:_zIV];
    
    _wIV = [[UIImageView alloc] init];
    _wIV.image = [UIImage imageNamed:@""];
    [self.payMethodView addSubview:_wIV];
//    icon_cir_
    _cIV = [[UIImageView alloc] init];
    _cIV.image = [UIImage imageNamed:@""];
    [self.payMethodView addSubview:_cIV];
    
    _payMethodLab = [[UILabel alloc]init];
    _payMethodLab.text = @"靓式：";
    [self.payMethodView addSubview:_payMethodLab];
    
    _payMethodLab.textAlignment = NSTextAlignmentLeft;
    _payMethodLab.font = kFontSize(13);
    _payMethodLab.textColor = HEXCOLOR(0x394368);
    
    if ([model.iid isEqualToString: @"402880855cbf5900015cc51843551532"]) {
        _payIvs = [@[_wIV, _cIV]mutableCopy];
    }
    else if ([model.iid isEqualToString:@"402881175bccd542015bcd17048c042b"]){
        _payIvs = [@[_zIV, _cIV]mutableCopy];
    }else{
        _payIvs = [@[_zIV, _wIV, _cIV]mutableCopy];
    }
    
    [_payIvs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:0 tailSpacing:0];
    
    [_payIvs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payMethodView);
        make.width.mas_equalTo(@25);
        make.height.mas_equalTo(@25);
    }];
    UIImageView* firstIv = (UIImageView*)_payIvs.firstObject;
    [_payMethodLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payMethodView);
        make.right.equalTo(firstIv.mas_left).offset(-5);
    }];
}
@end
