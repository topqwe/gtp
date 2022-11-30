//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "PostAdsSlideCell.h"
#import "PostAdsModel.h"

#import "SlideTabBarView.h"
@interface PostAdsSlideCell ()

@property (strong, nonatomic) SlideTabBarView *slideTabBarView;

@end

@implementation PostAdsSlideCell
- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    //下分割线
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    NSArray* tabs = @[@"",@""];
    _slideTabBarView = [[SlideTabBarView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 363) WithTabs:tabs];
    
    [self.contentView addSubview:_slideTabBarView];
//
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}


+(instancetype)cellWith:(UITableView*)tabelView{
    PostAdsSlideCell *cell = (PostAdsSlideCell *)[tabelView dequeueReusableCellWithIdentifier:@"PostAdsSlideCell"];
    if (!cell) {
        cell = [[PostAdsSlideCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostAdsSlideCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 323+40;
}

- (void)richElementsInCellWithModel:(NSDictionary*)model{
    NSDictionary* info = model[kIndexInfo];
    PostAdsType type = [info[kType] integerValue];
    switch (type) {
        case PostAdsTypeEdit:
        {
            [_slideTabBarView fixedScrollToIndex:1];
        }
            break;
        case PostAdsTypeCreate:
        {
            [_slideTabBarView scrollToIndex:0];
        }
            
        default:
            break;
    }
    
    
    
}

@end
