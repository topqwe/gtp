//
//  ShareVC.m

#import "ShareVC.h"
#import "MineVM.h"

#import "MyShareVC.h"
#import "ZXingObjC.h"
@interface ShareVC ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate>
@property (nonatomic, strong)UIView * headerView;
@property (nonatomic, strong)UIImageView * QRView;
@property (nonatomic, copy) NSString *zfbQRCode;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView * baseView;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * imgArr;
@property (nonatomic, strong) UserInfoModel *userInfoModel;
@property (nonatomic, strong) UIButton * avatorBtn;
@property (nonatomic, strong) UILabel * userNameLab;
@property (nonatomic, strong) UILabel * userIdLab;

@property (nonatomic, strong) NSMutableArray *funcBtns;

@property (nonatomic, strong) id requestParams;

@property (nonatomic, strong) MineVM *vm;

@property (nonatomic ,strong) NSMutableArray *dataArray;//数据源
@end

@implementation ShareVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block{
    ShareVC *vc = [[ShareVC alloc] init];
//    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)leftButtonEvent{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _funcBtns = [NSMutableArray array];
//    [self YBGeneral_baseConfig];
    self.view.backgroundColor = UIColor.whiteColor;
    [self.rightBtn setTitle:@"我的分享" forState:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    [self.navigationItem addCustomLeftButton:self withImage:[UIImage imageNamed:@"icon_back_white"] andTitle:@""];
    [self.navigationItem addNavTitle:@"分享邀请" withTitleColor:kWhiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.tableView gradientLayerAboveView:self.view withShallowColor:HEXCOLOR(0x414141) withDeepColor:HEXCOLOR(0x0D0D0D) isVerticalOrHorizontal:true];
    
    [self.vm network_postShareWithRequestParams:@1
                                      success:^(HomeModel* model) {
        self.dataSource = @[
                        @[
                            @{@"更新":@""}
                            ,@{@"设置":@""}
                          ]
                        ];
        UIView* v= [self richElementsInView:model];
//        self.tableView.tableHeaderView = v;
//        [self.tableView reloadData];
      } failed:^(id data) {
          
      }];
    
//    [self richElesInHV];
}

- (UIView*)richElementsInView:(HomeModel*)model{
    
    _zfbQRCode = ![NSString isEmpty:model.data.promotion_url]?model.data.promotion_url:@"";
    
    //baseView = bottom saveImage
    self.headerView = [[UIView alloc]init];
    self.headerView.backgroundColor = UIColor.clearColor;
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset([YBFrameTool safeAdjustNavigationBarHeight]+2);
        make.leading.equalTo(self.view).offset(8);
        make.centerX.equalTo(self.view);
        
        //        make.bottom.equalTo(sub_view).offset(-9.5);
//        kGETVALUE_HEIGHT(178, 261, MAINSCREEN_WIDTH-16)
        make.height.mas_equalTo(kGETVALUE_HEIGHT(178, 261, MAINSCREEN_WIDTH-16)+95);
    }];
    
    self.baseView = [[UIView alloc]init];
    self.baseView.backgroundColor = UIColor.clearColor;
    [self.headerView addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.headerView).offset(8);
        make.centerX.equalTo(self.headerView);
        make.top.equalTo(self.headerView);
//        make.bottom.equalTo(self.headerView.mas_bottom).offset(-95);
        make.height.mas_equalTo(kGETVALUE_HEIGHT(178, 261, MAINSCREEN_WIDTH-32));
    }];
    
    UIImageView* bgImg = [[UIImageView alloc]init];
    [bgImg setImage:[UIImage imageNamed:@"mine_shareBg"]];
    [bgImg setContentMode:UIViewContentModeScaleAspectFill];
    [self.baseView addSubview:bgImg];
    [bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.baseView);
    }];
    
    
    UIButton* titleBtn = [[UIButton alloc] init];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    titleBtn.titleLabel.numberOfLines = 0;
    titleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.baseView addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView.mas_bottom).offset(-18);
        make.left.equalTo(self.baseView.mas_left).offset(18);
        make.height.equalTo(@38);
    }];
//    titleBtn.titleLabel.font = kFontSize(13);
//    [titleBtn setTitleColor:HEXCOLOR(0x464646) forState:UIControlStateNormal];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:![NSString isEmpty:model.data.invite_code]?model.data.invite_code:@"" attributes:@{
                                                                                                                                       NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Semibold" size: 16.0f],
                                                                                                                                       NSForegroundColorAttributeName: UIColor.whiteColor,
                                                                                                                                       NSKernAttributeName: @(0.0)
                                                                                                                                       }];
