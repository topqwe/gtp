//
//  SlideBarCell.m
//  SlideTabBar
//  Created by GT on 2018/12/19.
//  Copyright © 2018 GT. All rights reserved.
//

#import "SlideBarCell.h"
#import "FixedRectTagView.h"
@interface SlideBarCell ()
@property (nonatomic,assign) NSInteger accountType;
@property (nonatomic, strong)NSArray* model;
@property (nonatomic, strong) NSMutableArray* tflabs;
@property (nonatomic, strong) NSMutableArray* tfs;
@property (nonatomic, strong) NSMutableArray* leftLabs;
@property (nonatomic, strong) NSMutableArray* rightLabs;
@property (nonatomic, strong) NSMutableArray* rightTfs;

@property (nonatomic, strong)UIImageView* rangeLine;
@property (nonatomic, strong)UILabel* decLab;

@property (nonatomic, strong)UILabel* fixLab;
@property (nonatomic, strong)FixedRectTagView* tagView;
@end

@implementation SlideBarCell
+(instancetype)cellWith:(UITableView*)tabelView{
    SlideBarCell *cell = (SlideBarCell *)[tabelView dequeueReusableCellWithIdentifier:@"SlideBarCell"];
    if (!cell) {
        cell = [[SlideBarCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SlideBarCell"];
    }
    return cell;
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
    _tfs = [NSMutableArray array];
    _tflabs = [NSMutableArray array];
    
    _leftLabs = [NSMutableArray array];
    _rightLabs = [NSMutableArray array];
    _rightTfs = [NSMutableArray array];
    [self layoutAccountType0];

    [self layoutAccountType1];
    UITextField* tf0 = _tfs[0];
    tf0.text = @"1";
    UITextField* tf1 = _tfs[1];
    tf1.text = @"100";
    UILabel* tflab0 = _tflabs[0];
    tflab0.text = @"";
    UILabel* tflab1 = _tflabs[1];
    tflab1.text = @"";
    _rangeLine.backgroundColor = HEXCOLOR(0x394368);
    
    _fixLab.text = @"TUMO";
    //
}

- (void)richElementsInCellWithType:(NSInteger)accountType WithModel:(NSArray*)model{
    _model = model;
    _accountType = accountType;
    UITextField* tf0 = _tfs[0];
    
    UITextField* tf1 = _tfs[1];
    
    UILabel* tflab0 = _tflabs[0];
    
    UILabel* tflab1 = _tflabs[1];
    
//    if (_tagView) {
//        [_tagView removeAllSubViews];
//    }
//    _tagView = [[FixedRectTagView alloc ]initBtnWithFrame:CGRectMake(40, 49, MAINSCREEN_WIDTH-80, 0) isFixedBtnWidth:YES withTitleArray:@[@"10",@"100",@"1000",@"11999"]];
//    _tagView.clickSectionBlock = ^(NSInteger sec, NSString *btnTit) {
//        NSLog(@"%ld,.....%@",(long)sec,btnTit);
//    };
//    [self addSubview:_tagView];
    
    if (accountType ==0) {
        tf0.hidden = NO;
        tf1.hidden = NO;
        tflab0.hidden = NO;
        tflab1.hidden = NO;
        _rangeLine.hidden = NO;
        
        _fixLab.hidden = YES;
        _tagView.hidden = YES;
    }else{
        tf0.hidden = YES;
        tf1.hidden = YES;
        tflab0.hidden = YES;
        tflab1.hidden = YES;
        _rangeLine.hidden = YES;
        
        _fixLab.hidden = NO;
        _tagView.hidden = NO;
        
    }
    UILabel* lab0 = _leftLabs[0];
    lab0.text = @"SL";
    UILabel* lab1 = _leftLabs[1];
    lab1.text = @"靓靓🐟";
    
    UILabel* rlab0 = _rightLabs[0];
//    rlab0.text = [NSString stringWithFormat:@"%@",accountType ==0?@"2349875690":@"23"];
    rlab0.textColor = kClearColor;//[YBGeneralColor themeColor];
    
    UILabel* rlab1 = _rightLabs[1];
    rlab1.text = @"分钟";
    rlab1.textColor = HEXCOLOR(0x394368);
//    rlab1.attributedText = [NSString attributedStringWithString:[NSString stringWithFormat:@"%@   ",accountType ==0?@"28":@"29"] stringColor:[YBGeneralColor themeColor] stringFont:kFontSize(15) subString:@"分钟" subStringColor:HEXCOLOR(0x394368) subStringFont:kFontSize(13)];

    UITextView* rtf0 = _rightTfs[0];
    UITextView* rtf1 = _rightTfs[1];
    rtf0.placeholder =@"  请  ";
    rtf1.placeholder =@"  请输入靓靓🐟  ";
    [_rightTfs[1] mas_updateConstraints:^(MASConstraintMaker *make) {
        make.trailing.offset(-50);
    }];
    
    _decLab.text = @"可可";
    
}

-(void)layoutAccountType0{
    for (int i=0; i<2; i++) {
        UITextField* tf = [[UITextField alloc] init];
        tf.keyboardType = UIKeyboardTypePhonePad;
        tf.textAlignment = NSTextAlignmentCenter;
        tf.layer.cornerRadius = 17.5;
        tf.layer.borderWidth = 1;
        tf.layer.masksToBounds = YES;
        tf.backgroundColor = HEXCOLOR(0xf2f1f6);
        tf.textColor = HEXCOLOR(0x394368);
        tf.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
        [self addSubview:tf];
        [_tfs  addObject:tf];
        
        UILabel* tfLab = [[UILabel alloc]init];
        tfLab.text = @"A";
        tfLab.tag = i;
        tfLab.textAlignment = NSTextAlignmentCenter;
        tfLab.textColor = HEXCOLOR(0x333333);
        tfLab.font = kFontSize(15);
        [self addSubview:tfLab];
        [_tflabs addObject:tfLab];
    }
    
    
    [_tfs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:120 leadSpacing:40 tailSpacing:40];
    
    [_tfs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(49);
        make.height.mas_equalTo(@35);
    }];
    
    WS(weakSelf);
    [_tflabs[0] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.tfs[0]);
        make.top.offset(20);
        make.height.mas_equalTo(@21);
    }];
    [_tflabs[1] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.tfs[1]);
        make.top.offset(20);
        make.height.mas_equalTo(@21);
    }];
    _rangeLine = [[UIImageView alloc]init];
    [self.contentView addSubview:_rangeLine];
    [_rangeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.tfs[0]);
        make.centerX.equalTo(self);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@2);
    }];
    
