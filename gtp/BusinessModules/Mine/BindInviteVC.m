

#import "BindInviteVC.h"
#import "MineVM.h"

@interface BindInviteVC ()<UITextFieldDelegate>
@property (nonatomic, strong) MineVM* vm;

@property (nonatomic, strong) UserInfoModel* requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) UIButton *settingBtn;
@property (nonatomic, strong) UITextField * nickFiled;
@end

@implementation BindInviteVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    BindInviteVC *vc = [[BindInviteVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:238/255.0 blue:243/255.0 alpha:1.0];
    self.view.backgroundColor = UIColor.whiteColor;
    self.title = @"邀请码";
    
    
    self.settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingBtn.frame = CGRectMake(0,  0, 44, 54);
    self.settingBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.settingBtn addTarget:self action:@selector(confirmNickNAME) forControlEvents:UIControlEventTouchUpInside];
    //    [settingBtn setImage:kIMG(@"home_news") forState:UIControlStateNormal];
    [self.settingBtn setTitle:@"绑定" forState:UIControlStateNormal];
    self.settingBtn.titleLabel.font  = kFontSize(18);
    [self.settingBtn setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
    [self.settingBtn sizeToFit];
    UIBarButtonItem *settingBtnItem = [[UIBarButtonItem alloc] initWithCustomView:self.settingBtn];
    self.navigationItem.rightBarButtonItem = settingBtnItem;
    
    
    self.nickFiled = [UITextField new];
    self.nickFiled.backgroundColor = HEXCOLOR(0xECECEC);
    self.nickFiled.delegate = self;
    self.nickFiled.textColor = HEXCOLOR(0x333333);
    [self.nickFiled addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.nickFiled becomeFirstResponder];
    if (_requestParams == nil || [NSString isEmpty:_requestParams.data.nickname]) {
        self.nickFiled.placeholder = @"请输入邀请码";
        self.settingBtn.enabled = NO;
        self.settingBtn.alpha = 0.4;
    }else{
        self.nickFiled.text = _requestParams.data.nickname;
        self.settingBtn.enabled = YES;
        self.settingBtn.alpha = 1;
    }
    
    
    UILabel * leftView = [[UILabel alloc] initWithFrame:CGRectMake(0,0,7,44)];
    leftView.backgroundColor = [UIColor clearColor];
    self.nickFiled.leftView = leftView;
    self.nickFiled.leftViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:self.nickFiled];
    [self.nickFiled mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(15);
        make.height.mas_equalTo(44);
    }];
    self.nickFiled.layer.masksToBounds = YES;
    self.nickFiled.layer.cornerRadius = 10;
    
    UIButton* tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:tipBtn];
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
//        make.centerX.mas_equalTo(self.view);
        make.top.mas_equalTo(self.nickFiled.mas_bottom).offset(15);
        make.height.mas_equalTo(44);
    }];
    tipBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    tipBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    [tipBtn addTarget:self action:@selector(confirmNickNAME) forControlEvents:UIControlEventTouchUpInside];
    //    [settingBtn setImage:kIMG(@"home_news") forState:UIControlStateNormal];
    [tipBtn setTitle:@"注：只能绑定一次，且绑定后不允许修改，请核对输入是否正确" forState:UIControlStateNormal];
    tipBtn.titleLabel.font  = kFontSize(11);
    [tipBtn setTitleColor:HEXCOLOR(0xFF0000) forState:UIControlStateNormal];
    [tipBtn sizeToFit];
}

- (void) textFieldDidChange:(id) sender {
    
    UITextField * field = (UITextField *)sender;
    
    if ([NSString isEmpty:field.text]) {
        self.settingBtn.enabled = NO;
        self.settingBtn.alpha = 0.4;
    }else{
        self.settingBtn.enabled = YES;
        self.settingBtn.alpha = 1.0;
    }
}

-(void)confirmNickNAME{
    kWeakSelf(self);
    
    [self.vm network_postBindInviteCodeWithRequestParams:self.nickFiled.text success:^(id model) {
                                              kStrongSelf(self);
                                              if (self.block) {
                                                  [self.navigationController popViewControllerAnimated:YES];
                                                  //befor block set userStatus
                                            self.block(model);
                                              }
                                              
                                          }
                                           failed:^(id model){
                                               
                                           }];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.nickFiled) {
        //如果是删除减少字数，都返回允许修改
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (range.location>= 8)//8gc
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
@end