//    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size: 15.0f] range:NSMakeRange(3, 4)];
    [titleBtn setAttributedTitle:attributedString forState:UIControlStateNormal];//155
    
    
    self.QRView = [[UIImageView alloc]init];
    [self.baseView addSubview:self.QRView];
    [self.QRView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(titleBtn.mas_bottom).offset(0);
        make.right.equalTo(self.baseView.mas_right).offset(-18);
        //            make.width.mas_equalTo(@20);
        make.width.height.mas_equalTo(@96);
    }];
    
    
    if (![NSString isEmpty:_zfbQRCode]) {
        ZXEncodeHints *hints = [ZXEncodeHints hints];
        hints.encoding = NSUTF8StringEncoding;
        hints.margin = @(0);
        ZXQRCodeWriter *writer = [[ZXQRCodeWriter alloc] init];
        ZXBitMatrix *result = [writer encode:_zfbQRCode
                                      format:kBarcodeFormatQRCode
                                       width:200
                                      height:200
                                       hints:hints
                                       error:nil];
        self.QRView.image = [UIImage imageWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];//7 64
    }
    
    
    [self.baseView layoutIfNeeded];
    
    NSArray* subtitleArray =@[
    @{@"复制链接":[UIImage imageNamed:@"mine"]},
    @{@"保存图片":[UIImage imageNamed:@"mine"]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 35/2;
//        button.layer.borderWidth = 0;
        [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
//        [button setBackgroundImage:dic.allValues[0] forState:UIControlStateNormal];
        button.backgroundColor = YBGeneralColor.themeColor;
//        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20];
        
        [self.headerView addSubview:button];
        [_funcBtns addObject:button];
    }
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:13 tailSpacing:13];
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self.headerView.mas_bottom).offset(-70);
        make.height.equalTo(@35);
    }];

    
    UIButton* btn0 = _funcBtns[0];
    UIButton* btn1 = _funcBtns[1];
    if (![NSString isEmpty:_zfbQRCode]) {
        [btn0 addTarget:self action:@selector(copyCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn1 addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    UIButton* ruleBtn = [[UIButton alloc] init];
    ruleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.headerView addSubview:ruleBtn];
    [ruleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(btn0.mas_bottom).offset(18);
        make.height.equalTo(@30);
        make.leading.equalTo(@0);
        make.centerX.equalTo(self.baseView);
    }];
    ruleBtn.titleLabel.numberOfLines = 0;
    ruleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    ruleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13.0f];
