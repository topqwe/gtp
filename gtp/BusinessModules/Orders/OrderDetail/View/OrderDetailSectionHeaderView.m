//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "OrderDetailSectionHeaderView.h"
#define kOrderDetailHeightForHeaderInSections  125//19+25+19
@interface OrderDetailSectionHeaderView()
@property(nonatomic,strong)UIView* grandianView;
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* topicRefreshBtn;
@property(nonatomic,strong)UIImageView* sectionLine;
@end

@implementation OrderDetailSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[OrderDetailSectionHeaderView class] forHeaderFooterViewReuseIdentifier:OrderDetailSectionHeaderReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = RGBCOLOR(242, 241, 246);
        self.backgroundView = [[UIView alloc] init];

//        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kOrderDetailHeightForHeaderInSections);
        _grandianView = [[UIView alloc]initWithFrame:CGRectMake(7, 20, MAINSCREEN_WIDTH -2*7, 20)];
        _grandianView.layer.cornerRadius = 10;
        [_grandianView gradientLayerAboveView:_grandianView withShallowColor:HEXCOLOR(0x737373) withDeepColor:HEXCOLOR(0x313131) isVerticalOrHorizontal:YES];
        
        [self.contentView addSubview:_grandianView];
        
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(24, 30, MAINSCREEN_WIDTH -2*24, 95+5)];
        _bgView.backgroundColor = kWhiteColor;
        [self.contentView addSubview:_bgView];
        
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(70, 33, 39, 39)];
        [_bgView addSubview:_icon];
        
        self.sectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_icon.frame)+23, _bgView.size.width, .5)];
        self.sectionLine.backgroundColor = HEXCOLOR(0xf0f1f3);
        ;
        _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [_bgView addSubview:self.sectionLine];
    
        
        
        _topicRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicRefreshBtn.hidden = YES;
        [self.contentView addSubview:_topicRefreshBtn];
        _topicRefreshBtn.layer.borderWidth=0.0;
        _topicRefreshBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _topicRefreshBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _topicRefreshBtn.titleLabel.font = kFontSize(12);
        _topicRefreshBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [_topicRefreshBtn setTitleColor:HEXCOLOR(0xEF6E04) forState:UIControlStateNormal];
        [_topicRefreshBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xF9CE88)] forState:UIControlStateNormal];
        [_topicRefreshBtn addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_icon.frame)+9,30, _bgView.size.width - CGRectGetMaxX(_icon.frame)-9-9, 40)];
//        _titleLabel.font = kFontSize(15);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 0;
//        _titleLabel.textColor =  kBlackColor;
        [_bgView addSubview:_titleLabel];
        
        
    }
    return self;
}

- (void)richElementsInViewWithModel:(NSDictionary*)model{
    OrderType type = [model[kType] integerValue];
    NSString *title = model[kTit];
    NSString *subTitle = model[kSubTit];
    NSString *img = model[kImg];
    
    self.sectionLine.hidden = NO;
    _topicRefreshBtn.hidden = YES;
    _topicRefreshBtn.frame = CGRectZero;
    switch (type) {
            
        case OrderTypeWaitDistribute:{
            _icon.image = [UIImage imageNamed:img];
//            _topicRefreshBtn.hidden = NO;
//            _sectionLine.hidden = NO;
//            _topicRefreshBtn.tag = type;
            _titleLabel.attributedText = [NSString attributedStringWithString:title stringColor:HEXCOLOR(0x333333) stringFont:kFontSize(20) subString:[NSString stringWithFormat:@"\n%@",subTitle] subStringColor:HEXCOLOR(0x5284ff) subStringFont:kFontSize(12)];
//            [_topicRefreshBtn setTitle:subTitle forState:UIControlStateNormal];
        }
            break;
        case OrderTypeCancel:
        case OrderTypeTimeOut:
        {
            _icon.image = [UIImage imageNamed:img];
            
            _titleLabel.attributedText = [NSString attributedStringWithString:title stringColor:HEXCOLOR(0x333333) stringFont:kFontSize(24) subString:[NSString stringWithFormat:@"%@",@""] subStringColor:HEXCOLOR(0x5284ff) subStringFont:kFontSize(12)];
        }
            break;
        case OrderTypeWaitPay:
        {
            _icon.image = [UIImage imageNamed:img];
            
            _titleLabel.attributedText = [NSString attributedStringWithString:title stringColor:HEXCOLOR(0x333333) stringFont:kFontSize(24) subString:[NSString stringWithFormat:@"%@",@""] subStringColor:HEXCOLOR(0x5284ff) subStringFont:kFontSize(12)];
        }
            break;
        case OrderTypeAppeal:
        {
            _icon.image = [UIImage imageNamed:img];
            
            _titleLabel.attributedText = [NSString attributedStringWithString:title stringColor:HEXCOLOR(0x333333) stringFont:kFontSize(24) subString:[NSString stringWithFormat:@"%@",@""] subStringColor:HEXCOLOR(0x5284ff) subStringFont:kFontSize(12)];
            
            _topicRefreshBtn.hidden = NO;
            _topicRefreshBtn.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 30);
            [_topicRefreshBtn setTitle:@"此🌹已被可可家粮农，请进口处理！" forState:UIControlStateNormal];
        }
            break;
        case OrderTypeFinished:
        {
            _icon.image = [UIImage imageNamed:img];
            
            _titleLabel.attributedText = [NSString attributedStringWithString:title stringColor:HEXCOLOR(0x333333) stringFont:kFontSize(24) subString:[NSString stringWithFormat:@"%@",@""] subStringColor:HEXCOLOR(0x5284ff) subStringFont:kFontSize(12)];
        }
            break;
        default:{
            _sectionLine.hidden = NO;
            _topicRefreshBtn.hidden = YES;
            _topicRefreshBtn.frame = CGRectZero;
            
        }
            break;
    }
}
- (void)refreshTopic:(UIButton*)sender {

}
+ (CGFloat)viewHeight
{
    return 125+5;
}
@end


