//
//  SPCell.m
//  PPOYang
//
//  Created by ok on 2017/7/25.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "ShowFilmBannerCell.h"
#import "SDCycleScrollView.h"
#define kHeightForHeaderInSections  (kGETVALUE_HEIGHT(700, 244, MAINSCREEN_WIDTH-20)+10)
@interface ShowFilmBannerCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *sdCycleScrollView;

@property (nonatomic, copy) TwoDataBlock block;

@property (nonatomic, strong) NSArray *arr;

@end

@implementation ShowFilmBannerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 10, 10, MAINSCREEN_WIDTH-20, kHeightForHeaderInSections -10)  placeholderImage:kIMG(@"M_SQUARE_PLACEDHOLDER_IMG")];
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


- (void)layoutSubviews
{
    [super layoutSubviews];
}


+(instancetype)cellWith:(UITableView*)tabelView{
    ShowFilmBannerCell *cell = (ShowFilmBannerCell *)[tabelView dequeueReusableCellWithIdentifier:@"ShowFilmBannerCell"];
    if (!cell) {
        cell = [[ShowFilmBannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShowFilmBannerCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{//24+
    return kHeightForHeaderInSections;
}

- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}

- (void)richElementsInCellWithModel:(NSDictionary*)model{
    
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
            HomeItem *model = imagesModels[index];
            if (weakSelf.block) {
                weakSelf.block(@(model.type),model);
            }
        }

    };
}
@end
