

#import "PNVC.h"
#import "MineVM.h"
#import "MHD_CountryPickerView.h"
@interface PNVC ()<UITextFieldDelegate>
@property (nonatomic, strong) LoginVM *loginVM;
@property (nonatomic, strong) MineVM* vm;
@property (nonatomic,retain)MHD_CountryPickerView *defaultPickerView;
@property (nonatomic, assign) NSInteger requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UITextField * codeFiled;
@property (nonatomic, strong) UITextField * nickFiled;
@property (nonatomic, strong) UIView * contentBgView;
@property (nonatomic, strong) UIButton * submitBtn;
@property (nonatomic, strong) UIButton *countryBtn;
@property (nonatomic, strong) UITextView * textView;


@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) TwoDataBlock timeBlock;

@property (nonatomic, assign) NSInteger countryCode;
@end

@implementation PNVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(NSInteger )requestParams success:(DataBlock)block
{
    PNVC *vc = [[PNVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:238/255.0 blue:243/255.0 alpha:1.0];
    self.view.backgroundColor = UIColor.whiteColor;
    
    if (self.requestParams == 1) {
        self.title = @"";
    }else{
    
        self.title = @"";
    
    self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingBtn.frame = CGRectMake(0,  0, 44, 54);
    self.settingBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.settingBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    //    [settingBtn setImage:kIMG(@"home_news") forState:UIControlStateNormal];
    [self.settingBtn setTitle:@"" forState:UIControlStateNormal];
    self.settingBtn.titleLabel.font  = kFontSize(18);
    [self.settingBtn setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
    [self.settingBtn sizeToFit];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingBtn];
    self.navigationItem.rightBarButtonItem = settingBtnItem;
    }
    
    [self.view addSubview:self.contentBgView];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(15);
        make.height.mas_equalTo(44);
    }];
    
    

    self.nickFiled = [UITextField new];
    self.nickFiled.keyboardType =  UIKeyboardTypeNumberPad;
    self.nickFiled.tintColor = YBGeneralColor.themeColor;
    self.nickFiled.tag = 99;
    self.nickFiled.delegate = self;
    self.nickFiled.textColor = HEXCOLOR(0x333333);
    self.nickFiled.placeholder = @"请输入手机号";
    [self.nickFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.nickFiled becomeFirstResponder];
    
    
    self.nickFiled.backgroundColor = [UIColor clearColor];
    
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,7,44)];
    leftView.backgroundColor = [UIColor clearColor];
    self.nickFiled.leftView = leftView;
    self.nickFiled.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.nickFiled];
    [self.nickFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(100);
        make.right.mas_equalTo(-17);
//        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(15);
        make.height.mas_equalTo(44);
    }];
    
    
    UIButton* countryBtn = [[UIButton alloc]init];
    self.countryBtn = countryBtn;
    [countryBtn setBackgroundColor:kClearColor];
    [self.view addSubview:countryBtn];
    
    countryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    countryBtn.titleLabel.numberOfLines = 0;
    countryBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    icon.titleLabel.font = kFontSize(12);
    [countryBtn setBackgroundImage:[UIImage new] forState:0];
    [countryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.nickFiled.mas_left).offset(-15);
//        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(15);
        make.height.mas_equalTo(44);
    
    }];