@interface OrderDetailSectionFooterView ()
@property(nonatomic,strong)UIView* bgView;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *appealBtn;

@property(nonatomic,strong)UIImageView* sectionLine;
@property (nonatomic, copy) TwoDataBlock block;
@property(nonatomic,strong)NSDictionary* model;
@property (nonatomic, strong) NSMutableArray *dataBtns;
@end


@implementation OrderDetailSectionFooterView

+ (void)sectionFooterViewWith:(UITableView*)tableView{
    [tableView registerClass:[OrderDetailSectionFooterView class] forHeaderFooterViewReuseIdentifier:OrderDetailSectionFooterReuseIdentifier];
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
    
    self.contentView.backgroundColor = RGBCOLOR(242, 241, 246);
    self.backgroundView = [[UIView alloc] init];
    
    //        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kOrderDetailHeightForHeaderInSections);
    
    
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:_bgView];
    
    _sectionLine = [[UIImageView alloc]init];
    _sectionLine.backgroundColor = HEXCOLOR(0xf0f1f3);
    _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [_bgView addSubview:_sectionLine];
    
    _timeLab = [[UILabel alloc]init];
    _timeLab.font = kFontSize(40);
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.textColor = HEXCOLOR(0xff9238);
    [_bgView addSubview:_timeLab];
    
    _tipLab = [[UILabel alloc]init];
    _tipLab.font = kFontSize(12);
    _tipLab.textAlignment = NSTextAlignmentCenter;
    _tipLab.textColor = HEXCOLOR(0x4c7fff);
    [_bgView addSubview:_tipLab];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.tag = EnumActionTag0;
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_sureBtn setTitle:@"好了亲亲🐟，symbolic" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:HEXCOLOR(0xf7f9fa) forState:UIControlStateNormal];
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 6;
    _sureBtn.layer.borderWidth = 1;
    _sureBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
    [_sureBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    _sureBtn.userInteractionEnabled = YES;
    [_sureBtn addTarget:self action:@selector(_clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_sureBtn];

    _appealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _appealBtn.tag = EnumActionTag1;
    _appealBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_appealBtn setTitle:@"已拿🐟，去粮农" forState:UIControlStateNormal];
    [_appealBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    _appealBtn.layer.masksToBounds = YES;
    _appealBtn.layer.cornerRadius = 6;
    _appealBtn.layer.borderWidth = 1;
    _appealBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
    [_appealBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
    _appealBtn.userInteractionEnabled = YES;
    [_appealBtn addTarget:self action:@selector(_clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_appealBtn];
    
}
- (void)richElementsInViewWithModel:(NSDictionary*)model{
    _model = model;
    OrderType type = [model[kType] integerValue];
    NSDictionary* dic =model[kIndexSection];
    NSString *title = dic[kTit];
    NSString *subTitle = dic[kSubTit];
    _bgView.frame = CGRectZero;
    _sectionLine.frame = CGRectZero;
    _timeLab.frame = CGRectZero;
    _tipLab.frame = CGRectZero;
    _sureBtn.frame = CGRectZero;
    _appealBtn.frame = CGRectZero;
    
    switch (type) {
        case OrderTypeWaitDistribute:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectMake(0, 30, _bgView.width, 56);
            _tipLab.frame = CGRectMake(0, CGRectGetMaxY(_timeLab.frame)+19.7, _bgView.width, 17);
            _sureBtn.frame = CGRectMake(68, CGRectGetMaxY(_tipLab.frame)+4.3, _bgView.width-2*68, 40);
            _appealBtn.frame = CGRectMake(68, CGRectGetMaxY(_sureBtn.frame)+10, _bgView.width-2*68, 40);
            _timeLab.text = title;
            _tipLab.text = subTitle;
            
        }
            break;
        case OrderTypeCancel:
        case OrderTypeTimeOut:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectZero;
            _tipLab.frame = CGRectMake(0, 30, _bgView.width, 17);
            _sureBtn.frame = CGRectZero;
            _appealBtn.frame = CGRectZero;
            
            _timeLab.text = title;
            _tipLab.text = subTitle;
            
        }
            break;
        case OrderTypeWaitPay:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectMake(0, 30, _bgView.width, 56);
            _tipLab.frame = CGRectMake(0, CGRectGetMaxY(_timeLab.frame)+19.7, _bgView.width, 17);
            
            _sureBtn.frame = CGRectZero;
            _appealBtn.frame = CGRectZero;
            
            _timeLab.text = title;
            _tipLab.text = subTitle;
            
        }
            break;
        case OrderTypeAppeal:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _timeLab.frame = CGRectMake(0, 30, _bgView.width, 56);
            _tipLab.frame = CGRectMake(0, CGRectGetMaxY(_timeLab.frame)+19.7, _bgView.width, 17);
            
            _sureBtn.frame = CGRectZero;
            _appealBtn.frame = CGRectZero;
            
            _timeLab.text = title;
            _tipLab.text = subTitle;
            
        }
            break;
        case OrderTypeFinished:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [OrderDetailSectionFooterView viewHeightWithType:type]);
            _sectionLine.frame = CGRectMake(0, 26, _bgView.width, .5);
            
            _timeLab.frame = CGRectMake(23, CGRectGetMaxY(_sectionLine.frame)+25.5, _bgView.width, 22);
            _tipLab.frame = CGRectMake(23, CGRectGetMaxY(_timeLab.frame)+14, _bgView.width, 22);
            
            _sureBtn.frame = CGRectZero;
            _appealBtn.frame = CGRectZero;
            
