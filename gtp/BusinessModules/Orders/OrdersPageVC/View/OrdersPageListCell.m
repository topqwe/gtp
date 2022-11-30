//
//  SPCell.m
//  PPOYang
//
//  Created by WIQ on 2017/7/25.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "OrdersPageListCell.h"
#import "OrdersPageModel.h"
@interface OrdersPageListCell ()
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong)UIButton *statusBtn;
@property (nonatomic, strong)UIButton *leftStatusBtn;
@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *adIdLab;

@property (nonatomic, strong) UIImageView *line1;

@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UIImageView* vIV;
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

@property (nonatomic, strong) NSDictionary* model;
@end

@implementation OrdersPageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self richEles];
    }
    return self;
}
-(void)actionBlock:(ActionBlock)block{
    self.block = block;
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
   make.top.equalTo(self.line1.mas_bottom).offset(16.5);
        make.height.equalTo(@18);
//        make.width.equalTo(@190);
    }];
    _vIV = [[UIImageView alloc]init];
    [self.contentView addSubview:_vIV];
    
    _payMethodLab = [[UILabel alloc]init];
    [self.contentView addSubview:_payMethodLab];
    [_payMethodLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.typeLab);
        make.top.equalTo(self.typeLab.mas_bottom).offset(10);
        make.height.equalTo(@18);
    }];
    
    
    _balanceLab = [[UILabel alloc]init];
    [self.contentView addSubview:_balanceLab];
    [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
//       make.leading.equalTo(self.typeLab);
        make.trailing.equalTo(@-22);
        make.top.equalTo(self.typeLab);
        make.height.equalTo(self.typeLab);
    }];

    
    _saledLab = [[UILabel alloc]init];
    [self.contentView addSubview:_saledLab];
    [_saledLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.trailing.equalTo(@-22); make.top.equalTo(self.balanceLab.mas_bottom).offset(10);
        make.height.equalTo(self.balanceLab);
        
    }];
    
    _modifyTimeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_modifyTimeLab];
    [_modifyTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.saledLab); make.top.equalTo(self.saledLab.mas_bottom).offset(10);
        make.height.equalTo(self.saledLab);
       
    }];
    
    _distributeTimeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_distributeTimeLab];
    [_distributeTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.typeLab);
        make.top.equalTo(self.modifyTimeLab.mas_top);
        make.height.equalTo(self.saledLab);
    }];
    
    _line2 = [[UIImageView alloc]init];
    [self.contentView addSubview:_line2];
    [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(@0);
       make.leading.equalTo(self.typeLab); make.top.equalTo(self.modifyTimeLab.mas_bottom).offset(10);
        make.height.equalTo(@.5);
    }];
    
    _statusLab = [[UILabel alloc]init];
    [self.contentView addSubview:_statusLab];
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adIdLab);
        make.height.equalTo(self.adIdLab);
        make.trailing.equalTo(@-22);
    }];

    _statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _statusBtn.layer.cornerRadius = 4;
    _statusBtn.layer.borderColor = [YBGeneralColor themeColor].CGColor;
    [_statusBtn setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
//    [_statusBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
    _statusBtn.layer.borderWidth = 1;
    _statusBtn.clipsToBounds = YES;
    _statusBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:_statusBtn];
    
    [_statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(5.5);
        make.trailing.equalTo(@-22);
        make.width.equalTo(@85);
        make.height.equalTo(@28);
    }];

    _leftStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _leftStatusBtn.layer.cornerRadius = 4;
//    _leftStatusBtn.layer.borderColor = [YBGeneralColor themeColor].CGColor;
    
    //    [_statusBtn setTitleColor:kWhiteColor forState:UIControlStateSelected];