//    countryBtn.layer.masksToBounds = YES;
//    countryBtn.layer.cornerRadius = 44/2;
//    countryBtn.backgroundColor = YBGeneralColor.themeColor;
    [countryBtn setTitle:@"+86" forState:0];
    self.countryCode = 86;
    [countryBtn setImage:kIMG(@"M_≤") forState:0];
    [countryBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
    [countryBtn setTitleColor:HEXCOLOR(0x000000) forState:0];
//    [countryBtn setTitle:@"提交" forState:0];
    [countryBtn addTarget:self action:@selector(countryCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    countryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    
    UIButton* timeBtn = [[UIButton alloc]init];
    timeBtn.tag = 3;
    [timeBtn setBackgroundColor:kClearColor];
    [self.view addSubview:timeBtn];
    
    timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    timeBtn.titleLabel.numberOfLines = 0;
    timeBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    icon.titleLabel.font = kFontSize(12);
    [timeBtn setBackgroundImage:[UIImage new] forState:0];
    self.timeBtn = timeBtn;
    [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(100);
        
            make.right.mas_equalTo(-15);
            make.top.mas_equalTo(self.nickFiled.mas_bottom).offset(25);
            make.height.mas_equalTo(44);
        
    }];
    timeBtn.layer.masksToBounds = YES;
    timeBtn.layer.cornerRadius = 44/2;
    timeBtn.backgroundColor = YBGeneralColor.themeColor;
    [timeBtn setTitleColor:HEXCOLOR(0xffffff) forState:0];
    [timeBtn setTitle:@"获取验证码" forState:0];
    [timeBtn addTarget:self action:@selector(countClick:) forControlEvents:UIControlEventTouchUpInside];
    timeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    if (self.requestParams == 1) {
    UIButton* submitBtn = [[UIButton alloc]init];
        self.submitBtn = submitBtn;
    [submitBtn setBackgroundColor:kClearColor];
    [self.view addSubview:submitBtn];
    
    submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    submitBtn.titleLabel.numberOfLines = 0;
    submitBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    icon.titleLabel.font = kFontSize(12);
    [submitBtn setBackgroundImage:[UIImage new] forState:0];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.timeBtn.mas_bottom).offset(50);
        make.height.mas_equalTo(44);
        make.left.mas_equalTo(50);
        
        make.centerX.mas_equalTo(self.view);
        
    }];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 44/2;
    submitBtn.backgroundColor = YBGeneralColor.themeColor;
    [submitBtn setTitleColor:HEXCOLOR(0xffffff) forState:0];
    [submitBtn setTitle:@"提交" forState:0];
    [submitBtn addTarget:self action:@selector(submitClick:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    
    self.codeFiled = [UITextField new];
    self.codeFiled.tag = 100;
    self.codeFiled.keyboardType =  UIKeyboardTypeNumberPad;
    self.codeFiled.tintColor = YBGeneralColor.themeColor;
    self.codeFiled.backgroundColor = HEXCOLOR(0xECECEC);
    self.codeFiled.layer.masksToBounds = YES;
    self.codeFiled.layer.cornerRadius = 44/2;
    self.codeFiled.layer.borderWidth = 0.5f;
    self.codeFiled.layer.borderColor= [UIColor clearColor].CGColor;
    self.codeFiled.delegate = self;
    self.codeFiled.textColor = HEXCOLOR(0x333333);
    self.codeFiled.placeholder = @"   请输入验证码";
    [self.codeFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
//    [self.codeFiled becomeFirstResponder];
    
    
//    UILabel * leftView0 = [[UILabel alloc] initWithFrame:CGRectMake(34,0,14,44)];
//    leftView0.backgroundColor = [UIColor clearColor];
//    self.codeFiled.leftView = leftView0;
//    self.codeFiled.leftViewMode = UITextFieldViewModeAlways;
    [self.codeFiled setValue:[NSNumber numberWithInt:16] forKey:@"paddingLeft"];
    [self.view addSubview:self.codeFiled];
    [self.codeFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(self.timeBtn.mas_left).offset(-15);
//        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.timeBtn.mas_top);
        make.height.mas_equalTo(44);
    }];
    
    if (self.requestParams == 0) {
     
    UIButton* tipBtn = [[UIButton alloc]init];
    tipBtn.userInteractionEnabled = NO;
    [tipBtn setBackgroundColor:kClearColor];
    [self.view addSubview:tipBtn];
    
    tipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    tipBtn.titleLabel.numberOfLines = 0;
    tipBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//    icon.titleLabel.font = kFontSize(12);
    [tipBtn setBackgroundImage:[UIImage new] forState:0];
    
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        
            
            make.top.mas_equalTo(self.codeFiled.mas_bottom).offset(25);
            make.height.mas_equalTo(44);
        make.left.mas_equalTo(15);
        
//        make.centerX.mas_equalTo(self.view);
        
        
        
    }];
//    tipBtn.layer.masksToBounds = YES;
//    tipBtn.layer.cornerRadius = 44/2;
    
    [tipBtn setTitleColor:HEXCOLOR(0xFF0000) forState:0];
    [tipBtn setTitle:@"" forState:0];
    
    tipBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
}
- (void)countryCodeBtnAction:(UIButton *)btn
{
    [self.nickFiled resignFirstResponder];
    [self.codeFiled resignFirstResponder];
    [self.defaultPickerView showCountryPickerView];
}
- (MHD_CountryPickerView *)defaultPickerView
{
    
    WS(weakSelf);
    if (!_defaultPickerView) {
        _defaultPickerView = [[MHD_CountryPickerView alloc] init];
        _defaultPickerView.pickerViewHeight = 350;
        _defaultPickerView.cancelButtonTitleColor = UIColor.lightGrayColor;
        _defaultPickerView.confirmButtonTitleColor = YBGeneralColor.themeColor;
        _defaultPickerView.centerTitle = @"";
        _defaultPickerView.confirmClickBlock = ^(NSString * _Nonnull countryName, NSString * _Nonnull countryCode) {
            weakSelf.countryCode = [countryCode integerValue];
//            NSLog(@"_%@_%@",countryName,countryCode);
            [weakSelf.countryBtn setTitle:[NSString stringWithFormat:@"+%@",countryCode] forState:0];
            [weakSelf.countryBtn setImage:kIMG(@"M_≤") forState:0];
            [weakSelf.countryBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        };
        [self.view addSubview:_defaultPickerView];
    }
    return _defaultPickerView;
}

- (UIView *)contentBgView
{
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentBgView.backgroundColor = HEXCOLOR(0xECECEC);
        _contentBgView.layer.masksToBounds = YES;
        _contentBgView.layer.cornerRadius = 44/2;
        _contentBgView.layer.borderWidth = 0.5f;
        _contentBgView.layer.borderColor= [UIColor clearColor].CGColor;
        
    }
    return _contentBgView;
}

