//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "PostAdsDetailCell.h"
#import "PostAdsDetailModel.h"

@interface PostAdsDetailCell ()
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* titleBtn;
@end

@implementation PostAdsDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.contentView.backgroundColor = RGBCOLOR(242, 241, 246);
    self.backgroundView = [[UIView alloc] init];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(24, 0, MAINSCREEN_WIDTH -2*24, 15+21)];
    _bgView.backgroundColor = kWhiteColor;
    [self.contentView addSubview:_bgView];
    
    _titleBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [_bgView addSubview:_titleBtn];
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        //   make.centerX.equalTo(self);
        make.top.equalTo(@15);
        make.leading.equalTo(self.bgView).offset(23);
        make.height.equalTo(@21);
//        make.width.equalTo(@(MAINSCREEN_WIDTH));
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}


+(instancetype)cellWith:(UITableView*)tabelView{
    PostAdsDetailCell *cell = (PostAdsDetailCell *)[tabelView dequeueReusableCellWithIdentifier:@"PostAdsDetailCell"];
    if (!cell) {
        cell = [[PostAdsDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostAdsDetailCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NSDictionary*)model{
    return 15+21;
}

- (void)richElementsInCellWithModel:(id)paysDic{
    NSDictionary* dic = (NSDictionary*)paysDic;
    [_titleBtn setAttributedTitle:[NSString attributedStringWithString:dic.allKeys[0] stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(15) subString:dic.allValues[0] subStringColor:HEXCOLOR(0x333333) subStringFont:kFontSize(16)] forState:UIControlStateNormal];
    
//    _tv.zw_placeHolder = paysDic[kTit];
//    _tv.zw_limitCount = 30;
}

@end