//    _leftStatusBtn.layer.borderWidth = 1;
//    _leftStatusBtn.clipsToBounds = YES;
    _leftStatusBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:_leftStatusBtn];
    
    [_leftStatusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line2.mas_bottom).offset(5.5);
        make.leading.equalTo(@22);
        make.width.equalTo(@85);
        make.height.equalTo(@28);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _adIdLab.textAlignment = NSTextAlignmentLeft;
    _adIdLab.font = [UIFont boldSystemFontOfSize:15];;
    _adIdLab.textColor = HEXCOLOR(0x394368);
    
    _line1.backgroundColor = HEXCOLOR(0xf0f1f3);
    
    _typeLab.textAlignment = NSTextAlignmentLeft;
    _typeLab.font = kFontSize(13);
    _typeLab.textColor = HEXCOLOR(0x666666);
    
    
    _balanceLab.textAlignment = NSTextAlignmentRight;
    _balanceLab.font = kFontSize(13);
    _balanceLab.textColor = HEXCOLOR(0x666666);
    
    _saledLab.textAlignment = NSTextAlignmentRight;
    _saledLab.font = kFontSize(13);
    _saledLab.textColor = HEXCOLOR(0x666666);
    
    _line2.backgroundColor = HEXCOLOR(0xf0f1f3);
    
    _modifyTimeLab.textAlignment = NSTextAlignmentRight;
    _modifyTimeLab.font = kFontSize(13);
    _modifyTimeLab.textColor = HEXCOLOR(0x666666);
    
    _distributeTimeLab.textAlignment = NSTextAlignmentLeft;
    _distributeTimeLab.font = kFontSize(14);
    _distributeTimeLab.textColor = HEXCOLOR(0x666666);
    
    _statusLab.textAlignment = NSTextAlignmentRight;
    _statusLab.font =kFontSize(15);
    //layoutSubviews set prior richModel reset
//    _statusLab.textColor =  HEXCOLOR(0x8c96a5);
    
    _statusBtn.titleLabel.font = kFontSize(15);
    _leftStatusBtn.titleLabel.font = kFontSize(15);
    
}


+(instancetype)cellWith:(UITableView*)tabelView{
    static NSString *CellIdentifier = @"OrdersPageListCell";
    OrdersPageListCell *cell = (OrdersPageListCell *)[tabelView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[OrdersPageListCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NSDictionary*)model{
    OrderType type = [model[kType] integerValue];
    switch (type) {
        case OrderTypeFinished:
        case OrderTypeCancel:
        case OrderTypeTimeOut:
            return 152;
            break;
        default:
            return 186;
            break;
    }
    return 186;
}

- (void)richElementsInCellWithModel:(NSDictionary*)model{
    _model = model;
    OrderType type =  [model[kType] integerValue];
    
    _statusLab.text = model[kSubTit];
    [_statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@85);
        make.height.equalTo(@28);
    }];
    [_leftStatusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@0);
    }];
    [_line2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
    }];
    switch (type) {
        case OrderTypeWaitPay:
            {
                _statusLab.textColor = HEXCOLOR(0xd02a2a);
                
                _statusBtn.tag = type;
                [_statusBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
                [_statusBtn setTitle:@"提醒靓靓🐟" forState:UIControlStateNormal];
                [_statusBtn setTitleColor:HEXCOLOR(0xd02a2a) forState:UIControlStateNormal];
                _statusBtn.layer.borderColor = HEXCOLOR(0xd02a2a).CGColor;
            }
            break;
        case OrderTypeWaitDistribute:
        {
            _statusLab.textColor = HEXCOLOR(0x4c7fff);
            
            _statusBtn.tag = type;
            [_statusBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            [_statusBtn setTitle:@"symbolic🌹" forState:UIControlStateNormal];
            [_statusBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
            _statusBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        }
            break;
        case OrderTypeAppeal:
        {
            _statusLab.textColor = HEXCOLOR(0xd02a2a);
            
            _statusBtn.tag = type;
            [_statusBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            [_statusBtn setTitle:@"联系可可家" forState:UIControlStateNormal];
            [_statusBtn setTitleColor:HEXCOLOR(0xff9238) forState:UIControlStateNormal];
            _statusBtn.layer.borderColor = HEXCOLOR(0xff9238).CGColor;
            
            [_leftStatusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@85);
                make.height.equalTo(@28);
            }];
            [_leftStatusBtn setTitle:@"可可家已粮农" forState:UIControlStateNormal];
            _leftStatusBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [_leftStatusBtn setTitleColor:HEXCOLOR(0xff9238) forState:UIControlStateNormal];
        }
            break;
        default:
        {
            _statusLab.textColor =  HEXCOLOR(0x8c96a5);
            [_statusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@0);
            }];
            [_leftStatusBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(@0);
            }];
            [_line2 mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@0);
            }];
        }
            break;
    }
    
    _adIdLab.text = [NSString stringWithFormat:@"%@",@"休闲AB"];
    
    _balanceLab.text = [NSString stringWithFormat:@"放MIA：%@",@"4897"];
    _saledLab.text = [NSString stringWithFormat:@"🐟：%@",@"47923 KKL"];
    
    
    _modifyTimeLab.text = [NSString stringWithFormat:@"靓靓：%@",@"758396"];
    _distributeTimeLab.text = [NSString stringWithFormat:@"%@",@"2018-9-10"];
    
    
    
    [self layoutTypeLabelWithModel:model];
    _payMethodLab.textAlignment = NSTextAlignmentLeft;
    _payMethodLab.font = kFontSize(13);
    _payMethodLab.textColor = HEXCOLOR(0x666666);
    _payMethodLab.text = @"靓式：";
    
    [self layoutPayMethodViewsWithModel:model];
}