- (void) textFieldDidChange:(id) sender {
    
//    UITextField * field = [self.view viewWithTag:99];
//    UITextField * field0 = [self.view viewWithTag:100];
//    if ([NSString isEmpty:field.text]&&
//        [NSString isEmpty:field0.text]) {
//        self.submitBtn.enabled = NO;
//        self.settingBtn.enabled = NO;
//        self.settingBtn.alpha = 0.4;
//    }else{
//        self.submitBtn.enabled = YES;
//        self.settingBtn.enabled = YES;
//        self.settingBtn.alpha = 1.0;
//    }
}

-(void)countClick:(UIButton*)btn{
    if (self.nickFiled.text.length>0) {
        NSInteger second = 60;
        ConfigModel *configModel = [ConfigModel mj_objectWithKeyValues:GetUserDefaultWithKey(@"ConfigModel")];
        if (configModel.send_sms_intervals >0) {
            second = configModel.send_sms_intervals;
        }
        [self startTimeCount:[NSString stringWithFormat:@"%ld s",(long)second]];
        [self.vm network_postPWCode:@[@([self.nickFiled.text integerValue]),@(self.countryCode)] WithSource:self.requestParams success:^(NSArray * _Nonnull dataArray) {
                
            } failed:^(id data) {
                
        }];
    }else{
        [YKToastView showToastText:@"请输入手机号"];
    }
    
}

- (void)timeActionBlock:(TwoDataBlock)timeBlock{

    self.timeBlock = timeBlock;
}