//            _timeLab.text = title;
//            _tipLab.text = subTitle;
            _timeLab.attributedText = [NSString attributedStringWithString:@"号："  stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(15) subString:[NSString stringWithFormat:@"%@",subTitle] subStringColor:HEXCOLOR(0x333333) subStringFont:kFontSize(16)];
            _tipLab.attributedText = [NSString attributedStringWithString:@"：" stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(15) subString:[NSString stringWithFormat:@"%@",subTitle] subStringColor:HEXCOLOR(0x333333) subStringFont:kFontSize(16)];
            
            _timeLab.textAlignment = NSTextAlignmentLeft;
            _tipLab.textAlignment = NSTextAlignmentLeft;
            
        }
            break;

            
        default:
        {
            _bgView.frame = CGRectZero;
            _sectionLine.frame = CGRectZero;
            _timeLab.frame = CGRectZero;
            _tipLab.frame = CGRectZero;
            _sureBtn.frame = CGRectZero;
            _appealBtn.frame = CGRectZero;
        }
            break;
    }
}

- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}

#pragma mark - Click bt
- (void)_clickAction:(UIButton *)bt
{
    if (self.block)
    {
        self.block(@(bt.tag),self.model);
    }
}

+ (CGFloat)viewHeightWithType:(OrderType)type
{
    switch (type) {
        case OrderTypeWaitDistribute:
        {
            return 217+30;
        }
            break;
        case OrderTypeCancel:
        case OrderTypeTimeOut:
        {
            return 60+17+40;
        }
            break;
        case OrderTypeWaitPay:
        {
            return 80+77;
        }
            break;
        case OrderTypeFinished:
        {
            return 122.5+26;
        }
            break;
        default:
            return 180;
            break;
    }
}
@end
