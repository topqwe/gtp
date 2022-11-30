//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "PostAppealSectionHeaderView.h"
#define kPostAppealHeightForHeaderInSections  38//15+21

@interface PostAppealSectionHeaderView ()
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* topicRefreshBtn;
@property(nonatomic,strong)UIImageView* sectionLine;
@end

@implementation PostAppealSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[PostAppealSectionHeaderView class] forHeaderFooterViewReuseIdentifier:PostAppealSectionHeaderReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];

        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kPostAppealHeightForHeaderInSections);
        
        
        self.sectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, kPostAppealHeightForHeaderInSections-.5, MAINSCREEN_WIDTH, .5)];
        self.sectionLine.backgroundColor = RGBSAMECOLOR(214)
        ;
        _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:self.sectionLine];
        
        
        _topicRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicRefreshBtn.hidden = YES;
        [self.contentView addSubview:_topicRefreshBtn];
        _topicRefreshBtn.origin = CGPointMake( 0 , 0);
        _topicRefreshBtn.size = CGSizeMake(MAINSCREEN_WIDTH, kPostAppealHeightForHeaderInSections);
        _topicRefreshBtn.layer.borderWidth=0.0;
        _topicRefreshBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _topicRefreshBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _topicRefreshBtn.titleLabel.font = kFontSize(12);
        _topicRefreshBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
        [_topicRefreshBtn setTitleColor:kClearColor forState:UIControlStateNormal];
        [_topicRefreshBtn addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
        
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 180, kPostAppealHeightForHeaderInSections)];
        _titleLabel.font = kFontSize(17);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.numberOfLines = 1;
        _titleLabel.textColor =  HEXCOLOR(0x232630);
        [_topicRefreshBtn addSubview:_titleLabel];
        
        
        _icon = [[UIImageView alloc]init];
        [self.contentView addSubview:_icon];
        
    }
    return self;
}

- (void)richElementsInViewWithModel:(id)model{
    IndexSectionType type = [model[kIndexSection] integerValue];
    NSArray* arr = (NSArray*)(model[kIndexInfo]);
    NSString* title =  arr[0];
    NSString* subTitle = arr[1];
    self.sectionLine.hidden = NO;
    switch (type) {
        case IndexSectionOne:{
            _topicRefreshBtn.hidden = NO;
            _sectionLine.hidden = YES;
            _topicRefreshBtn.tag = type;
            _titleLabel.textColor =  HEXCOLOR(0x232630);
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

- (void)refreshTopic:(UIButton*)sender {
    
}
+ (CGFloat)viewHeight
{
    return 36;
}
@end


@interface PostAppealSectionFooterView ()

@property (nonatomic, copy) TwoDataBlock block;

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *selectedBtns;

@property (nonatomic, strong) UIImageView *line1;
@property (nonatomic, strong) UIButton *postAdsButton;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@property (nonatomic, strong)NSDictionary* model;
@end


@implementation PostAppealSectionFooterView

+ (void)sectionFooterViewWith:(UITableView*)tableView{
    [tableView registerClass:[PostAppealSectionFooterView class] forHeaderFooterViewReuseIdentifier:PostAppealSectionFooterReuseIdentifier];
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
    
    //self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kOrderDetailHeightForHeaderInSections);
    
    
    _funcBtns = [NSMutableArray array];
    
    _line1 = [[UIImageView alloc]init];
    _line1.backgroundColor = HEXCOLOR(0xe6e6e6);
    [self addSubview:_line1];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self).offset(0);
        make.top.equalTo(self).offset(102);
        make.height.mas_equalTo(@.5);
    }];
    
    //    return;
    NSArray* subtitleArray =@[@"取消",@"确定"];
    for (int i = 0; i < subtitleArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        
        button.titleLabel.font = kFontSize(15);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        button.layer.borderWidth = 1;
        button.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
        [button setTitle:subtitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        [_funcBtns addObject:button];
        //        [_fucBtns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    UIButton* bt0 =_funcBtns.firstObject;
    [bt0 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
    [bt0 setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    
    
    
    UIButton* bt1 =_funcBtns.lastObject;
    [bt1 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    [bt1 setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:15 leadSpacing:16 tailSpacing:16];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom).offset(3.5);
        
        make.height.mas_equalTo(@42);
    }];
}

- (void)funAdsButtonClickItem:(UIButton*)button{
    if (self.block)
    {
        self.block(@(button.tag),_model);
    }
}
-(void)richElementsInViewWithModel:(id)model{
    _model = model;
}
- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}

+ (CGFloat)viewHeightWithType:(IndexSectionType)type
{
    switch (type) {
        case IndexSectionOne:
        {
            return 151;
        }
            break;
        default:
            return 0.1f;
            break;
    }
}
@end