//    [ruleBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    
    [ruleBtn setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@\n", @"请使用浏览器打开或扫码"] stringColor:HEXCOLOR(0xffffff) stringFont:[UIFont boldSystemFontOfSize:15] subString:[NSString stringWithFormat:@"规则：%@",model.data.reward_rules] subStringColor:HEXCOLOR(0x8FAEB7) subStringFont:kFontSize(15) paragraphStyle:NSTextAlignmentCenter] forState:0];
    
    return  self.headerView;
}
- (UIView*)twoLayersDisplayTopViewsSaveBottomBaseView:(HomeModel*)model{
    
//    _zfbQRCode = ![NSString isEmpty:model.data.promotion_url]?model.data.promotion_url:@"";//@"4028838a00003a8401697b77d28f0000";
    _zfbQRCode = @"https://www.baidu.com";
    
    //baseView = bottom saveImage
    self.baseView = [[UIView alloc]init];
    self.baseView.backgroundColor = HEXCOLOR(0x4c7fff);
    [self.view addSubview:self.baseView];
    [self.baseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(16);
        make.trailing.equalTo(self.view).offset(-16);
        make.top.equalTo(self.view).offset([YBFrameTool safeAdjustNavigationBarHeight]+17);
        //        make.bottom.equalTo(sub_view).offset(-9.5);
        make.height.equalTo(@488);
    }];
    
    UILabel* tiLab = [[UILabel alloc]init];
    [self.baseView addSubview:tiLab];
    tiLab.text = @"MA";
    tiLab.textColor = kWhiteColor;
    tiLab.textAlignment = NSTextAlignmentCenter;
    tiLab.font = kFontSize(25);
    [tiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseView.mas_top).offset(37);
        make.centerX.equalTo(self.baseView);
        make.height.mas_equalTo(@36);
    }];
    
    
    UIImageView* saveQRView = [[UIImageView alloc]init];
    [self.baseView addSubview:saveQRView];
    [saveQRView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tiLab.mas_bottom).offset(15);
        make.centerX.equalTo(self.baseView);
        //            make.width.mas_equalTo(@20);
        make.width.height.mas_equalTo(@185);
    }];
    if (![NSString isEmpty:_zfbQRCode]) {
        ZXEncodeHints *hints = [ZXEncodeHints hints];
        hints.encoding = NSUTF8StringEncoding;
        hints.margin = @(0);
        ZXQRCodeWriter *writer = [[ZXQRCodeWriter alloc] init];
        ZXBitMatrix *result = [writer encode:_zfbQRCode
                                      format:kBarcodeFormatQRCode
                                       width:200
                                      height:200
                                       hints:hints
                                       error:nil];
        saveQRView.image = [UIImage imageWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];//7 64
    }
    
    
    
    UIButton* nameBtn = [[UIButton alloc]init];
    [self.baseView addSubview:nameBtn];
    NSString* name = [NSString stringWithFormat:@"%@",@"fwefegfwegwege"];
    [nameBtn setTitle:name forState:UIControlStateNormal] ;
    nameBtn.titleLabel.numberOfLines = 0;
    [nameBtn setTitleColor:kWhiteColor forState:UIControlStateNormal] ;
    nameBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    nameBtn.titleLabel.font = kFontSize(20);
    [nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveQRView.mas_bottom).offset(20);
        make.centerX.equalTo(self.baseView);
        //        make.height.mas_equalTo(@36);
    }];
    
    UIButton* tipBtn = [[UIButton alloc]init];
    [self.baseView addSubview:tipBtn];
    [tipBtn setTitle:[NSString stringWithFormat:@"%@",@"打开 APP []"] forState:UIControlStateNormal] ;
    tipBtn.titleLabel.numberOfLines = 0;
    [tipBtn setTitleColor:kWhiteColor forState:UIControlStateNormal] ;
    tipBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    tipBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 25.0f];
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nameBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.baseView);
        make.height.mas_equalTo(@36);
    }];
    
    
    UIButton* iconBtn = [[UIButton alloc]init];
    [self.baseView addSubview:iconBtn];
    iconBtn.backgroundColor = kWhiteColor;
    [iconBtn setTitle:[NSString stringWithFormat:@"%@",@"名字"] forState:UIControlStateNormal] ;
    [iconBtn setImage:kIMG(@"icon-in-app90") forState:UIControlStateNormal];
    iconBtn.titleLabel.numberOfLines = 0;
    [iconBtn setTitleColor:HEXCOLOR(0x393738) forState:UIControlStateNormal] ;
    iconBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    iconBtn.titleLabel.font = kFontSize(24);
    [iconBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.baseView.mas_bottom).offset(0);
        make.centerX.equalTo(self.baseView);
        make.height.mas_equalTo(@96);
        make.left.right.equalTo(self.baseView);
    }];
    [iconBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    
    
    
    
    UIView* topView = [[UIView alloc]init];
    topView.backgroundColor = HEXCOLOR(0xb3e5e8f6);
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.top.equalTo(self.view).offset([YBFrameTool safeAdjustNavigationBarHeight]+17);
        //        make.bottom.equalTo(sub_view).offset(-9.5);
        make.height.equalTo(@50);
    }];
    
    
    
    [self.view layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:topView.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = topView.bounds;
    maskLayer.path = maskPath.CGPath;
    topView.layer.mask = maskLayer;
    
    UIButton* codeBtn = [[UIButton alloc] init];
    codeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [topView addSubview:codeBtn];
    //    [transferBtn addTarget:self action:@selector(transferBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(20);
        make.centerY.equalTo(topView);
        make.width.equalTo(@124);
    }];
    codeBtn.titleLabel.font = kFontSize(15);
    [codeBtn setTitleColor:HEXCOLOR(0x464646) forState:UIControlStateNormal];
    [codeBtn setTitle:@"二MA" forState:UIControlStateNormal];
    [codeBtn setImage:kIMG(@"myaccountPocket") forState:UIControlStateNormal];
    [codeBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:12];
    
    
    UIView* downView = [[UIView alloc]init];
    downView.userInteractionEnabled = YES;
    downView.backgroundColor = HEXCOLOR(0xffffff);
    [self.view addSubview:downView];
    [downView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(15);
        make.trailing.equalTo(self.view).offset(-15);
        make.top.equalTo(topView.mas_bottom).offset(0);
//        make.bottom.equalTo(sub_view).offset(-9.5);
        make.height.equalTo(@458);
    }];
    
    [self.view layoutIfNeeded];
    UIBezierPath *maskPath1 = [UIBezierPath bezierPathWithRoundedRect:downView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = downView.bounds;
    maskLayer1.path = maskPath1.CGPath;
    downView.layer.mask = maskLayer1;
    
    
    UIButton* titleBtn = [[UIButton alloc] init];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [downView addSubview:titleBtn];
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(downView.mas_top).offset(28);
        make.centerX.equalTo(downView);
        make.height.equalTo(@18);
    }];
    titleBtn.titleLabel.font = kFontSize(15);
    [titleBtn setTitleColor:HEXCOLOR(0x464646) forState:UIControlStateNormal];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"打开App向" attributes:@{
                                                                                                                                       NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Regular" size: 13.0f],
                                                                                                                                       NSForegroundColorAttributeName: [UIColor colorWithRed:35.0f / 255.0f green:38.0f / 255.0f blue:48.0f / 255.0f alpha:1.0f],
                                                                                                                                       NSKernAttributeName: @(0.0)
                                                                                                                                       }];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Semibold" size: 13.0f] range:NSMakeRange(2, 4)];
    [titleBtn setAttributedTitle:attributedString forState:UIControlStateNormal];//155
    
    
    self.QRView = [[UIImageView alloc]init];
    [downView addSubview:self.QRView];
    [self.QRView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleBtn.mas_bottom).offset(21);
        make.centerX.equalTo(downView);
        //            make.width.mas_equalTo(@20);
        make.width.height.mas_equalTo(@155);
    }];
    
