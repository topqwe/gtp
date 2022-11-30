

//
//  HomeSectionHeaderView.m
//
//  Created by WIQChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import "HomeSectionHeaderView.h"
#define kHeightForHeaderInSections  65//12+17+18+9
@interface HomeSectionHeaderView()
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UIButton* titleLabel;
@property(nonatomic,strong)UIButton* topicRefreshBtn;
@property(nonatomic,strong)UIImageView* sectionLine;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) id model;
@end

@implementation HomeSectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[HomeSectionHeaderView class] forHeaderFooterViewReuseIdentifier:HomeSectionHeaderViewReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];

        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kHeightForHeaderInSections);
        
        
        self.sectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 23)];
        self.sectionLine.backgroundColor = HEXCOLOR(0xffffff);
        ;
        _sectionLine.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.contentView addSubview:self.sectionLine];
        
        
        _topicRefreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topicRefreshBtn.hidden = NO;
        [self.contentView addSubview:_topicRefreshBtn];
        _topicRefreshBtn.origin = CGPointMake( 15 , 0);
        _topicRefreshBtn.size = CGSizeMake(280, kHeightForHeaderInSections-0);
        _topicRefreshBtn.layer.borderWidth=0.0;
        _topicRefreshBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _topicRefreshBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _topicRefreshBtn.titleLabel.font = kFontSize(18);
        _topicRefreshBtn.titleLabel.numberOfLines = 1;//0
        _topicRefreshBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [_topicRefreshBtn setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        
        
        _titleLabel = [[UIButton alloc]initWithFrame:CGRectMake(MAINSCREEN_WIDTH-80-10, 0, 80, kHeightForHeaderInSections-0)];
        _titleLabel.titleLabel.font = kFontSize(13);
        _titleLabel.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _titleLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _titleLabel.titleLabel.numberOfLines = 1;
        [_titleLabel setTitleColor:HEXCOLOR(0x8FAEB7) forState:UIControlStateNormal];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
        
        _icon = [[UIImageView alloc]init];
        [self.contentView addSubview:_icon];
        
    }
    return self;
}
+ (CGFloat)viewHeight:(id)model
{
//    IndexSectionType type = [model[kIndexSection] integerValue];
//    switch (type) {
//        case IndexSectionOne:{
//            NSArray* arr = (NSArray*)(model[kIndexInfo]);
        
//            NSString* subTitle = arr[1];
            
            return  kHeightForHeaderInSections;
            
//        }
//            break;
////
//        default:{
//            return .1f;
//        }
//            break;
//    }
    
}

- (void)richElementsInViewWithModel:(id)model{
    
//    IndexSectionType type = [model[kIndexSection] integerValue];
    
    self.sectionLine.hidden = NO;
    
//    switch (type) {
//        case IndexSectionOne:{
            _sectionLine.hidden = NO;
            NSArray* arr = (NSArray*)(model[kIndexInfo]);
            self.model = arr;
            NSString* title =  arr.firstObject;
            NSString* subTit = arr.lastObject;
//            [_topicRefreshBtn setImage:[UIImage imageNamed:subTitle] forState:UIControlStateNormal];
            [_topicRefreshBtn setTitle:title forState:0];
            [_titleLabel setTitle:subTit forState:0];
            
//            [_topicRefreshBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:13];
            
//        }
//            break;
////        
//        default:{
//            _sectionLine.hidden = YES;
//        }
//            break;
//    }
}

- (void)refreshTopic:(UIButton*)sender {
    if (self.block) {
        self.block(self.model);
    }

}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
@end
