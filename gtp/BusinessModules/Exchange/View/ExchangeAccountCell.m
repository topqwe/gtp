//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//
#import "ExchangeAccountCell.h"
#import "ExchangeModel.h"

@interface ExchangeAccountCell ()<UITextViewDelegate>
@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *tvs;
@property (nonatomic, copy) NSString* rate;
@property (nonatomic, strong) UILabel* titLab;
@property (nonatomic, strong) UIImageView* line1;
@property (nonatomic, strong) UIImageView* arrowIv;
@property (nonatomic, strong) UILabel* tipLab;
@property (nonatomic, strong) UITextView *QRtextView;
@property (nonatomic, strong) UIButton *submitBtn;
@property (nonatomic, copy) ActionBlock block;
@end

@implementation ExchangeAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _titLab = [[UILabel alloc]init];
    
    _titLab.textAlignment = NSTextAlignmentCenter;
    _titLab.textColor = HEXCOLOR(0x394368);
    _titLab.font = kFontSize(20);
    [self.contentView addSubview:_titLab];
    
    [_titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(@15);
        make.height.equalTo(@28);
    }];
    
    _line1 = [[UIImageView alloc]init];
    _line1.backgroundColor = HEXCOLOR(0xf0f1f3);
    [self.contentView addSubview:_line1];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(@0);
        make.top.equalTo(@58);
        make.height.equalTo(@2);
    }];
    
    
    
    _btns = [NSMutableArray array];
    _tvs =[NSMutableArray array];
    self.backgroundColor = kWhiteColor;
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderWidth = 1;
        button.layer.cornerRadius =17.5;
        button.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
        button.backgroundColor = HEXCOLOR(0xf2f1f6);
        button.layer.masksToBounds = YES;
        button.adjustsImageWhenHighlighted = NO;
        button.tag =  i;
        button.titleLabel.font = kFontSize(16);
        [button setTitleColor:HEXCOLOR(0x394368) forState:UIControlStateNormal];
        //        [button setTitle:titleArray[i] forState:UIControlStateNormal];
//        [button setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        [_btns addObject:button];
        [_btns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    }
    for (int i = 0; i < 2; i++) {
        UITextView *textView = [[UITextView alloc] init];
        textView.tag = i;
        textView.delegate = self;
        textView.keyboardType = UIKeyboardTypeNumberPad;
        textView.layer.borderWidth = 1;
        textView.layer.cornerRadius =17.5;
        textView.font = kFontSize(15);
        textView.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
        textView.backgroundColor = HEXCOLOR(0xf2f1f6);
        textView.textColor = kBlackColor;
        //文字设置居右、placeHolder会跟随设置
        textView.textAlignment = NSTextAlignmentCenter;
        textView.zw_placeHolderColor =HEXCOLOR(0x999999);
        
        [self.contentView addSubview:textView];
        [_tvs addObject:textView];
    }
    
    
    
    UIButton* bt0 =_btns[0];
    [bt0 setImage:[UIImage imageNamed:@"iconAb"] forState:UIControlStateNormal];
    
    UIButton* bt1 =_btns[1];
    [bt1 setImage:[UIImage imageNamed:@"iconBtc"] forState:UIControlStateNormal];
    
