//
//  SPCell.m
//  PPOYang
//
//  Created by ok on 2017/7/25.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "BannerPopUpCell.h"
#import "SDCycleScrollView.h"
#import "HomeModel.h"

#define XHHTuanNumViewHight 560
#define XHHTuanNumViewWidth 300
@interface BannerPopUpCell ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *sdCycleScrollView;

@property (nonatomic, copy) DataBlock block;

@property (nonatomic, strong) NSArray *arr;


@end

@implementation BannerPopUpCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.contentView.backgroundColor = UIColor.clearColor;
    _sdCycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake( 0, 0, XHHTuanNumViewWidth-0, XHHTuanNumViewHight-110)  placeholderImage:kIMG(@"M_SQUARE_PLACEDHOLDER_IMG")];
    _sdCycleScrollView.autoScrollTimeInterval = 2.0;
    _sdCycleScrollView.autoScroll = YES;
    _sdCycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    _sdCycleScrollView.currentPageDotColor = HEXCOLOR(0xc6c6c6); // 自定义分页控件小圆标颜色
    _sdCycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
//    _sdCycleScrollView.layer.masksToBounds = YES;
//    _sdCycleScrollView.layer.cornerRadius = 4;
    _sdCycleScrollView.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:_sdCycleScrollView];
    [self.contentView layoutIfNeeded];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

+(instancetype)cellWith:(UITableView*)tabelView{
    BannerPopUpCell *cell = (BannerPopUpCell *)[tabelView dequeueReusableCellWithIdentifier:@"BannerPopUpCell"];
    if (!cell) {
        cell = [[BannerPopUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BannerPopUpCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{//24+
    return [YBSystemTool isIphoneX]?
    XHHTuanNumViewHight-110+0:
    XHHTuanNumViewHight-110+0;
}

- (void)actionBlock:(DataBlock)block
{
    self.block = block;
}

- (void)richElementsInCellWithModel:(NSArray*)model{
    NSArray* imagesModels =[ConfigItem mj_objectArrayWithKeyValuesArray:model];
    
    
    NSMutableArray* imageURLStrings = [NSMutableArray array];
    NSMutableArray* imageTitles = [NSMutableArray array];
    
    if (imagesModels.count>0) {
        for (int i=0; i<imagesModels.count; i++) {
            ConfigItem *bData = imagesModels[i];
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
        ConfigItem *item = imagesModels[index];
        if (item!=nil) {
            //        NSDictionary *model = imagesModels[index];
            if (weakSelf.block) {
                weakSelf.block(item);
            }
        }

    };
}

@end