//    [_tfs[0]  layoutIfNeeded];
    
    [self layoutAccountPublic];
}

-(void)layoutAccountType1{
    _fixLab = [[UILabel alloc]init];
    _fixLab.text = @"A";
    _fixLab.textAlignment = NSTextAlignmentCenter;
    _fixLab.textColor = HEXCOLOR(0x333333);
    _fixLab.font = kFontSize(15);
    [self addSubview:_fixLab];
    
    [_fixLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.offset(20);
        make.height.mas_equalTo(@21);
    }];
    
//    if (_tagView) {
//        [_tagView removeAllSubViews];
//    }
    _tagView = [[FixedRectTagView alloc ]initBtnWithFrame:CGRectMake(40, 49, MAINSCREEN_WIDTH-80, 0) isFixedBtnWidth:YES withTitleArray:
                GetUserDefaultWithKey(kFixedAccountsInPostAds)];
    _tagView.clickSectionBlock = ^(NSInteger sec, NSString *btnTit) {
        NSLog(@"%ld,.....%@",(long)sec,btnTit);
    };
    [self addSubview:_tagView];
    
}

-(void)layoutAccountPublic{
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = nil;
    [self addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(49+34+scrollUpView.frame.size.height);
        
        
        make.leading.equalTo(self).offset(24);
        make.trailing.equalTo(self).offset(-24);
        make.bottom.equalTo(self).offset(-110);
        make.height.equalTo(@95);
        //        make.top.equalTo(scrollBeforeView.mas_bottom).offset(34);
        //        make.leading.equalTo(self).offset(24);
        //       make.trailing.equalTo(self).offset(-24);
//        make.edges.equalTo(self).with.insets(UIEdgeInsetsMake(118, 24, 110, 24));
    }];
    
    UIView *containView = [UIView new];
    containView.backgroundColor = kWhiteColor;
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIView *lastView = nil;
    for (int i = 0; i < 2; i++) {
        UIView *sub_view = [UIView new];
        
        UILabel* leftLab = [[UILabel alloc]init];
        leftLab.text = @"A";
        leftLab.tag = i;
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.textColor = HEXCOLOR(0x94368);
        leftLab.font = kFontSize(15);
        [sub_view addSubview:leftLab];
        [_leftLabs addObject:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(20);
            make.top.equalTo(sub_view).offset(9.5);
            make.bottom.equalTo(sub_view).offset(-9.5);
        }];
        
        UILabel* rightLab = [[UILabel alloc]init];
        rightLab.text = @"B";
        rightLab.tag = i;
        leftLab.textAlignment = NSTextAlignmentRight;
        rightLab.textColor = HEXCOLOR(0x94368);
        rightLab.font = kFontSize(15);
        [sub_view addSubview:rightLab];
        [_rightLabs addObject:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(sub_view).offset(-20);
            make.top.equalTo(sub_view).offset(9.5);
            make.bottom.equalTo(sub_view).offset(-9.5);
        }];
        
        UITextView* tf = [[UITextView alloc] init];
        tf.tag = i;
        tf.keyboardType = UIKeyboardTypeNumberPad;
        tf.textAlignment = NSTextAlignmentRight;
        tf.backgroundColor = kClearColor;
        tf.textColor = [YBGeneralColor themeColor];
        tf.font = kFontSize(15);
        tf.scrollEnabled = NO;

        tf.zw_placeHolderColor = HEXCOLOR(0x999999);
        
        [sub_view addSubview:tf];
        [_rightTfs  addObject:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(sub_view).offset(-18);
            make.top.equalTo(sub_view).offset(3.5);
            make.bottom.equalTo(sub_view).offset(-3.5);
            make.width.equalTo(@160);
            make.height.equalTo(@40);
        }];
        
        
        [containView addSubview:sub_view];
        
        
        
        sub_view.layer.cornerRadius = 4;
        sub_view.layer.borderWidth = 1;
        sub_view.layer.masksToBounds = YES;
        
        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(containView);
            
            make.height.mas_equalTo(@(40));//*i
            
            if (lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).offset(15);
                //                //上1个
                //                lastView.backgroundColor = HEXCOLOR(0xf2f1f6);
                //                lastView.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
            }else
            {
                make.top.mas_equalTo(containView.mas_top);//-15多出来scr
                
                
            }
            
        }];
        //最后一个
        sub_view.backgroundColor = kWhiteColor;
        sub_view.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
        
        
        lastView = sub_view;
        
    }
    // 最后更新containView
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(15);
    }];
    
    _decLab = [[UILabel alloc]init];
    _decLab.text = @"A";
    _decLab.textAlignment = NSTextAlignmentLeft;
    _decLab.textColor = HEXCOLOR(0x000000);
    _decLab.font = kFontSize(14);
    _decLab.numberOfLines = 0;
    [self addSubview:_decLab];
    [_decLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self).offset(24);
        make.trailing.equalTo(self).offset(-24);
        
        make.top.equalTo(scrollView.mas_bottom).offset(26);
    }];
    
}

+(CGFloat)cellHeightWithModelWithType:(NSInteger)accountType WithModel:(NSArray*)model{
    UIView* tagView0 = [FixedRectTagView creatBtnWithFrame:CGRectMake(40,49, MAINSCREEN_WIDTH-80, 0) isFixedBtnWidth:YES withTitleArray:GetUserDefaultWithKey(kFixedAccountsInPostAds)];
    return  accountType==0? 323:49+239+tagView0.size.height;
//    return 323;
}
@end
