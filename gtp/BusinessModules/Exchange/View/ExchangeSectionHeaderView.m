//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "ExchangeSectionHeaderView.h"
#define kExchangeHeightForHeaderInSections  43//38+5

@interface ExchangeSectionHeaderView ()
@property(nonatomic,strong)UIImageView* headerSectionLine;
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* topicRefreshBtn;
@property(nonatomic,strong)UIImageView* sectionLine;
@end

@implementation ExchangeSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[ExchangeSectionHeaderView class] forHeaderFooterViewReuseIdentifier:ExchangeSectionHeaderReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];

        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kExchangeHeightForHeaderInSections);
        
        self.headerSectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 5)];
        self.headerSectionLine.backgroundColor = HEXCOLOR(0xf6f5fa);
        ;
        self.headerSectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:self.headerSectionLine];
        
        
        self.sectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, kExchangeHeightForHeaderInSections-.5, MAINSCREEN_WIDTH, .5)];
        self.sectionLine.backgroundColor = RGBSAMECOLOR(214)
        ;
        _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:self.sectionLine];
        
        
        _topicRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_topicRefreshBtn];
        _topicRefreshBtn.origin = CGPointMake( 20 , 5);
        _topicRefreshBtn.size = CGSizeMake(180, kExchangeHeightForHeaderInSections-5);
        _topicRefreshBtn.layer.borderWidth=0.0;
        
        _topicRefreshBtn.titleLabel.font = kFontSize(15);
        _topicRefreshBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _topicRefreshBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        _topicRefreshBtn.titleLabel.numberOfLines = 1;
        [_topicRefreshBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        [_topicRefreshBtn addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _icon = [[UIImageView alloc]init];
        [self.contentView addSubview:_icon];
        
    }
    return self;
}


- (void)setDataWithType:(IndexSectionType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle{
    self.sectionLine.hidden = NO;
    self.headerSectionLine.hidden = NO;
    switch (type) {
        case IndexSectionZero:{
            _headerSectionLine.hidden = NO;
            _sectionLine.hidden = NO;
            [_topicRefreshBtn setTitle:title forState:UIControlStateNormal];
            
        }
            break;
//        
        default:{
            _headerSectionLine.hidden = NO;
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
    return 38+5;
}
@end
