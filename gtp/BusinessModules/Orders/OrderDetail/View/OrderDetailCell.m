//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "OrderDetailCell.h"
#import "OrderDetailModel.h"

@interface OrderDetailCell ()
@property(nonatomic,strong)UIView* bgView;
@property(nonatomic,strong)UIImageView* icon;
@property(nonatomic,strong)UILabel* titleLabel;
@property(nonatomic,strong)UIButton* titleBtn;
@property(nonatomic,copy)ActionBlock block;
@end

@implementation OrderDetailCell

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
    OrderDetailCell *cell = (OrderDetailCell *)[tabelView dequeueReusableCellWithIdentifier:@"OrderDetailCell"];
    if (!cell) {
        cell = [[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OrderDetailCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NSDictionary*)model{
    return 15+21;
}

- (void)richElementsInCellWithModel:(id)paysDic WithArr:(NSArray*)arr WithIndexPath:(NSIndexPath*)indexPath{
    NSDictionary* dic = (NSDictionary*)paysDic;
    [_titleBtn setAttributedTitle:[NSString attributedStringWithString:dic.allKeys[0] stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(15) subString:dic.allValues[0] subStringColor:HEXCOLOR(0x333333) subStringFont:kFontSize(16)] forState:UIControlStateNormal];
    if (!(arr.count < 2)) {
        if (indexPath.row < 2) {
            [_titleBtn setImage:[UIImage imageNamed:@"iconDetails"] forState:UIControlStateNormal];
            [_titleBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
            [_titleBtn addTarget:self action:@selector(copylinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [_titleBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
    }
    
    
}
- (void)copylinkBtnClick:(UIButton*)sender {
    [YKToastView showToastText:@"复制成功!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = sender.titleLabel.text;
    if (self.block) {
        self.block(pasteboard.string);
    }
}
- (void)actionBlock:(ActionBlock)block{
    self.block = block;
}


@end
