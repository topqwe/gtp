//
//  MyVC.m

#import "MineVC.h"
#import "MineVM.h"
#import "EditRecordVC.h"

#import "ShareVC.h"

#import "WebViewController.h"
#import "EditUserInfoVC.h"

#import "SettingVC.h"

#import "UpdatePopUpView.h"
#import "LevelVC.h"
@interface MineVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView * baseView;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * imgArr;
@property (nonatomic, strong) UserInfoModel *userInfoModel;
@property (nonatomic, strong) UIButton * avatarBtn;
@property (nonatomic, strong) UILabel * userNameLab;
@property (nonatomic, strong) UILabel * userIdLab;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@property (nonatomic, strong) NSMutableArray *infoBtns;
@property (nonatomic, strong) MineVM *vm;
@end

@implementation MineVC
    
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(richElesInHV) name:kNotify_IsLoginOutRefresh object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushAssetVC) name:kNotify_jumpAssetVC object:nil];
    [self YBGeneral_baseConfig];
    _funcBtns = [NSMutableArray array];
    _infoBtns = [NSMutableArray array];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kNotify_DesMovieTimer object:nil];
    [self richElesInHV];
    [self requestHomeListWithPage:1 WithCid:1];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}
-(void)loginSuccessBlockMethod{
//    [self richElesInHV];
}

-(void)netwoekingErrorDataRefush{
//    [self richElesInHV];
}
#pragma mark - public requestData(HomeViewDelegate)

