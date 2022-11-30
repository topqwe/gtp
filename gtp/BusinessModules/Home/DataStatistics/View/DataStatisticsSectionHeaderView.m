//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "DataStatisticsSectionHeaderView.h"
#define kDataStatisticsHeightForHeaderInSections  63//19+25+19
@interface DataStatisticsSectionHeaderView()
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* topicRefreshBtn;
@property(nonatomic,strong)UIImageView* sectionLine;
@end

@implementation DataStatisticsSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[DataStatisticsSectionHeaderView class] forHeaderFooterViewReuseIdentifier:DataStatisticsSectionHeaderReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];

        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kDataStatisticsHeightForHeaderInSections);
        
        
        self.sectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, kDataStatisticsHeightForHeaderInSections-.5, MAINSCREEN_WIDTH, .5)];
        self.sectionLine.backgroundColor = RGBSAMECOLOR(214)
        ;
        _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:self.sectionLine];
        
        
        _topicRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicRefreshBtn.hidden = YES;
        [self.contentView addSubview:_topicRefreshBtn];
        _topicRefreshBtn.origin = CGPointMake( 0 , 0);
        _topicRefreshBtn.size = CGSizeMake(MAINSCREEN_WIDTH, kDataStatisticsHeightForHeaderInSections);
        _topicRefreshBtn.layer.borderWidth=0.0;
        _topicRefreshBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _topicRefreshBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _topicRefreshBtn.titleLabel.font = kFontSize(12);
        _topicRefreshBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [_topicRefreshBtn setTitleColor:kClearColor forState:UIControlStateNormal];
        [_topicRefreshBtn addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 19, 180, 25)];
        _titleLabel.font = kFontSize(15);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor =  kBlackColor;
        [_topicRefreshBtn addSubview:_titleLabel];
        
        
        _icon = [[UIImageView alloc]init];
        [self.contentView addSubview:_icon];
        
    }
    return self;
}


- (void)setDataWithType:(IndexSectionType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle{
    self.sectionLine.hidden = NO;
    switch (type) {
            
        case IndexSectionZero:{
            _topicRefreshBtn.hidden = NO;
            _sectionLine.hidden = YES;
            _topicRefreshBtn.tag = type;
            _titleLabel.attributedText = [NSString attributedStringWithString:title stringColor:HEXCOLOR(0x000000) stringFont:kFontSize(15) subString:subTitle subStringColor:HEXCOLOR(0x000000) subStringFont:kFontSize(15) numInSubColor:HEXCOLOR(0x000000) numInSubFont:kFontSize(18)];
            [_topicRefreshBtn setTitle:subTitle forState:UIControlStateNormal];
        }
            break;
//        
        default:{
            
            _topicRefreshBtn.hidden = YES;
            _sectionLine.hidden = YES;
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
    return 19+25+19;
}
@end


@interface DataStatisticsSectionFooterView ()
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) NSMutableArray *dataBtns;
@end


@implementation DataStatisticsSectionFooterView

+ (void)sectionFooterViewWith:(UITableView*)tableView{
    [tableView registerClass:[DataStatisticsSectionFooterView class] forHeaderFooterViewReuseIdentifier:DataStatisticsSectionFooterReuseIdentifier];
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
    self.contentView.backgroundColor = HEXCOLOR(0xf5f8fd);
    
    UIView *lineIv = [[UIView alloc] init];
    lineIv.backgroundColor = kWhiteColor;
    [self.contentView addSubview:lineIv];
    [lineIv mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.top.left.right.equalTo(@0);
         make.height.equalTo(@2);
     }];
    _dataBtns = [NSMutableArray array];
    for (int i=0; i<2; i++) {
        
        UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
        bt.tag = i;
        bt.frame = CGRectMake(0, 0, 1, 1);
        bt.titleLabel.font = kFontSize(10);
        [bt setTitleColor:HEXCOLOR(0x9b9b9b) forState:UIControlStateNormal];
        [bt addTarget:self action:@selector(_moreAction:)
     forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:bt];
        [_dataBtns addObject:bt];
     }

    [_dataBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:41 leadSpacing:0 tailSpacing:0];

    [_dataBtns mas_makeConstraints:^(MASConstraintMaker *make) {
      make.bottom.equalTo(self.contentView).offset(-12);
        //        make.width.mas_equalTo(@50);
        make.height.mas_equalTo(@14);
    }];
    
    
}

- (void)loadButtonTitle:(NSString*)string{
    [self.btn setTitle:string forState:UIControlStateNormal];
}
- (void)setDataWithType:(IndexSectionType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle{
    switch (type) {
        case IndexSectionZero:
        {
            UIButton* btn0 = _dataBtns[0];
            UIButton* btn1 = _dataBtns[1];
            [btn0 setTitle:title forState:UIControlStateNormal];
            [btn1 setTitle:subTitle forState:UIControlStateNormal];
        }
            break;
            
        default:
            break;
    }
}

- (void)moreActionBlock:(DataBlock)block
{
    self.block = block;
}

#pragma mark - Click bt
- (void)_moreAction:(UIButton *)bt
{
    if (self.block)
    {
        self.block(@(bt.tag));
    }
}

+ (CGFloat)viewHeight
{
    return 2 + 14+12;
}
@end
