//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "PostAdsRestrictCell.h"
#import "PostAdsModel.h"

@interface PostAdsRestrictCell ()
@property (nonatomic, strong) UITextView *tv;

@end

@implementation PostAdsRestrictCell

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
    PostAdsRestrictCell *cell = (PostAdsRestrictCell *)[tabelView dequeueReusableCellWithIdentifier:@"PostAdsRestrictCell"];
    if (!cell) {
        cell = [[PostAdsRestrictCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostAdsRestrictCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NSDictionary*)model{
    return 3.f;
}

- (void)richElementsInCellWithModel:(NSDictionary*)paysDic{
//    _tv.zw_placeHolder = paysDic[kTit];
//    _tv.zw_limitCount = 30;
}

@end