- (void) requestHomeListWithPage:(NSInteger)page WithCid:(NSInteger)cid{
    [self.vm network_getUserExtendInfoWithRequestParams:@(1)
            success:^(HomeModel * _Nonnull model) {
        
//        [self richElesInHV];
        
        NSArray* texts =@[
            [model.data.member_card getUserLevel],
        @{@"":[NSString stringWithFormat:@"%@",@""]}
        ];
        for (int i = 0; i < texts.count; i++) {
            NSDictionary* dic = texts[i];
            UIButton *titButton = self.infoBtns[i];
            [titButton setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@\n",dic.allKeys[0]] stringColor:HEXCOLOR(0xffffff) stringFont:[UIFont systemFontOfSize:18] subString:[NSString stringWithFormat:@"%@",dic.allValues[0]] subStringColor:HEXCOLOR(0xffffff) subStringFont:kFontSize(13) paragraphStyle:NSTextAlignmentLeft] forState:UIControlStateNormal];
        }
        
        [self.tableView.mj_header endRefreshing];
        
        } failed:^(id data) {
            
        }];
    
}
- (void)richElesInHV{
    _userInfoModel = [UserInfoManager GetNSUserDefaults];
    
    [self.avatarBtn setBackgroundImage:[_userInfoModel getUserAvatorImg] forState:0];
//    [self.avatorBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_userInfoModel.data.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_square_avator"]];
    
    self.userNameLab.text = [NSString stringWithFormat:@"%@",_userInfoModel.data.nickname];
    
    
    
    _dataSource = @[
                    @[
                        @{@"更新":@""}
                        ,@{@"设置":@""}
                      ]
                    ];
    
    [self.tableView reloadData];
}

- (void)editBtnClick{
    [EditUserInfoVC pushFromVC:self requestParams:_userInfoModel success:^(id data) {
        
    }];
}
- (void)funAdsButtonClickItem:(UIButton*)sender{
    switch (sender.tag) {
        case 0:
        {
            [LevelVC pushFromVC:self
                   requestParams:@0
                         success:^(id data) {
            }];
        }
            break;
        case 1:
        {
            [LevelVC pushFromVC:self
                   requestParams:@1
                         success:^(id data) {
            }];
        }
            break;
        default:
            break;
    }
}
- (UIView*) headerView{
    self.view.backgroundColor = [UIColor whiteColor];
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 115)];
    _baseView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_baseView];
    return _baseView;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = [self headerView];
        _tableView.backgroundColor = kTableViewBackgroundColor;
        kWeakSelf(self);
        [_tableView addMJHeaderWithBlock:^{
                     kStrongSelf(self);
                     self.currentPage = 1;
                     [self requestHomeListWithPage:self.currentPage WithCid:1];
         }];
    }
    return _tableView;
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
    return 55;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"mineCell";
    UITableViewCell *cell = (UITableViewCell*)[_tableView  dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary* dic = (_dataSource[indexPath.section])[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = dic.allKeys[0];
    cell.imageView.image = [UIImage imageNamed:dic.allValues[0]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger section = indexPath.section;
    
    switch (section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                {
                    [EditRecordVC pushFromVC:self
                           requestParams:EditRecordSourcViewHistory
                                 success:^(id data) {

                    }];
                }
                    break;
                case 1:
                {
                    [EditRecordVC pushFromVC:self
                           requestParams:EditRecordSourcMyCollect
                                 success:^(id data) {

                    }];
                }
                    break;
                case 2:
                {
                    [ShareVC pushFromVC:self
                           requestParams:@2
                                 success:^(id data) {
                    }];
                }
                    break;
                case 3:
                {
                    ConfigModel *configModel = [ConfigModel mj_objectWithKeyValues:GetUserDefaultWithKey(@"ConfigModel")];
                    if ([configModel getKFUrl].length>0) {
                        [WebViewController pushFromVC:self requestUrl:[configModel getKFUrl]  withProgressStyle:DKProgressStyle_Gradual success:^(id data) {

                        }];
                        
//                        AXWebViewController *webVC = [[AXWebViewController alloc] initWithAddress:[NSString stringWithFormat:@"%@",[configModel getKFUrl]]];
//    //                    webVC.showsToolBar = NO;
//    //                    webVC.showsNavigationBackBarButtonItemTitle = NO;
//                        webVC.navigationType = AXWebViewControllerNavigationToolItem;
//                        webVC.showsToolBar = YES;
//
//                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
//                        nav.navigationBar.tintColor = [UIColor colorWithRed:0.322 green:0.322 blue:0.322 alpha:1.00];
//                        [self presentViewController:nav animated:YES completion:NULL];
                    }
                }
                    break;
                case 5:
                {
                    [self checkUpdateVersion];

                }
                    break;
                case 6:
                {
                    [SettingVC pushFromVC:self requestParams:@(1) success:^(id data) {
                                            
                    }];

                }
                    break;
                default:
                    break;
            }
         break;
        
        default:
            break;
    }
}

-(void)checkUpdateVersion{
//    [YKToastView showToastText:@"目前已是最新版本"];
//    return;
    ConfigModel *configModel = [ConfigModel mj_objectWithKeyValues:GetUserDefaultWithKey(@"ConfigModel")];
    
    NSString* exV = configModel.version;
    
    NSString* downloadUrl = @"baidu.com";
    if (configModel.download_url&&
        configModel.download_url.length>0) {
        downloadUrl = configModel.download_url;
    }
    if ([YBSystemTool compareWithVersion1:exV] == 1) {
        NSArray* arr = @[
            @[
//                configModel.announcement
                @[@"",@"如果您的版本不是最新版，请前往\n"],
               @[ [NSString stringWithFormat:@"%@",downloadUrl],@"下载最新版本\n"],
                @[@"",@"下载前请注意，先保存二维码"]
            ]
        ];
        UpdatePopUpView* popupView = [[UpdatePopUpView alloc]init];
        [popupView richElementsInViewWithModel:@{[NSString stringWithFormat:@"版本%@",exV]:arr}];
        [popupView showInApplicationKeyWindow];
        [popupView actionBlock:^(NSNumber* data) {
            if ([data integerValue] == 0) {
//                [self dissmis];
                
            }else{
//                if (configModel.obUrl.length > 0 && configModel.anActionType == BannerTypeH5? true : false) {

                    NSURL *url = [NSURL URLWithString:downloadUrl];
                    [[UIApplication sharedApplication] openURL:url];
//                }
            }
            
        }];
    }else{
        [YKToastView showToastText:@"目前已是最新"];
    }
}
- (NSUInteger)currentPage {
    if (!_currentPage) {
        _currentPage = 0;
    }
    return _currentPage;
}
- (MineVM *)vm {
    if (!_vm) {
        _vm = [MineVM new];
    }
    return _vm;
}
-(void)dealloc {
    
//    [[NSNotificationCenter defaultCenter]removeObserver:self
//                                                   name:kNotify_IsLoginOutRefresh
//                                                 object:nil];
//
//    [[NSNotificationCenter defaultCenter]removeObserver:self
//                                                   name:kNotify_jumpAssetVC
//                                                 object:nil];
}
@end