//    UITextView* tv0 =_tvs[0];
//
//    UITextView* tv1 =_tvs[0];
    
    [_btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:120 leadSpacing:40 tailSpacing:40];
    
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@75);
        make.height.mas_equalTo(@35);
    }];
    
    
    _arrowIv = [[UIImageView alloc]init];
    _arrowIv.image = [UIImage imageNamed:@"exchangeArrow"];
    [self.contentView addSubview:_arrowIv];
    [_arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(@113);
        make.width.equalTo(@19);
        make.height.equalTo(@17);
    }];
    
    [_tvs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:120 leadSpacing:40 tailSpacing:40];
    
    [_tvs mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@128);
        make.height.mas_equalTo(@35);
    }];
    
    _tipLab = [[UILabel alloc]init];
    
    _tipLab.textAlignment = NSTextAlignmentLeft;
    _tipLab.textColor = HEXCOLOR(0x999999);
    _tipLab.font = kFontSize(14);
    [self.contentView addSubview:_tipLab];
    
    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.top.equalTo(@178);
        make.height.equalTo(@20);
    }];
    
    _QRtextView = [[UITextView alloc] init];
    _QRtextView.keyboardType = UIKeyboardTypeASCIICapable;
    _QRtextView.layer.borderWidth = 1;
    _QRtextView.layer.cornerRadius =4;
    _QRtextView.font = kFontSize(15);
    _QRtextView.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
    _QRtextView.backgroundColor = HEXCOLOR(0xf2f1f6);
    _QRtextView.textColor = HEXCOLOR(0x666666);
    //文字设置居右、placeHolder会跟随设置
    _QRtextView.delegate = self;
    _QRtextView.textAlignment = NSTextAlignmentLeft;
    _QRtextView.zw_placeHolderColor =HEXCOLOR(0x999999);
    
    [self.contentView addSubview:_QRtextView];
    [_QRtextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@20);
        make.trailing.equalTo(@-20);
        make.top.equalTo(@203);
        make.height.equalTo(@35);
    }];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.layer.borderWidth = 1;
    _submitBtn.layer.cornerRadius =20;
    _submitBtn.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
    _submitBtn.backgroundColor = HEXCOLOR(0x4c7fff);
    _submitBtn.layer.masksToBounds = YES;
    _submitBtn.adjustsImageWhenHighlighted = NO;
    _submitBtn.titleLabel.font = kFontSize(16);
    [_submitBtn setTitleColor:HEXCOLOR(0xf7f9fa) forState:UIControlStateNormal];
    _submitBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_submitBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_submitBtn];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@40);
       make.trailing.equalTo(@-40); make.bottom.equalTo(self.contentView).offset(-20);
        make.height.equalTo(@40);
    }];
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)clickItem:(UIButton*)button{
    UITextView* tv0 =_tvs[0];
    
    UITextView* tv1 =_tvs[1];
    if (([NSString isEmpty:tv0.text]
         &&[NSString isEmpty:tv1.text])
        &&[NSString isEmpty:_QRtextView.text]) {
        [YKToastView showToastText:@""];
        return ;
    }
    
    if (![NSString isEmpty:tv0.text]
        &&![NSString isEmpty:tv1.text]){
        if([NSString isEmpty:_QRtextView.text]) {
            [YKToastView showToastText:@""];
            return;
        }
        else{
            if(_QRtextView.text.length<34) {
                [YKToastView showToastText:@"请输入a-zA-Z0-9之类34位字符"];
                return;
            }
        }
    }
    if (([NSString isEmpty:tv0.text]
         ||[NSString isEmpty:tv1.text])
        &&![NSString isEmpty:_QRtextView.text]) {
        [YKToastView showToastText:@"请输入哥哥数量"];
        return ;
    }
    NSArray* arr = @[_rate,tv0.text,tv1.text,_QRtextView.text];
    if (self.block) {
        self.block(arr);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

+(instancetype)cellWith:(UITableView*)tabelView{
    ExchangeAccountCell *cell = (ExchangeAccountCell *)[tabelView dequeueReusableCellWithIdentifier:@"ExchangeAccountCell"];
    if (!cell) {
        cell = [[ExchangeAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ExchangeAccountCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NSDictionary*)model{
    return 318.f;
}

- (void)richElementsInCellWithModel:(NSString*)model{
    _rate = model;
    _titLab.text = [NSString stringWithFormat:@"汇率 %@",model];
    
    UIButton* bt0 =_btns[0];
    [bt0 setTitle:@"AB" forState:UIControlStateNormal];
    
    UIButton* bt1 =_btns[1];
    [bt1 setTitle:@"BTC" forState:UIControlStateNormal];
    
    UITextView* tv0 =_tvs[0];
    tv0.zw_placeHolder = @"";
    UITextView* tv1 =_tvs[1];
    tv1.zw_placeHolder = @"收";
//    tv1.zw_limitCount = 30;
    
    _tipLab.text = @"M";
    _QRtextView.zw_placeHolder =@"请输入a-zA-Z0-9之类34位字符";
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == _QRtextView) {
        //如果是删除减少字数，都返回允许修改
        if ([text isEqualToString:@""]) {
            return YES;
        }
        if (range.location>= 34)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{

}

-(void)textViewDidChange:(UITextView *)textView {
    UITextView* tv0 =_tvs[0];
    
    UITextView* tv1 =_tvs[1];
    
    if (textView.tag==EnumActionTag0) {
        tv1.text = [NSString stringWithFormat:@"%.4f",[tv0.text floatValue]*[_rate floatValue]];
    }
    else if (textView.tag==EnumActionTag1) {
        tv0.text = [NSString stringWithFormat:@"%.4f",[tv1.text floatValue]/[_rate floatValue]];
    }
    if (tv0.text.length==0) {
        tv1.text =@"";
    }
    if (tv1.text.length==0) {
        tv0.text =@"";
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    
}
@end