//    _zfbQRCode = ![NSString isEmpty:data.address]?data.address:@"";//@"4028838a00003a8401697b77d28f0000";
    if (![NSString isEmpty:_zfbQRCode]) {
        ZXEncodeHints *hints = [ZXEncodeHints hints];
        hints.encoding = NSUTF8StringEncoding;
        hints.margin = @(0);
        ZXQRCodeWriter *writer = [[ZXQRCodeWriter alloc] init];
        ZXBitMatrix *result = [writer encode:_zfbQRCode
                                      format:kBarcodeFormatQRCode
                                       width:200
                                      height:200
                                       hints:hints
                                       error:nil];
        self.QRView.image = [UIImage imageWithCGImage:[[ZXImage imageWithMatrix:result] cgimage]];//7 64
    }
    
    UIButton* saveBtn = [[UIButton alloc] init];
    saveBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [downView addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QRView.mas_bottom).offset(7);
        make.centerX.equalTo(downView);
        make.height.equalTo(@64);
    }];
    if (![NSString isEmpty:_zfbQRCode]) {
        [saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    saveBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size: 13.0f];
    [saveBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
    [saveBtn setTitle:@"保存图片" forState:UIControlStateNormal];
    
    UIButton* addrBtn = [[UIButton alloc] init];
    addrBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    addrBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [downView addSubview:addrBtn];
    [addrBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(saveBtn.mas_bottom).offset(0);
        make.left.equalTo(downView).offset(27);
        make.right.equalTo(downView).offset(-27);
        make.height.equalTo(@74);
    }];
    [addrBtn addTarget:self action:@selector(copyAddrBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    addrBtn.titleLabel.numberOfLines = 0;
    addrBtn.titleLabel.font = kFontSize(13);
    [addrBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
    [addrBtn setTitle:[NSString stringWithFormat:@"地址：%@",_zfbQRCode] forState:UIControlStateNormal];
    addrBtn.titleLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    
    UIButton* copyBtn = [[UIButton alloc] init];
    copyBtn.userInteractionEnabled = NO;
    copyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    copyBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [addrBtn addSubview:copyBtn];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addrBtn.mas_top).offset(36);
        
        make.centerX.equalTo(addrBtn);
        make.height.equalTo(@38);
    }];
    copyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size: 13.0f];
    [copyBtn setTitleColor:HEXCOLOR(0x5584ff) forState:UIControlStateNormal];
    [copyBtn setTitle:[NSString stringWithFormat:@"复制"] forState:UIControlStateNormal];
    [copyBtn setImage:kIMG(@"grey_copy") forState:UIControlStateNormal];
    [copyBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:6];
    
    UIView* line = [[UIView alloc]init];
    [addrBtn addSubview:line];
    line.backgroundColor = HEXCOLOR(0xbbbbbb);
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(addrBtn.mas_bottom).offset(-1);
    
        make.left.right.equalTo(addrBtn).offset(0);
        
        make.height.equalTo(@1);
    }];//78  -12
    
    UIButton* transferBtn = [[UIButton alloc] init];
    transferBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    transferBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [downView addSubview:transferBtn];
//    [transferBtn addTarget:self action:@selector(goTransferBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(addrBtn.mas_right).offset(0);
        make.left.equalTo(downView.mas_left).offset(38);
        make.top.equalTo(addrBtn.mas_bottom).offset(0);
