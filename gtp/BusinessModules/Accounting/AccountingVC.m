//
//  InputPWPopUpView.m
//  HHL
//
//  Created by GT on 2018/12/30.
//  Copyright © 2018 GT. All rights reserved.
//

#import "AccountingVC.h"
#import "PieStatedView.h"
#import "AccountTagView.h"
#import "AccountPayView.h"
#import "AccountingVM.h"
#import "AccountingModel.h"
#define XHHTuanNumViewHight MAINSCREEN_HEIGHT
#define XHHTuanNumViewWidth MAINSCREEN_WIDTH 
@interface AccountingVC()<UIGestureRecognizerDelegate,UITextFieldDelegate>
@property(nonatomic,strong)UIView *contentView;
@property (nonatomic, strong) UIImageView *line1;

@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) CGFloat contentViewHeigth;

@property (nonatomic, strong) PieStatedView               *monthPieChartView;

@property (nonatomic, strong) NSMutableArray* leftBtns;
@property (nonatomic, strong) NSMutableArray* rightLabs;
@property (nonatomic, strong) NSMutableArray* rightTfs;
@property (nonatomic, assign) BOOL isHaveDian;

@property (nonatomic, strong) NSMutableArray *funcBtns;

@property (nonatomic, strong) AccountTagView* accountTagView;
@property (nonatomic, strong) AccountPayView* accountPayView;

@property (nonatomic, assign) AccountingSelectedType selectedType;
@end

@implementation AccountingVC

//- (id)initWithFrame:(CGRect)frame {
//    if (self == [super initWithFrame:frame]) {
//
//        [self setupContent];
//    }
//
//    return self;
//}
- (void)viewDidLoad{
    [self setupContent];
    [self richElementsInViewWithModel:@(1)];
}
- (void)setupContent {

    _leftBtns = [NSMutableArray array];
    _rightLabs = [NSMutableArray array];
    _rightTfs = [NSMutableArray array];
    
    _funcBtns = [NSMutableArray array];
    
//    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
//
//    self.backgroundColor = COLOR_HEX(0x000000, .8);
//    self.userInteractionEnabled = YES;
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
//    tap.delegate = self;
//    [self addGestureRecognizer:tap];
    _contentViewHeigth = XHHTuanNumViewHight;
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
        _contentView.layer.cornerRadius = 6;
        _contentView.layer.masksToBounds = YES;
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_contentView];
        
        // 左上角关闭按钮
        UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saftBtn.frame = CGRectMake(0, 0, _contentView.width, [YBFrameTool safeAdjustNavigationBarHeight]);
        saftBtn.titleLabel.font = kFontSize(17);
        [saftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saftBtn.backgroundColor = [YBGeneralColor themeColor];
        [saftBtn setTitle:[NSString currentDataStringWithFormatString:[NSString ymSeparatedBySlashFormatString]] forState:UIControlStateNormal];
        saftBtn.tag = 9;
        saftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        saftBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        [_contentView addSubview:saftBtn];
        saftBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 0);
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.hidden = true;
        closeBtn.titleLabel.font = kFontSize(15);
        [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [closeBtn setTitle:@"保存" forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        closeBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
//        [closeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
        [_contentView addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(@0);
            make.centerY.mas_equalTo(saftBtn);
            make.width.equalTo(@90);
            make.height.equalTo(saftBtn);
        }];
        closeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 0);
        _line1 = [[UIImageView alloc]init];
        [self.contentView addSubview:_line1];
        _line1.backgroundColor = HEXCOLOR(0xe8e9ed);

        [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.mas_equalTo(saftBtn.mas_bottom);
            make.height.equalTo(@8);
        }];
        
        [self layoutAccountPublic];
        
    }
}
//
-(void)layoutAccountPublic{
    
    [self.contentView customDoubleButtonInSuperView:self.contentView WithButtionTitles:@[@"🎂",@"支出"] leftButtonEvent:^(UIButton* btn) {
        self.selectedType = btn.tag;
        [self selectTypeRefreshView];
    } rightButtonEvent:^(UIButton* btn) {
        self.selectedType = btn.tag;
        [self selectTypeRefreshView];
    }];
    
    [self.contentView layoutIfNeeded];
    self.monthPieChartView = [[PieStatedView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.line1.frame)+75, self.contentView.frame.size.width, IS_iPhoneX?(5+ 158+5+15+5+15):(5+128+5+15+5+15))];
    [self.contentView addSubview:self.monthPieChartView];
