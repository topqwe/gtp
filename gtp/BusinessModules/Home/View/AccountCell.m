//
//  SPCell.m
//  PPOYang
//
//  Created by WIQ on 2017/7/25.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "AccountCell.h"
#import "HomeModel.h"
@interface AccountCell ()
@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) UILabel *aliasLab;
@property (nonatomic, strong) UILabel *rmbLab;

@property (nonatomic, strong) UILabel *tdTagLab;
@property (nonatomic, strong) UILabel *tdLab;
@property (nonatomic, strong) UILabel *ydLab;

@property (nonatomic, strong) UILabel *tmTagLab;
@property (nonatomic, strong) UILabel *tmLab;
@property (nonatomic, strong) UILabel *ymLab;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *fanBtn;
@end

@implementation AccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self richEles];
    }
    return self;
}


- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIImage* decorImage = kIMG(@"home_top_img");
    _decorIv = [[UIImageView alloc]init];
    [self.contentView addSubview:_decorIv];
    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.contentView.mas_centerX); make.top.leading.trailing.equalTo(self.contentView);
   make.size.mas_equalTo(CGSizeMake(decorImage.size.width, 183));
    }];
   [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
    
    _decorIv.clipsToBounds = YES;
    _decorIv.image = decorImage;
    
    _accLab = [[UILabel alloc]init];
    [_decorIv addSubview:_accLab];
    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.decorIv.mas_centerX);
       make.top.equalTo(self.decorIv).offset(63);
//        make.height.equalTo(@20);
    }];
    
    _aliasLab = [[UILabel alloc]init];
    [_decorIv addSubview:_aliasLab];
    [_aliasLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.equalTo(self.accLab.mas_centerX);
        make.top.equalTo(self.accLab.mas_bottom).offset(6);
//        make.height.equalTo(@40);
    }];
    
    _rmbLab = [[UILabel alloc]init];
    [_decorIv addSubview:_rmbLab];
    [_rmbLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.centerX.equalTo(self.aliasLab.mas_centerX); make.top.equalTo(self.aliasLab.mas_bottom).offset(6);
//        make.height.equalTo(@17);
    }];

    
    _tdTagLab = [[UILabel alloc]init];
    [self.contentView addSubview:_tdTagLab];
    [_tdTagLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.top.equalTo(self.decorIv.mas_bottom).offset(12);
        make.height.equalTo(@18);
        make.leading.equalTo(@65);
    }];
    
    _tdLab = [[UILabel alloc]init];
    [self.contentView addSubview:_tdLab];
    [_tdLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.centerX.mas_equalTo(self.tdTagLab.mas_centerX); make.top.equalTo(self.tdTagLab.mas_bottom).offset(9);
        make.height.equalTo(self.tdTagLab);
    }];
    
    _ydLab = [[UILabel alloc]init];
    [self.contentView addSubview:_ydLab];
    [_ydLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tdLab.mas_centerX); make.top.equalTo(self.tdLab.mas_bottom).offset(9);
        make.height.equalTo(self.tdLab);
    }];
    
    _tmTagLab = [[UILabel alloc]init];
    [self.contentView addSubview:_tmTagLab];
    [_tmTagLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tdTagLab);
        make.height.equalTo(self.tdTagLab);
        make.trailing.equalTo(@-65);
    }];
    
    _tmLab = [[UILabel alloc]init];
    [self.contentView addSubview:_tmLab];
    [_tmLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tmTagLab.mas_centerX); make.top.equalTo(self.tmTagLab.mas_bottom).offset(9);
        make.height.equalTo(self.tmTagLab);
    }];
    
    _ymLab = [[UILabel alloc]init];
    [self.contentView addSubview:_ymLab];
    [_ymLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.tmLab.mas_centerX); make.top.equalTo(self.tmLab.mas_bottom).offset(9);
        make.height.equalTo(self.tmLab);
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    _accLab.textAlignment = NSTextAlignmentCenter;
    _accLab.font = kFontSize(14);
    _accLab.textColor = HEXCOLOR(0xffffff);
    
    _aliasLab.textAlignment = NSTextAlignmentCenter;
    _aliasLab.font = [UIFont boldSystemFontOfSize:37];
    _aliasLab.textColor = HEXCOLOR(0xffffff);
    
    _rmbLab.textAlignment = NSTextAlignmentCenter;
    _rmbLab.font = kFontSize(12);
    _rmbLab.textColor = HEXCOLOR(0xffffff);
    
    _tdTagLab.textAlignment = NSTextAlignmentLeft;
    _tdTagLab.font = kFontSize(13);
    _tdTagLab.textColor = HEXCOLOR(0x000000);
    
    _tdLab.textAlignment = NSTextAlignmentLeft;
    _tdLab.font = [UIFont boldSystemFontOfSize:15];
    _tdLab.textColor = HEXCOLOR(0x000000);;
    
    _ydLab.textAlignment = NSTextAlignmentLeft;
    _ydLab.font = kFontSize(13);
    _ydLab.textColor = HEXCOLOR(0x9b9b9b);
    
    _tmTagLab.textAlignment = NSTextAlignmentLeft;
    _tmTagLab.font = kFontSize(13);
    _tmTagLab.textColor = HEXCOLOR(0x000000);
    
    _tmLab.textAlignment = NSTextAlignmentLeft;
    _tmLab.font = [UIFont boldSystemFontOfSize:18];
    _tmLab.textColor = HEXCOLOR(0x000000);
    
    _ymLab.textAlignment = NSTextAlignmentLeft;
    _ymLab.font = kFontSize(13);
    _ymLab.textColor = HEXCOLOR(0x9b9b9b);
}


+(instancetype)cellWith:(UITableView*)tabelView{
    AccountCell *cell = (AccountCell *)[tabelView dequeueReusableCellWithIdentifier:@"AccountCell"];
    if (!cell) {
        cell = [[AccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 183+98;
}

- (void)richElementsInCellWithModel:(NSArray*)model{
    _accLab.text = [NSString stringWithFormat:@"%@心号",@"AB"];
    _aliasLab.text = @"100000000000 AB";
    _rmbLab.text = [NSString stringWithFormat:@"起🎂MIA %@",@"100000000000.00"];
    
    _tdTagLab.text = @"今日🎂";
    _tdLab.text = @"1000000000000";
    _ydLab.text = [NSString stringWithFormat:@"昨日 %@",@"100000.00"];
    
    _tmTagLab.text = @"本月🎂";
    _tmLab.text = @"100000";
    _ymLab.text = [NSString stringWithFormat:@"上月 %@",@"100000.00"];
}

@end