//        make.bottom.equalTo(downView.mas_bottom).offset(-12);
        make.height.equalTo(@78);
    }];
    transferBtn.titleLabel.font = kFontSize(14);
    [transferBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
    [transferBtn setTitle:@"查看" forState:UIControlStateNormal];
    [transferBtn setImage:kIMG(@"myaccountRecord") forState:UIControlStateNormal];
    [transferBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    
    UIImageView * arrowImgView = [[UIImageView alloc]init];
    arrowImgView.image = kIMG(@"btnRight");
    [transferBtn addSubview:arrowImgView];
    [arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(transferBtn.mas_right).offset(0);
        make.centerY.equalTo(transferBtn);
        //        make.bottom.equalTo(sub_view).offset(-9.5);
        make.height.width.equalTo(@24);
    }];
    return  self.baseView;
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message…
        [SVProgressHUD showErrorWithStatus:@"二维码保存失败，请去 隐私 > 照片 中打开「APP」的照片权限"];
    }
    else  // No errors
    {
        // Show message image successfully saved
        [SVProgressHUD showSuccessWithStatus:@"二维码保存成功"];
    }
    [SVProgressHUD dismissWithDelay:1];
}

-(void)saveBtnClick{
//    [SVProgressHUD showWithStatus:@"保存中..."];
    
//    UIImageWriteToSavedPhotosAlbum(self.QRView.image,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    
    
    [self.view layoutIfNeeded];
UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.baseView.width, self.baseView.height), NO, [UIScreen mainScreen].scale);
    
    [self.baseView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image,self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
    
}

- (void)copyCodeBtnClick:(UIButton*)sender{
    if (![NSString isEmpty:_zfbQRCode]) {
        [YKToastView showToastText:@"复制成功!"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _zfbQRCode;
    }
}
- (void)copyAddrBtnClick:(UIButton*)sender{
    if (![NSString isEmpty:sender.titleLabel.text]) {
        [YKToastView showToastText:@"复制成功!"];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = sender.titleLabel.text;
    }
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}
//- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 如果进入的是当前视图控制器
//    if (viewController == self) {
        // 背景设置为黑色
//        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
//        // 透明度设置为0.3
//        self.navigationController.navigationBar.alpha = 1;//0.300;
//        // 设置为半透明
//        self.navigationController.navigationBar.translucent = YES;
//    } else {
//   // 进入其他视图控制器
//        self.navigationController.navigationBar.alpha = 1;
//        // 背景颜色设置为系统默认颜色
//        self.navigationController.navigationBar.tintColor = nil;
//        self.navigationController.navigationBar.translucent = NO;
//    }
//}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.navigationController.delegate = self;
    self.navigationController.navigationBar.alpha = 1;//0.300;
    // 背景设置为黑色
//        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
    // 设置为半透明
    self.navigationController.navigationBar.translucent = YES;
    //2.设置有没有Navi的情况
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if(@available(iOS 15, *)) {
     UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
     [appearance configureWithOpaqueBackground];
     appearance.backgroundColor = HEXCOLOR(0x414141);
        appearance.shadowColor = [UIColor clearColor];
     self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance=self.navigationController.navigationBar.standardAppearance;
     }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.delegate = self;
    self.navigationController.navigationBar.alpha = 1;
    // 背景颜色设置为系统默认颜色
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.translucent = NO;
    //设置有没有Navi的情况
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if(@available(iOS 15, *)) {
     UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
     [appearance configureWithOpaqueBackground];
     appearance.backgroundColor = YBGeneralColor.navigationBarColor;
        appearance.shadowColor = [UIColor clearColor];
     self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance=self.navigationController.navigationBar.standardAppearance;
     }
}

- (void)richElesInHV{
    _userInfoModel = [UserInfoManager GetNSUserDefaults];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* arr = _dataSource[section];
    return [arr count];
}
#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90.1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"mineCell";
    UITableViewCell *cell = (UITableViewCell*)[_tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary* dic = (_dataSource[indexPath.section])[indexPath.row];
    cell.textLabel.text = dic.allKeys[0];
    cell.imageView.image = [UIImage imageNamed:dic.allValues[0]];
    
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kClearColor;
    }
    return _tableView;
}

- (void)naviRightBtnEvent:(UIButton *)sender{
    [MyShareVC pushFromVC:self requestParams:0 success:^(id data) {
        
    }];
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (MineVM *)vm {
    if (!_vm) {
        _vm = [MineVM new];
    }
    return _vm;
}
@end
