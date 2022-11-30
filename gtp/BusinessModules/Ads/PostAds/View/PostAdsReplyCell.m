//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "PostAdsReplyCell.h"
#import "PostAdsModel.h"

@interface PostAdsReplyCell ()
@property (nonatomic, strong) UITextView *tv;

@end

@implementation PostAdsReplyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    CGRect rect = CGRectMake(16, 12, MAINSCREEN_WIDTH-32, 160);
    UITextView *textView = [[UITextView alloc] initWithFrame:rect];
    textView.layer.borderWidth = 1;
    textView.font = [UIFont systemFontOfSize:14];
    textView.layer.borderColor = HEXCOLOR(0xf9fafb).CGColor;
    textView.backgroundColor = HEXCOLOR(0xf9fafb);
    //文字设置居右、placeHolder会跟随设置
    textView.textAlignment = NSTextAlignmentLeft;
    textView.scrollEnabled = NO;
    _tv = textView;
    [self.contentView addSubview:textView];
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
}


+(instancetype)cellWith:(UITableView*)tabelView{
    PostAdsReplyCell *cell = (PostAdsReplyCell *)[tabelView dequeueReusableCellWithIdentifier:@"PostAdsReplyCell"];
    if (!cell) {
        cell = [[PostAdsReplyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostAdsReplyCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NSDictionary*)model{
    return 12+160;
}

- (void)richElementsInCellWithModel:(NSDictionary*)paysDic{
    _tv.zw_placeHolderColor =HEXCOLOR(0x999999);
    _tv.zw_placeHolder = paysDic[kTit];
    _tv.zw_limitCount = 140;
}

@end
