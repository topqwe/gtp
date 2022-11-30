

//
//  HomeSectionHeaderView.m
//
//  Created by WIQChen on 16/3/14.
//  Copyright © 2016年 ShengCheng. All rights reserved.
//

#import "HomeBFView.h"
#define kHeightForHeaderInSections  (kGETVALUE_HEIGHT(700, 194, MAINSCREEN_WIDTH-20)+10)
@interface HomeBFView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *sdCycleScrollView;

@property (nonatomic, copy) TwoDataBlock block;

@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) id model;
@end

@implementation HomeBFView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[HomeBFView class] forHeaderFooterViewReuseIdentifier:HomeBFViewReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];

        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kHeightForHeaderInSections);
        
        [self richEles];
        
    }
    return self;
}

- (void)richEles{
    
    _sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 10, 10, MAINSCREEN_WIDTH-20, kHeightForHeaderInSections -10)  placeholderImage:[UIImage imageNamed:@"M_SQUARE_PLACEDHOLDER_IMG"]];
    _sdCycleScrollView.autoScrollTimeInterval = 2.0;
    _sdCycleScrollView.autoScroll = YES;
    _sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
//    _sdCycleScrollView.currentPageDotColor = HEXCOLOR(0xc6c6c6); // 自定义分页控件小圆标颜色
    _sdCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _sdCycleScrollView.layer.masksToBounds = YES;
    _sdCycleScrollView.layer.cornerRadius = 4;
    [self.contentView addSubview:_sdCycleScrollView];
    [self.contentView layoutIfNeeded];
}

+ (CGFloat)viewHeight:(id)model
{
    return  kHeightForHeaderInSections;
}

- (void)richElementsInViewWithModel:(id)model{
    self.model = model;
    
    NSArray* imagesModels = model[kArr];
    
    NSMutableArray* imageURLStrings = [NSMutableArray array];
    NSMutableArray* imageTitles = [NSMutableArray array];
    
    if (imagesModels.count>0) {
        for (int i=0; i<imagesModels.count; i++) {
            HomeItem *bData = imagesModels[i];
            [imageURLStrings addObject:bData.img];
            [imageTitles addObject:bData.title];
//            NSDictionary *model = imagesModels[i];
//            [imageURLStrings addObject:model[kImg]];
//            [imageTitles addObject:model[kTit]];
        }
    }
    
    _sdCycleScrollView.imageURLStringsGroup = imageURLStrings;
    if (imagesModels.count==1) {
        _sdCycleScrollView.autoScroll = NO;
    }else{
        _sdCycleScrollView.autoScroll = YES;
    }
    _sdCycleScrollView.showPageControl = YES;
    _sdCycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    _sdCycleScrollView.currentPageDotImage = [UIImage imageNamed:@"editRecordSelected"];
    _sdCycleScrollView.pageDotImage = [UIImage imageNamed:@"editRecordDDeselected"];
    _sdCycleScrollView.pageControlDotSize = CGSizeMake(8, 8);
    
    
    WS(weakSelf);
    _sdCycleScrollView.clickItemOperationBlock = ^(NSInteger index) {
        HomeItem *model = imagesModels[index];
        if (model!=nil) {
            //        NSDictionary *model = imagesModels[index];
            if (weakSelf.block) {
                weakSelf.block(@(model.type),model);
            }
        }

    };
}

- (void)refreshTopic:(UIButton*)sender {
    if (self.block) {
        self.block(@(1),self.model);
    }

}
- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}
@end
