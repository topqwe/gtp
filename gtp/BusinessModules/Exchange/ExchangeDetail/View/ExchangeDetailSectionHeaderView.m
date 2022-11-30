//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "ExchangeDetailSectionHeaderView.h"
#define kExchangeDetailHeightForHeaderInSections  41.5//19+25+19
@interface ExchangeDetailSectionHeaderView()

@property(nonatomic,strong)UIImageView* sectionLine;
@end

@implementation ExchangeDetailSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[ExchangeDetailSectionHeaderView class] forHeaderFooterViewReuseIdentifier:ExchangeDetailSectionHeaderReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];

        
        self.sectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, MAINSCREEN_WIDTH -2*20, .5)];
        self.sectionLine.backgroundColor = HEXCOLOR(0xe6e6e6);
//        _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:self.sectionLine];
    }
    return self;
}

+ (CGFloat)viewHeight
{
    return kExchangeDetailHeightForHeaderInSections;
}
@end


@interface ExchangeDetailSectionFooterView ()
@property(nonatomic,strong)UIView* bgView;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *tipLab;

@property (nonatomic, copy) DataBlock block;

@end


@implementation ExchangeDetailSectionFooterView

+ (void)sectionFooterViewWith:(UITableView*)tableView{
    [tableView registerClass:[ExchangeDetailSectionFooterView class] forHeaderFooterViewReuseIdentifier:ExchangeDetailSectionFooterReuseIdentifier];
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
    
    //        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kOrderDetailHeightForHeaderInSections);
    
    _timeLab = [[UILabel alloc]init];
    _timeLab.font = kFontSize(15);
    _timeLab.textAlignment = NSTextAlignmentLeft;
    _timeLab.textColor = HEXCOLOR(0x666666);
    [self.contentView addSubview:_timeLab];
    
    _tipLab = [[UIButton alloc]init];
    _tipLab.titleLabel.font = kFontSize(16);
    _tipLab.contentVerticalAlignment= UIControlContentVerticalAlignmentTop;
    _tipLab.contentHorizontalAlignment= UIControlContentHorizontalAlignmentRight;
    [_tipLab setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [self.contentView addSubview:_tipLab];
    _tipLab.titleLabel.numberOfLines = 0;
    
}


- (void)setDataWithType:(ExchangeType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle{
    _timeLab.frame = CGRectZero;
    _tipLab.frame = CGRectZero;
    
    switch (type) {
        case ExchangeTypePayed:
        case ExchangeTypeHandling:
        {
            _timeLab.frame = CGRectMake(20, 11, 84, 21);
            _tipLab.frame = CGRectMake(MAINSCREEN_WIDTH -20-204-20-84+CGRectGetMaxX(_timeLab.frame), 11, 204, 90-11);
            _timeLab.text = title;
            [_tipLab setTitle:subTitle forState:UIControlStateNormal];
        }
            break;
        
        default:
        {
            _timeLab.frame = CGRectZero;
            _tipLab.frame = CGRectZero;
        }
            break;
    }
}

- (void)moreActionBlock:(DataBlock)block
{
    self.block = block;
}

#pragma mark - Click bt
- (void)_clickAction:(UIButton *)bt
{
    if (self.block)
    {
        self.block(@(bt.tag));
    }
}

+ (CGFloat)viewHeightWithType:(ExchangeType)type{
    return 90;
}
@end
