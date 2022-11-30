//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "PostAdsPaysCell.h"
#import "PostAdsModel.h"

@interface PostAdsPaysCell ()
@property (nonatomic, strong) NSMutableArray *payBtns;
@property (nonatomic, strong) NSMutableArray *paySwitches;
@property (nonatomic, strong) UIButton *fanBtn;
@property (nonatomic, strong) UISwitch *switchFunc;
@property (nonatomic, strong) NSMutableArray *selectedSwitches;
@property (nonatomic, copy) ActionBlock block;
@end

@implementation PostAdsPaysCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _payBtns = [NSMutableArray array];
        
        _paySwitches = [NSMutableArray array];
        
        
        
        _selectedSwitches = [NSMutableArray array];
        
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIImage* fanImg = [UIImage imageNamed:@"icon_zhifubao"];
    UIButton* fanBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 15, 29+42+3, 29)];//kDetailBottomBarItemLeftMargin
    //        fanBtn.hidden = YES;
    [fanBtn setImage:fanImg forState:UIControlStateNormal];
    fanBtn.adjustsImageWhenHighlighted = NO;
    [fanBtn setTitle:@"😊" forState:UIControlStateNormal];
    [fanBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    fanBtn.titleLabel.font = kFontSize(14);
    [fanBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:3];
    _fanBtn = fanBtn;
    [self addSubview:fanBtn];
    
    [self.contentView addSubview:self.switchFunc];
    [_switchFunc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.fanBtn);
        make.size.mas_equalTo(CGSizeMake(51.0f, 31.0f));
        make.right.mas_equalTo(self.contentView).with.offset(-24.0f);
    }];


    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}


+(instancetype)cellWith:(UITableView*)tabelView{
    PostAdsPaysCell *cell = (PostAdsPaysCell *)[tabelView dequeueReusableCellWithIdentifier:@"PostAdsPaysCell"];
    if (!cell) {
        cell = [[PostAdsPaysCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostAdsPaysCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NSDictionary*)model{
    return 29+15;
}

- (void)richElementsInCellWithModel:(NSDictionary*)paysDic{
    NSArray* pays = @[
                      @{@"2":@"1"},
                      @{@"1":@"1"},
                      @{@"3":@"1"}
                      ];
    SetUserDefaultKeyWithObject(kPayMethodesInPostAds,pays);
    UserDefaultSynchronize;
    
    [_fanBtn setTitle:paysDic[kTit] forState:UIControlStateNormal] ;
    [_fanBtn setImage:[UIImage imageNamed:paysDic[kImg]] forState:UIControlStateNormal];
    if ([paysDic[kType] isEqualToString: @"1"]) {
        [_fanBtn setOrigin:CGPointMake(13, 15)];
    }else{
        [_fanBtn setOrigin:CGPointMake(20, 15)];
    }
    _switchFunc.tag = [paysDic[kType]integerValue];
    _switchFunc.on = [paysDic[kIsOn] boolValue];
//    [_selectedSwitches addObject:paysDic[kType]];
}

-(UISwitch *)switchFunc{
    if(_switchFunc == nil){
        _switchFunc = [[UISwitch alloc]init];
        [_switchFunc setBackgroundColor:HEXCOLOR(0xf2f2f2)];
        [_switchFunc setOnTintColor:HEXCOLOR(0x4c7fff)];
        [_switchFunc setThumbTintColor:[UIColor whiteColor]];
        _switchFunc.layer.cornerRadius = 15.5f;
        _switchFunc.layer.borderWidth = 1.0f;
        _switchFunc.layer.borderColor = HEXCOLOR(0xd0d0d0).CGColor;
        _switchFunc.layer.masksToBounds = YES;
        [_switchFunc addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
//        默认大小 51.0f 31.0f
    }
    return _switchFunc;
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (void)switchAction:(UISwitch*)switchFun{
    NSMutableArray* opens = [NSMutableArray array];
    _selectedSwitches = [GetUserDefaultWithKey(kPayMethodesInPostAds) mutableCopy];
    
    for (int i=0; i<_selectedSwitches.count; i++) {
        NSDictionary* switchDic = _selectedSwitches[i];
        
        if (switchFun.tag == [switchDic.allKeys[0] integerValue]){
            [_selectedSwitches removeObject:switchDic];
            NSDictionary* dic = @{};
            if(switchFun.on!=YES) {
                dic = @{[NSString stringWithFormat:@"%li",switchFun.tag]:@"0"};
                
            }else{
                dic = @{[NSString stringWithFormat:@"%li",switchFun.tag]:@"1"};
    
            }
            [_selectedSwitches addObject:dic];
            SetUserDefaultKeyWithObject(kPayMethodesInPostAds, [NSArray arrayWithArray:_selectedSwitches]);
            UserDefaultSynchronize;
            
        }
        
    }


    for (int i=0; i<_selectedSwitches.count; i++) {
        NSDictionary* switchDic = _selectedSwitches[i];
        if ([switchDic.allValues[0] isEqualToString:@"1"]) {
            [opens addObject:switchDic];
        }
        
    }
    if (opens.count==0) {
        [switchFun setOn:YES animated:YES];
        [YKToastView showToastText:@"亲，至少保留一种靓哦😯～"];
        
        return;
    }
    
    if (self.block) {
        self.block(GetUserDefaultWithKey(kPayMethodesInPostAds));
    }
    
    
    
}
@end