//    [self.monthPieChartView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.contentView);
//        make.top.equalTo(self.line1.mas_bottom).offset(10);
////        make.width.height.mas_equalTo(158);
//        make.width.mas_equalTo(self.contentView);
//        make.height.mas_equalTo(20+158+10+20+10+50);
//    }];
    
    UIImageView* line2 = [[UIImageView alloc]init];
    [self.contentView addSubview:line2];
    line2.backgroundColor = HEXCOLOR(0xe8e9ed);

    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.top.equalTo(self.monthPieChartView.mas_bottom).offset(!IS_iPhoneX?5:30);
        make.height.equalTo(@8);
    }];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.scrollEnabled = NO;
    scrollView.delegate = nil;
    [self.contentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.equalTo(self.contentView).offset(24);
        make.trailing.equalTo(self.contentView).offset(-24);
        make.top.equalTo(line2.mas_bottom).offset(!IS_iPhoneX?5:30);
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
        [leftBtn setTitle:@"请选记心类目" forState:UIControlStateNormal];
        leftBtn.adjustsImageWhenHighlighted = NO;
        leftBtn.tag = i;
        leftBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [leftBtn setTitleColor:HEXCOLOR(0x94368) forState:UIControlStateNormal];
        leftBtn.titleLabel.font = kFontSize(15);
        [leftBtn addTarget:self action:@selector(showAccountTagView:) forControlEvents:UIControlEventTouchUpInside];
        [sub_view addSubview:leftBtn];
        [_leftBtns addObject:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(20);
            make.centerY.equalTo(sub_view);
        }];
        
        UILabel* rightLab = [[UILabel alloc]init];
        rightLab.text = @"🐶";
        rightLab.tag = i;
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.textColor = HEXCOLOR(0x94368);
        rightLab.font = kFontSize(15);
        [sub_view addSubview:rightLab];
        [_rightLabs addObject:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(sub_view).offset(-20);
            make.centerY.equalTo(sub_view);
        }];
        
        UITextField* tf = [[UITextField alloc] init];
        tf.tag = i;
        tf.delegate = self;
        tf.userInteractionEnabled = NO;
        tf.keyboardType = UIKeyboardTypeDecimalPad;
        tf.clearsOnBeginEditing = YES;
        tf.returnKeyType=UIReturnKeyDone;
        tf.textAlignment = NSTextAlignmentRight;
        tf.backgroundColor = kClearColor;
        tf.textColor = HEXCOLOR(0xf59b22);
        tf.font = kFontSize(15);
        [tf addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
//        tf.scrollEnabled = NO;

//        tf.zw_placeHolderColor = HEXCOLOR(0x999999);
        
        [sub_view addSubview:tf];
        [_rightTfs  addObject:tf];
        [tf mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(100);
            make.trailing.equalTo(sub_view).offset(-40);
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
    
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.selected = NO;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(13);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 4;
        button.layer.borderWidth = 1;
        button.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
        button.backgroundColor = kWhiteColor;
    
//            [button setTitle:subtitleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x94368) forState:UIControlStateNormal];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [_funcBtns addObject:button];
    }
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:24 tailSpacing:(MAINSCREEN_WIDTH - 2*24 -2*100 -10)];
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(scrollView.mas_bottom).offset(6);
            make.height.mas_equalTo(28);
    //        make.width.mas_equalTo(100);
        }];
    

    UIButton* btn = _funcBtns[1];
    
    self.accountTagView = [[AccountTagView alloc]init];
    [self.contentView addSubview:self.accountTagView];
    self.accountTagView.alpha = 0.0;
    self.accountTagView.userInteractionEnabled = true;
    [self.accountTagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).offset(0);
    //        make.centerX.mas_equalTo(self.contentView);//bie
            make.left.right.equalTo(self.contentView).offset(-MAINSCREEN_WIDTH);
            make.height.mas_equalTo([AccountTagView cellHeightWithModel]);
        }];
    [self.accountTagView actionBlock:^(NSDictionary* data) {
        UIButton* btn = self.leftBtns[0];
        btn.tag = [data[kIndexRow]intValue];
        [btn setTitle:data[kSubTit] forState:UIControlStateNormal];
        [self.accountTagView disMissView];
        UITextField* tf = self.rightTfs[0];
        tf.userInteractionEnabled = YES;
        [tf becomeFirstResponder];
    }];
    
    self.accountPayView = [[AccountPayView alloc]init];
    [self.contentView addSubview:self.accountPayView];
    self.accountPayView.alpha = 0.0;
    self.accountPayView.userInteractionEnabled = true;
    [self.accountPayView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(btn.mas_bottom).offset(0);
    //        make.centerX.mas_equalTo(self.contentView);//bie
            make.left.right.equalTo(self.contentView).offset(-MAINSCREEN_WIDTH);
            make.height.mas_equalTo([AccountTagView cellHeightWithModel]);
        }];
    [self.accountPayView actionBlock:^(NSDictionary* data) {
        UserInfoModel *userInfoModel = [UserInfoManager GetNSUserDefaults];
        userInfoModel.isLogin = YES;
        userInfoModel.paySource = data[kSubTit];
        [UserInfoManager SetNSUserDefaults:userInfoModel];

        UIButton* btn = self.funcBtns[1];
        [btn setTitle:[UserInfoManager GetNSUserDefaults].paySource forState:UIControlStateNormal];
        [self.accountPayView disMissView];
    }];
}

