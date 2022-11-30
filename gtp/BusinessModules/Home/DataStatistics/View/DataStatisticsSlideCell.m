//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "DataStatisticsSlideCell.h"
#import "DataStatisticsModel.h"

#import "DSSlideView.h"
@interface DataStatisticsSlideCell ()

@property (strong, nonatomic) DSSlideView *dsSlideView;

@end

@implementation DataStatisticsSlideCell
- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    //下分割线
    //    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    CGContextSetStrokeColorWithColor(context,HEXCOLOR(0xf6f5fa).CGColor);
    CGContextStrokeRect(context,CGRectMake(0, rect.size.height-.5, rect.size.width- 0,2));
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self richEles];
    }
    return self;
}


- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}


+(instancetype)cellWith:(UITableView*)tabelView{
    DataStatisticsSlideCell *cell = (DataStatisticsSlideCell *)[tabelView dequeueReusableCellWithIdentifier:@"DataStatisticsSlideCell"];
    if (!cell) {
        cell = [[DataStatisticsSlideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DataStatisticsSlideCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 172+40-28;
}

- (void)richElementsInCellWithModel:(NSDictionary*)model{
    //model[@"arr"][0][@(7)]
    NSArray* arr = model[kArr];
    NSMutableArray* tabTitles = [NSMutableArray array];
    for (int i=0; i<arr.count; i++) {
        NSDictionary* dic = arr[i];
        NSNumber* num = dic.allKeys[0];
        [tabTitles addObject:[NSString stringWithFormat:@"%@天",[num stringValue]]];
    }
    
//    NSArray* tabs = @[@"7天",@"30天",@"90天"];
    _dsSlideView = [[DSSlideView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 172+40) WithTabs:tabTitles withModel:arr topSliderBarCentreXLeadSpacing:120.f 
                                   topSliderBarHeight:40
                                     sliderLineHeight:2
                    isHiddenTopSliderBarSeparatorLine:YES];
    [self.contentView addSubview:_dsSlideView];
}

@end