- (void)clickItem:(UIButton*)button{
    if (self.block) {
        self.block(_model);
    }
}

- (void)layoutTypeLabelWithModel:(id)model{//OrdersPageItem*
    _typeLab.text = [NSString stringWithFormat:@"可可方：%@",@"L****k"];
    CGFloat typeStringWidth =  [NSString getTextWidth:_typeLab.text withFontSize:kFontSize(13) withHeight:18];
    [_typeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(typeStringWidth+6));
    }];
    [_vIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLab.mas_right);
        make.centerY.equalTo(self.typeLab);
        make.width.height.equalTo(@15);
        
    }];
    _vIV.image = [UIImage imageNamed:@"icon_vip"];
}
- (void)layoutPayMethodViewsWithModel:(id)model{//OrdersPageItem*
    _payIvs = [NSMutableArray array];
    
    if (_payMethodView) {
        [_payMethodView removeFromSuperview];
    }
    _payMethodView = [[UIView alloc]init];
    [self.contentView addSubview:_payMethodView];
    [_payMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payMethodLab);
        make.height.equalTo(self.payMethodLab);
        make.left.equalTo(self.payMethodLab.mas_right).offset(5);
    }];
    
    
    
    _zIV = [[UIImageView alloc] init];
    _zIV.image = [UIImage imageNamed:@""];
    [self.payMethodView addSubview:_zIV];
    
    _wIV = [[UIImageView alloc] init];
    _wIV.image = [UIImage imageNamed:@""];
    [self.payMethodView addSubview:_wIV];
    
    _cIV = [[UIImageView alloc] init];
    _cIV.image = [UIImage imageNamed:@""];
    [self.payMethodView addSubview:_cIV];
    
    
    
    
//    if ([model.iid isEqualToString: @"402880855cbf5900015cc51843551532"]) {
        _payIvs = [@[_wIV, _cIV]mutableCopy];
//    }
//    else if ([model.iid isEqualToString:@"402881175bccd542015bcd17048c042b"]){
//        _payIvs = [@[_zIV, _cIV]mutableCopy];
//    }else{
//        _payIvs = [@[_zIV, _wIV, _cIV]mutableCopy];
//    }
    
    [_payIvs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:5 leadSpacing:0 tailSpacing:0];
    
    [_payIvs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payMethodView);
        make.width.mas_equalTo(@25);
        make.height.mas_equalTo(@25);
        
    }];
//    UIImageView* firstIv = (UIImageView*)_payIvs.firstObject;
    
}
@end
