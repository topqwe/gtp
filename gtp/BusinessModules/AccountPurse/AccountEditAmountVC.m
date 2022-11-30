//
//  HomeVC.m
//  gt
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "AccountEditAmountVC.h"
@interface AccountEditAmountVC ()<UITextFieldDelegate>
@property (nonatomic, strong) NSMutableArray* leftBtns;
@property (nonatomic, strong) NSMutableArray* rightTfs;
@property (nonatomic, assign) BOOL isHaveDian;

@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock block;

@end

@implementation AccountEditAmountVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    AccountEditAmountVC *vc = [[AccountEditAmountVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    [self initView];
    [self requestListSuccessWithArray];
    
}

- (void)initView {
    _leftBtns = [NSMutableArray array];
    _rightTfs = [NSMutableArray array];
    
    
    [self.navigationItem addCustomRightButton:self withImage:[UIImage new] andTitle:@"保存"];
    
        UIScrollView *scrollView = [UIScrollView new];
        scrollView.scrollEnabled = NO;
        scrollView.delegate = nil;
        [self.view addSubview:scrollView];
        [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.equalTo(self.view).offset(24);
            make.trailing.equalTo(self.view).offset(-24);
            make.top.equalTo(self.view.mas_top).offset(30);
            make.height.equalTo(@45);//95
        }];
        
        UIView *containView = [UIView new];
        containView.backgroundColor = kWhiteColor;
        [scrollView addSubview:containView];
        [containView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(scrollView);
            make.width.equalTo(scrollView);
        }];
        
        UIView *lastView = nil;
        for (int i = 0; i < 1; i++) {
            UIView *sub_view = [UIView new];
            
            UIButton* leftBtn = [[UIButton alloc]init];
            [leftBtn setTitle:@"¥" forState:UIControlStateNormal];
            leftBtn.adjustsImageWhenHighlighted = NO;
            leftBtn.tag = i;
            leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [leftBtn setTitleColor:HEXCOLOR(0x94368) forState:UIControlStateNormal];
            leftBtn.titleLabel.font = kFontSize(15);
            [sub_view addSubview:leftBtn];
            [_leftBtns addObject:leftBtn];
            [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(sub_view).offset(20);
                make.width.equalTo(@10);
                make.centerY.equalTo(sub_view);
            }];
            
            UITextField* tf = [[UITextField alloc] init];
            tf.tag = i;
            tf.delegate = self;
            tf.userInteractionEnabled = YES;
            tf.keyboardType = UIKeyboardTypeDecimalPad;
//            tf.clearsOnBeginEditing = YES;
            tf.returnKeyType=UIReturnKeyDone;
            tf.textAlignment = NSTextAlignmentLeft;
            tf.backgroundColor = kClearColor;
            tf.textColor = HEXCOLOR(0xf59b22);
            tf.font = kFontSize(15);
            [tf addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    //        tf.scrollEnabled = NO;

    //        tf.zw_placeHolderColor = HEXCOLOR(0x999999);
            
            [sub_view addSubview:tf];
            [_rightTfs  addObject:tf];
            [tf mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(sub_view).offset(40);
                make.trailing.equalTo(sub_view).offset(-20);
                make.centerY.equalTo(sub_view);
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
}

- (void)requestListSuccessWithArray{
    UITextField* textField = _rightTfs[0];
    [textField becomeFirstResponder];
    
    NSDictionary* currentPurseDic = self.requestParams;
    if ([[currentPurseDic allKeys] containsObject:kTotal]
        &&[currentPurseDic[kTotal] floatValue] != 0){
        textField.text = [NSString stringWithFormat:@"%@",currentPurseDic[kTotal]];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == _rightTfs[0]) {
        //如果是删除减少字数，都返回允许修改
        if ([string isEqualToString:@""]) {
            return YES;
        }
//        if (range.location== 0&&
//            ([string isEqualToString:@"0"]||
//             [string isEqualToString:@"."])
//            )
//        {
//
//            return NO;//第一位不能为0 和 .
//        }
        if (range.location>= 9)
        {
            return NO;
        }
        // 判断是否有小数点
        if ([textField.text containsString:@"."]) {
            self.isHaveDian = YES;
        }else{
            self.isHaveDian = NO;
        }
        if (string.length > 0) {
            //当前输入的字符
            unichar single = [string characterAtIndex:0];
            // 不能输入.0-9以外的字符
            if (!((single >= '0' && single <= '9') || single == '.')) return NO;
            // 只能有一个小数点
            if (self.isHaveDian && single == '.') return NO;
            // 如果第一位是.则前面加上0.
            if ((textField.text.length == 0) && (single == '.')) {
                textField.text = @"0";
            }
            // 如果第一位是0则后面必须输入点，否则不能输入。
            if ([textField.text hasPrefix:@"0"]) {
                if (textField.text.length > 1) {
                    NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                    if (![secondStr isEqualToString:@"."]) return NO;
                }else{
                    if (![string isEqualToString:@"."]) return NO;
                }
            }
            // 小数点后最多能输入两位
            if (self.isHaveDian) {
                NSRange ran = [textField.text rangeOfString:@"."];
                // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
                if (range.location > ran.location) {
                    if ([textField.text pathExtension].length > 1) return NO;
                }
            }
          }
//        else
//        {
//            return YES;
//        }
    }
    return YES;
}

-(void)textField1TextChange:(UITextField *)textField{
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
}
- (void)rightButtonEvent{
    UITextField* textField = _rightTfs[0];
    if (textField == _rightTfs[0]&&![NSString isEmpty:textField.text]) {//text.empty == 0 true
//             && [textField.text floatValue] != 0
                
            UserInfoModel *newUserInfoModel = [UserInfoManager GetNSUserDefaults];
            
            NSMutableArray* models = [NSMutableArray arrayWithArray:newUserInfoModel.purseArr];
                
            NSDictionary* currentPurseDic = self.requestParams;
                
            for (int i=0; i< models.count; i++) {
                
                NSDictionary* dic = models[i];
                
                if ([currentPurseDic[kType]intValue] == [dic[kType]intValue]) {
                    
                    NSMutableDictionary* dic0= [NSMutableDictionary dictionaryWithDictionary:dic];
                    
    //                    if ([[dic allKeys] containsObject:kAmount]
    //                        &&[dic[kAmount] floatValue] > 0 ) {
    //                        NSNumber* totalN = [NSString getNormalSumNumberByArray:@[dic[kAmount],textField.text]];
    //                        [dic0 addEntriesFromDictionary:@{kAmount:totalN}];
    //                    }else{
                        [dic0 addEntriesFromDictionary:@{kAmount:textField.text}];
                        [dic0 addEntriesFromDictionary:@{kDate:[NSString currentDataStringWithFormatString:[NSString ymdSeparatedByPointFormatString]]}];
    //                    }
                    
    //                    [models addObject:dic0];
                    [models replaceObjectAtIndex:i withObject:[dic0 mutableCopy]];
                }
            
            }
            newUserInfoModel.purseArr = [models mutableCopy];

            [UserInfoManager SetNSUserDefaults:newUserInfoModel];
        
            //block
        }
    if (self.block) {
        [self.navigationController popViewControllerAnimated:true];
        self.block(@(1));
    }
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
@end