- (void)showAccountTagView:(UIButton*)btn {
    [self.accountTagView showInView:self.contentView];
    [self.accountPayView disMissView];
}

- (void)funAdsButtonClickItem:(UIButton*)btn{
    if (btn.tag == EnumActionTag1) {
        [self.accountPayView showInView:self.contentView];
        [self.accountTagView disMissView];
    }
    if (btn.tag == EnumActionTag0) {
//        [self disMissAccountTagView];
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
//- (BOOL)textFieldShouldReturn:(UITextField *)textField{
//
//    [textField resignFirstResponder];
//    NSLog(@"//////");
//    return true;
//}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _rightTfs[0]&&![NSString isEmpty:textField.text]&& [textField.text floatValue] > 0) {
        UIButton* tagBtn = self.leftBtns[0];
        UIButton* dateBtn = _funcBtns[1];
        
        UserInfoModel *newUserInfoModel = [UserInfoManager GetNSUserDefaults];
        
        NSMutableArray* models = [NSMutableArray arrayWithArray:newUserInfoModel.tagArrs];
        
        NSArray* allTags = [[[AccountingModel new] getAccountingTagDataWithSelectedType:AccountingSelectedTypeAllStated]mutableCopy];
        
        for (int i=0; i< allTags.count; i++) {
            NSDictionary* dic = allTags[i];
            if (tagBtn.tag == [dic[kIndexRow]intValue]) {
                
//                if ([[dic allKeys] containsObject:kDate]
//                &&![NSString isEmpty:dic[kDate]]
//                ) {
//                    NSString* savedDateString =dic[kDate];
//                    if (savedDateString.hash == currentDay.hash) {
//
//                    }
//                }
                
                NSMutableDictionary* dic0= [NSMutableDictionary dictionaryWithDictionary:dic];
                
//                if ([[dic allKeys] containsObject:kAmount]
//                    &&[dic[kAmount] floatValue] > 0 ) {
//                    NSNumber* totalN = [NSString getNormalSumNumberByArray:@[dic[kAmount],textField.text]];
//                    [dic0 addEntriesFromDictionary:@{kAmount:totalN}];
//                }else{
                    [dic0 addEntriesFromDictionary:@{kAmount:textField.text}];
                    [dic0 addEntriesFromDictionary:@{kDate:[NSString currentDataStringWithFormatString:[NSString ymdSeparatedByPointFormatString]]}];
                    [dic0 addEntriesFromDictionary:@{kIsOn:[NSString stringWithFormat:@"%@",dateBtn.titleLabel.text]}];
//                }
                [models addObject:dic0];
//                [models replaceObjectAtIndex:i withObject:[dic0 mutableCopy]];
            }
        }
        newUserInfoModel.tagArrs = [models mutableCopy];

        [UserInfoManager SetNSUserDefaults:newUserInfoModel];
        
        [self selectTypeRefreshView];
    }
    if (self.block) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsLoginRefresh object:nil];
        self.block(@(1));
    }
}