/**设置倒计时时间，并启动倒计时*/
- (void)startTimeCount:(NSString *)sec
{
    if (sec) {
        self.timeCount = [sec integerValue];
    } else {
        self.timeCount = 60;
    }
    
    [self distoryTimer];
    self.timeBtn.enabled = false;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(_timerAction)
                                                userInfo:nil
                                                 repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**停止定时器*/
- (void)distoryTimer
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark timer
- (void) _timerAction
{
    self.timeCount--;
    
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%ld s",(long)self.timeCount] forState:0];
    [self.timeBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    self.timeBtn.backgroundColor = HEXCOLOR(0x8FAEB7);
    self.timeBtn.userInteractionEnabled = NO;
    
//    [NSString transToHMSSeparatedByColonFormatSecond:self.timeCount]
    if(self.timeCount < 0){
        [self distoryTimer];
        self.timeBtn.enabled = true;
//        self.timeBtn.hidden = true;
        
//        [self.timeBtn setTitle:@"0 s" forState:UIControlStateNormal];
        [self.timeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [self.timeBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        self.timeBtn.backgroundColor = YBGeneralColor.themeColor;
        self.timeBtn.userInteractionEnabled = true;
        if (self.timeBlock) {
            self.timeBlock(@(_timeBtn.tag), _timeBtn);
        }
        
    }
}

- (void) removeFromSuperview
{
//    [super removeFromSuperview];

    [self distoryTimer];
    [self.defaultPickerView hideCountryPickerView];
}

-(void)submitClick:(UIButton*)sender{
    
    UITextField * field = [self.view viewWithTag:99];
    UITextField * field0 = [self.view viewWithTag:100];
    if ([NSString isEmpty:field.text]||
        [NSString isEmpty:field0.text]) {
        
        [YKToastView showToastText:@"手机号和验证码都请填写完整"];
        return;
    }
    kWeakSelf(self);
//    [[NSString stringWithFormat:@"%li",(long)self.countryCode] stringByAppendingString:self.nickFiled.text]
    
//    if (self.requestParams == 0) {
//        [self.settingBtn setTitleColor:HEXCOLOR(0x8FAEB7) forState:UIControlStateNormal];
//        self.settingBtn.userInteractionEnabled = NO;
//    }
    
    
    [self.vm network_postPW:@[[NSString stringWithFormat:@"%@",self.nickFiled.text],self.codeFiled.text] WithSource:self.requestParams
                                          success:^(id model) {
                                              kStrongSelf(self);
        if (self.requestParams == 1) {
            [self.loginVM network_postLoginWithRequestParams:@{}
                success:^(UserInfoModel* model) {
                if (self.block) {
                    [[NSNotificationCenter defaultCenter]
                     postNotificationName:kNotify_LevRefresh object:@{@"p":@""}];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    self.block(model);
                }
                
                }
                failed:^(id model){
                }
                error:^(id model){
                }];
        }else{
            if (self.block) {
                [self.navigationController popViewControllerAnimated:YES];
                
                self.block(model);
            }
            
        }
        
                                              
                                          }
                                           failed:^(id model){
//        if (self.block) {
//            [self.navigationController popViewControllerAnimated:YES];
//            //befor block set userStatus
//      self.block(model);
//        }
//        [[NSNotificationCenter defaultCenter]
//         postNotificationName:kNotify_LevRefresh object:@{@"p":@""}];
                                           }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.nickFiled) {
        //如果是删除减少字数，都返回允许修改
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (range.location>= 18)//8gc
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    if (textField == self.codeFiled) {
        //如果是删除减少字数，都返回允许修改
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (range.location>= 10)//8gc
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

- (MineVM *)vm {
    if (!_vm) {
        _vm = [MineVM new];
    }
    return _vm;
}
- (LoginVM *)loginVM {
    if (!_loginVM) {
        _loginVM = [LoginVM new];
    }
    return _loginVM;
}
@end
