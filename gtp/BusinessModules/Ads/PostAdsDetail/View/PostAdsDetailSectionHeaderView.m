//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "PostAdsDetailSectionHeaderView.h"
#define kPostAdsDetailHeightForHeaderInSections  125//19+25+19
@interface PostAdsDetailSectionHeaderView()
@property(nonatomic,strong)UIView* grandianView;
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* topicRefreshBtn;
@property(nonatomic,strong)UIImageView* sectionLine;
@end

@implementation PostAdsDetailSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[PostAdsDetailSectionHeaderView class] forHeaderFooterViewReuseIdentifier:PostAdsDetailSectionHeaderReuseIdentifier];
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
        _topicRefreshBtn.origin = CGPointMake( 0 , 0);
        _topicRefreshBtn.size = CGSizeMake(MAINSCREEN_WIDTH, kPostAdsDetailHeightForHeaderInSections);
        _topicRefreshBtn.layer.borderWidth=0.0;
        _topicRefreshBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _topicRefreshBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _topicRefreshBtn.titleLabel.font = kFontSize(12);
        _topicRefreshBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [_topicRefreshBtn setTitleColor:kClearColor forState:UIControlStateNormal];
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


- (void)setDataWithType:(PostAdsDetailType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle withImg:(NSString*)img{
    self.sectionLine.hidden = NO;
    _topicRefreshBtn.hidden = YES;
    switch (type) {
            
        case PostAdsDetailTypeSuccess:
        {
            _icon.image = [UIImage imageNamed:img];
            
            _titleLabel.attributedText = [NSString attributedStringWithString:title stringColor:HEXCOLOR(0x333333) stringFont:kFontSize(24) subString:[NSString stringWithFormat:@"%@",@""] subStringColor:HEXCOLOR(0x5284ff) subStringFont:kFontSize(12)];
        }
            break;
        default:{
            _sectionLine.hidden = NO;
            _topicRefreshBtn.hidden = YES;
            
        }
            break;
    }
}

- (void)refreshTopic:(UIButton*)sender {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"SECTIONHEADPOST" object:@(sender.tag) ];
    
//    if ([_delegate respondsToSelector:@selector(sectionHeaderSubBtnClickTag:)]) {
//        [_delegate sectionHeaderSubBtnClickTag:sender];
//    }
    if (self.clickSectionBlock) {
        self.clickSectionBlock(sender.titleLabel.text);
        //.clickSectionBlock = ^(NSInteger *sec){
    }
}

+ (CGFloat)viewHeight
{
    return 125+5;
}
@end


@interface PostAdsDetailSectionFooterView ()
@property(nonatomic,strong)UIView* bgView;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *tipLab;
@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) UIButton *appealBtn;

@property(nonatomic,strong)UIImageView* sectionLine;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) NSMutableArray *dataBtns;
@end


@implementation PostAdsDetailSectionFooterView

+ (void)sectionFooterViewWith:(UITableView*)tableView{
    [tableView registerClass:[PostAdsDetailSectionFooterView class] forHeaderFooterViewReuseIdentifier:PostAdsDetailSectionFooterReuseIdentifier];
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
//    [_bgView addSubview:_sectionLine];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.tag = EnumActionTag1;
    _sureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_sureBtn setTitle:@"查看勃勃生机" forState:UIControlStateNormal];
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
    _appealBtn.tag = EnumActionTag0;
    _appealBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_appealBtn setTitle:@"返回首页" forState:UIControlStateNormal];
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


- (void)setDataWithType:(PostAdsDetailType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle{
    _bgView.frame = CGRectZero;
    _sureBtn.frame = CGRectZero;
    _appealBtn.frame = CGRectZero;
    
    switch (type) {
        case PostAdsDetailTypeSuccess:
        {
            _bgView.frame =CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, [PostAdsDetailSectionFooterView viewHeightWithType:type]);
            
            _appealBtn.frame = CGRectMake(23, 36, 133, 40);
            
            _sureBtn.frame = CGRectMake(_bgView.width - 2*23-2*_appealBtn.width +CGRectGetMaxX(_appealBtn.frame)+4.3,36, _appealBtn.width, 40);
        }
            break;
        default:
        {
            _bgView.frame = CGRectZero;
            
            
            _sureBtn.frame = CGRectZero;
            _appealBtn.frame = CGRectZero;
        }
            break;
    }
}

- (void)actionBlock:(ActionBlock)block
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

+ (CGFloat)viewHeightWithType:(PostAdsDetailType)type
{
    switch (type) {
        case OrderTypeWaitDistribute:
        {
            return 36+40+50;
        }
            break;
        default:
            return 180;
            break;
    }
}
@end