- (void)richElementsInViewWithModel:(id)model{
    UIButton* btn0 = _funcBtns[0];
    [btn0 setTitle:[NSString currentDataStringWithFormatString:[NSString mdSeparatedByUnitFormatString]] forState:UIControlStateNormal];
    
    
    _selectedType = AccountingSelectedTypeOutcome;
    
    AccountingModel* amodel = [[AccountingModel alloc]init];
    
//    [amodel setDefaultDataIsForceInit:NO];
    
    UIButton* btn = _funcBtns[1];
    [btn setTitle:[UserInfoManager GetNSUserDefaults].paySource forState:UIControlStateNormal];
    
//    UserInfoModel *userInfoModel = [UserInfoManager GetNSUserDefaults];
//
//    NSString* currentDay = userInfoModel.currentDay;
//
//    NSString* today = [NSString currentDataStringWithFormatString:[NSString ymdSeparatedByPointFormatString]];
//
//    if (currentDay.hash != today.hash) {
//        [[AccountingModel new]setAccountingCurrentDayIsForceInit:YES];
//        [[AccountingModel new] setDefaultDataIsForceInit:YES];
//    }
    
    //no
    
//    else{
//        userInfoModel.currentDay =  currentDay;
////            userInfoModel.tagArrs = [models mutableCopy];
//    }
//
//    userInfoModel.tagArrs = [UserInfoManager GetNSUserDefaults].tagArrs;
//
//    [UserInfoManager SetNSUserDefaults:userInfoModel];
            
    NSArray* payModels = [[amodel getAccountingPayData]mutableCopy];
    [self.accountPayView richElementsInCellWithModel:payModels];
    
    [self selectTypeRefreshView];
}

- (void)selectTypeRefreshView {
    
    NSArray* tagModels = [[[AccountingModel new] getAccountingTagDataWithSelectedType:self.selectedType]mutableCopy];
    [self.accountTagView richElementsInCellWithModel:tagModels];
    
    UIButton* ymBtn = [_contentView viewWithTag:9];
    UIButton* paySourceBtn = _funcBtns[1];
    
    NSArray* tags = [UserInfoManager GetNSUserDefaults].tagArrs;
    
    NSArray* pieSums = [[AccountingModel new]getAccountingAssembledData:tags selectedType:self.selectedType withDistinction:AccountingDistinctionTypeMonthPie withDistinctionTime:ymBtn.titleLabel.text withDistinctionBalanceSource:paySourceBtn.titleLabel.text];
    
//    if (!pieSums || pieSums.count == 0) {
//        return;
//    }
    NSMutableArray* pieVs = [[NSMutableArray alloc] init];
    
    for (int i=0 ; i< pieSums.count; i++) {
        NSDictionary* dic = pieSums[i];
        PieModel *pm = [[PieModel alloc]init];
        pm.count = [dic[kTotal]floatValue];
        pm.title = dic[kIndexInfo];
        pm.descript = @"";
        pm.color = dic[kColor];
        [pieVs addObject:pm];
    }
    [self.monthPieChartView richEleInView:pieVs];
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

//- (void)funAdsButtonClickItem:(UITapGestureRecognizer*)btn{
//    if (self.block) {
//        self.block(@(btn.view.tag));
//    }
//    [self disMissView];
//}

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([touch.view isKindOfClass:[UIButton class]])
//    {
//        return NO;
//    }
//    return YES;
//}
//
//- (void)showInApplicationKeyWindow{
//    [self showInView:[UIApplication sharedApplication].keyWindow];
//    //iOS 13
////    [self showInView:[[UIApplication sharedApplication] delegate].window];
//    //    [popupView showInView:self.view];
//    //
//    //    [popupView showInView:[UIApplication sharedApplication].keyWindow];
//    //
//    //    [[UIApplication sharedApplication].keyWindow addSubview:popupView];
//}
//
//- (void)showInView:(UIView *)view {
//    if (!view) {
//        return;
//    }
//
//    [view addSubview:self];
//    [view addSubview:_contentView];
//
//    [_contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, MAINSCREEN_HEIGHT, XHHTuanNumViewWidth, _contentViewHeigth)];
//    WS(weakSelf);
//    [UIView animateWithDuration:0.3 animations:^{
//
//        weakSelf.alpha = 1.0;
//
//        [weakSelf.contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - weakSelf.contentViewHeigth)/2,XHHTuanNumViewWidth,weakSelf.contentViewHeigth)];
//
//    } completion:nil];
//}
//
////移除从上向底部弹下去的UIView（包含遮罩）
//- (void)disMissView {
//    WS(weakSelf);
//    [_contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
//    [UIView animateWithDuration:0.3f
//                     animations:^{
//
//                         weakSelf.alpha = 0.0;
//
//                         [weakSelf.contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, MAINSCREEN_HEIGHT, XHHTuanNumViewWidth, weakSelf.contentViewHeigth)];
//                     }
//                     completion:^(BOOL finished){
//
//                         [weakSelf removeFromSuperview];
//                         [weakSelf.contentView removeFromSuperview];
//
//                     }];
//}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_IsLoginRefresh object:nil];
}
@end

