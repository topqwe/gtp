//
//  EditUserInfoVC.m
//  gt
//
//  Created by cookie on 2018/12/26.
//  Copyright © 2018 GT. All rights reserved.
//

#import "EditUserInfoVC.h"

#import "MineVM.h"
#import "ChangeNicknameVC.h"
#import "PickerPopUpView.h"
#import "ChangeAvatarPopUpView.h"
@interface EditUserInfoVC ()

@property (nonatomic, strong)UIButton *editNameBtn;
@property (nonatomic, strong) MineVM* vm;

@property (nonatomic, strong) UserInfoModel* requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, copy)NSString * nickName;
@property (nonatomic, strong) UILabel * userNameLab;
@property (nonatomic, strong) UIButton * avatarBtn;
@end

@implementation EditUserInfoVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    EditUserInfoVC *vc = [[EditUserInfoVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
#pragma mark - life cycle
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _requestParams = [UserInfoManager GetNSUserDefaults];
    
    [self.avatarBtn setBackgroundImage:[_requestParams getUserAvatorImg] forState:UIControlStateNormal];
    
    [self changeNickName:self.requestParams];
    [self changeGender:self.requestParams];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"个人资料";
    [self initView];
}

- (void)editBtnClick:(UIButton*)sender{

    _requestParams = [UserInfoManager GetNSUserDefaults];
    switch (sender.tag) {
        case EditRecordSourceAvatar:
        {
            NSArray* arr = @[
                @[
                [UserInfoModel getUserAvatorImgArrs]
                ]
            ];
            ChangeAvatarPopUpView* popupView = [[ChangeAvatarPopUpView alloc]init];
            [popupView richElementsInViewWithModel:arr];
            [popupView showInApplicationKeyWindow];
            [popupView actionBlock:^(id data) {
                NSDictionary* dic = data;
                [self.avatarBtn setBackgroundImage:dic.allValues[0] forState:UIControlStateNormal];
                [self.vm network_postEditUserInfosWithRequestParams:dic.allKeys[0] WithSource:EditRecordSourceAvatar
                success:^(UserInfoModel* model) {
//                    UIButton* contentBtn = [self.view viewWithTag:EditRecordSourceAvatar];
                    [self.avatarBtn setBackgroundImage:[model getUserAvatorImg] forState:UIControlStateNormal];
//                    [popupView disMissView];
                  }
               failed:^(id model){
                   
               }];
                
            }];
        }
            break;
        case EditRecordSourceNickName:
        {
            [ChangeNicknameVC pushFromVC:self requestParams:_requestParams success:^(UserInfoModel* model) {
                [self changeNickName:model];
            }];
        }
            break;
        case EditRecordSourceGender:
        {
            PickerPopUpView* popupView = [[PickerPopUpView alloc]init];
            [popupView richElementsInViewWithModel:@[@"男",@"女",@"不显示"]];
            [popupView showInView:self.view];
            [popupView actionBlock:^(id data) {
                UserInfoModel* requestParams = [UserInfoManager GetNSUserDefaults];
                requestParams.data.sex =  [data integerValue];
                [UserInfoManager SetNSUserDefaults:requestParams];
                [self changeGender:requestParams];
                
                [self.vm network_postEditUserInfosWithRequestParams:data WithSource:EditRecordSourceGender
                success:^(UserInfoModel* model) {
                    [self changeGender:model];
                  }
               failed:^(id model){
                   
               }];
                
            }];
        }
            break;
        default:
            break;
    }
}

- (void)changeNickName:(UserInfoModel*)model{
    UIButton* contentNickBtn = [self.view viewWithTag:EditRecordSourceNickName];
    [contentNickBtn setTitle:model.data.nickname forState:0];
    [contentNickBtn setImage:[UIImage imageNamed:@"right_gray_arrow"] forState:UIControlStateNormal];
    [contentNickBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
}

- (void)changeGender:(UserInfoModel*)model{
    UIButton* contentGenderBtn = [self.view viewWithTag:EditRecordSourceGender];
    [contentGenderBtn setTitle:[model getUserGender] forState:0];
    [contentGenderBtn setImage:[UIImage imageNamed:@"right_gray_arrow"] forState:UIControlStateNormal];
    [contentGenderBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
}


-(void)initView{
    UIView * lineOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 5)];
    lineOne.backgroundColor = [UIColor colorWithRed:242.0/256 green:241.0/256 blue:246.0/256 alpha:1];
    [self.view addSubview:lineOne];
    
    self.avatarBtn = [[UIButton alloc] init];
    [self.view addSubview:self.avatarBtn];
    self.avatarBtn.adjustsImageWhenHighlighted = NO;
    self.avatarBtn.tag = 0;
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.view.mas_top).offset(32);
//        make.bottom.equalTo(self.userIdLab).offset(0);
        make.width.height.equalTo(@100);
//        make.left.equalTo(self.baseView.mas_left).offset(32);
    }];
    [self.avatarBtn setBackgroundImage:[_requestParams getUserAvatorImg] forState:0];
    self.avatarBtn.layer.masksToBounds = YES;
    self.avatarBtn.layer.cornerRadius = 100/2;
    [self.avatarBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.userNameLab = [[UILabel alloc] init];
    [self.view addSubview:self.userNameLab];
    self.userNameLab.font = [UIFont systemFontOfSize:13];
    self.userNameLab.textAlignment = NSTextAlignmentCenter;
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.avatarBtn.mas_bottom).offset(15);
//        make.bottom.equalTo(self.userIdLab).offset(0);
        make.width.mas_equalTo(MAINSCREEN_WIDTH);
        make.height.equalTo(@25);
    }];
    self.userNameLab.textColor = RGBSAMECOLOR(102);
    self.userNameLab.text = @"点击更换头像";
    
    NSArray * titleArr = @[
        @{@"用户名":[NSString stringWithFormat:@"%@",_requestParams.data.nickname]},
        @{@"性别":[NSString stringWithFormat:@"%@",[_requestParams getUserGender]]}
    ];

    [self.view layoutIfNeeded];
    
    for (int i = 1; i < 3; i ++){
        NSDictionary* dic = titleArr[i-1];
        UIButton * titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(26, CGRectGetMaxY(self.avatarBtn.frame) + 33 + (50 * i), 65, 24)];
        [titleBtn setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        [titleBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
        titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        titleBtn.tag = i;
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:titleBtn];
        
        UIButton * contentBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleBtn.frame) + 10, titleBtn.frame.origin.y, MAINSCREEN_WIDTH - CGRectGetMaxX(titleBtn.frame) - 10 - 16, 24)];
        [contentBtn setTitle:dic.allValues[0] forState:UIControlStateNormal] ;
        contentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        contentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [contentBtn setTitleColor:RGBSAMECOLOR(102) forState:UIControlStateNormal];
        contentBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.view addSubview:contentBtn];
        contentBtn.tag = i;
        [contentBtn setImage:[UIImage imageNamed:@"right_gray_arrow"] forState:UIControlStateNormal];
        [contentBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];

        
//        [titleBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [contentBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
//        UIView * lineTwo = [[UIView alloc] initWithFrame:CGRectMake(26, CGRectGetMaxY(titleBtn.frame) + 5, MAINSCREEN_WIDTH - 26, 1)];
//        lineTwo.backgroundColor = [UIColor colorWithRed:242.0/256 green:241.0/256 blue:246.0/256 alpha:1];
//        [self.view addSubview:lineTwo];
        
    }
    
//    WS(weakSelf);
//    [self.view bottomSingleButtonInSuperView:self.view WithButtionTitles:@"退出登录" leftButtonEvent:^(id data) {
//        [weakSelf logOutBtnClick];
//    }];
    
    
}

-(void)logOutBtnClick{
    
}

- (MineVM *)vm {
    if (!_vm) {
        _vm = [MineVM new];
    }
    return _vm;
}
@end
