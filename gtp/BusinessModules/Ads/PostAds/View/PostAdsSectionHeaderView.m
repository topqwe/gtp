//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "PostAdsSectionHeaderView.h"
#define kPostAdsHeightForHeaderInSections  36//15+21

@interface PostAdsSectionHeaderView ()
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* topicRefreshBtn;
@property(nonatomic,strong)UIImageView* sectionLine;
@end

@implementation PostAdsSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[PostAdsSectionHeaderView class] forHeaderFooterViewReuseIdentifier:PostAdsSectionHeaderReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];

        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kPostAdsHeightForHeaderInSections);
        
        
        self.sectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, kPostAdsHeightForHeaderInSections-.5, MAINSCREEN_WIDTH, .5)];
        self.sectionLine.backgroundColor = RGBSAMECOLOR(214)
        ;
        _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:self.sectionLine];
        
        
        _topicRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicRefreshBtn.hidden = YES;
        [self.contentView addSubview:_topicRefreshBtn];
        _topicRefreshBtn.origin = CGPointMake( 0 , 0);
        _topicRefreshBtn.size = CGSizeMake(MAINSCREEN_WIDTH, kPostAdsHeightForHeaderInSections);
        _topicRefreshBtn.layer.borderWidth=0.0;
        _topicRefreshBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _topicRefreshBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _topicRefreshBtn.titleLabel.font = kFontSize(12);
        _topicRefreshBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [_topicRefreshBtn setTitleColor:kClearColor forState:UIControlStateNormal];
        [_topicRefreshBtn addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 14, 180, kPostAdsHeightForHeaderInSections)];
        _titleLabel.font = kFontSize(15);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor =  HEXCOLOR(0x666666);
        [_topicRefreshBtn addSubview:_titleLabel];
        
        
        _icon = [[UIImageView alloc]init];
        [self.contentView addSubview:_icon];
        
    }
    return self;
}


- (void)setDataWithType:(IndexSectionType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle{
    self.sectionLine.hidden = NO;
    switch (type) {
        case IndexSectionTwo:
        case IndexSectionThree:
        case IndexSectionFour:{
            _topicRefreshBtn.hidden = NO;
            _sectionLine.hidden = YES;
            _topicRefreshBtn.tag = type;
            _titleLabel.textColor =  HEXCOLOR(0x999999);
            _titleLabel.text = title;
//            _titleLabel.attributedText = [NSString attributedStringWithString:title stringColor:HEXCOLOR(0x999999) image:[UIImage imageNamed:@""]] ;
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
- (void)setMddifyAdsDataWithType:(IndexSectionType)type withTitle:(NSString*)title withSubTitle:(NSString*)subTitle{
    self.sectionLine.hidden = NO;
    switch (type) {
        case IndexSectionZero:
        case IndexSectionOne:
        case IndexSectionTwo:{
            _topicRefreshBtn.hidden = NO;
            _sectionLine.hidden = YES;
            _topicRefreshBtn.tag = type;
            _titleLabel.textColor =  HEXCOLOR(0x666666);
            _titleLabel.text = title;
//            _titleLabel.attributedText = [NSString attributedStringWithString:title stringColor:HEXCOLOR(0x999999) image:[UIImage imageNamed:@""]] ;
            [_topicRefreshBtn setTitle:subTitle forState:UIControlStateNormal];
        }
            break;
        default:{
            _topicRefreshBtn.hidden = YES;
            _sectionLine.hidden = YES;
        }
            break;
    }
}
- (void)refreshTopic:(UIButton*)sender {
    
    if (self.clickSectionBlock) {
        self.clickSectionBlock(sender.titleLabel.text);
        //.clickSectionBlock = ^(NSInteger *sec){
    }
}
+ (CGFloat)viewHeight
{
    return 36;
}
@end
