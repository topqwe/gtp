//
//  MyVC.m

#import "SettingVC.h"


#import "EditUserInfoVC.h"

#import "BindInviteVC.h"
#import "EditRecordVC.h"

#import "ShareVC.h"
#import "PNVC.h"
@interface SettingVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView * baseView;
@property (nonatomic, strong) NSArray * dataSource;
@property (nonatomic, strong) NSArray * imgArr;
@property (nonatomic, strong) UserInfoModel *userInfoModel;
@property (nonatomic, strong) UIButton * avatarBtn;
@property (nonatomic, strong) UILabel * userNameLab;
@property (nonatomic, strong) UILabel * userIdLab;

@property (nonatomic, strong) NSMutableArray *funcBtns;

@property (nonatomic, strong) NSMutableArray *infoBtns;
@property (nonatomic, strong) UserInfoModel* requestParams;
@property (nonatomic, copy) DataBlock block;
@end

@implementation SettingVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    SettingVC *vc = [[SettingVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
    
- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(richElesInHV) name:kNotify_IsLoginOutRefresh object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushAssetVC) name:kNotify_jumpAssetVC object:nil];
    [self YBGeneral_baseConfig];
    _funcBtns = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    self.title = @"设置";
    [self richElesInHV];
}

-(void)loginSuccessBlockMethod{
    [self richElesInHV];
}

-(void)netwoekingErrorDataRefush{
    [self richElesInHV];
}

- (void)richElesInHV{
    _userInfoModel = [UserInfoManager GetNSUserDefaults];
    
    [self.avatarBtn setBackgroundImage:[_userInfoModel getUserAvatorImg] forState:0];
//    [self.avatorBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_userInfoModel.data.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default_square_avator"]];
    
    self.userNameLab.text = [NSString stringWithFormat:@"%@",_userInfoModel.data.nickname];
    
    _dataSource = @[
                    @[
                      @{@"个人资料":@""}
                      ,@{@"绑定邀请码":@""},
                      @{@"绑定账号":@""}
                      ,@{@"找回账号":@""}
                      ]
                    ];
    
    [self.tableView reloadData];
}

- (void)editBtnClick{
    [EditUserInfoVC pushFromVC:self requestParams:_userInfoModel success:^(id data) {
        
    }];
}

- (UIView*) headerView{
    _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 335)];
    _baseView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_baseView];
    
    self.avatarBtn = [[UIButton alloc] init];
    self.avatarBtn.adjustsImageWhenHighlighted = true;
    [_baseView addSubview:self.avatarBtn];
    [self.avatarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.baseView.mas_top).offset(32);
//        make.bottom.equalTo(self.userIdLab).offset(0);
        make.width.height.equalTo(@100);
//        make.left.equalTo(self.baseView.mas_left).offset(32);
    }];
    self.avatarBtn.layer.masksToBounds = YES;
    self.avatarBtn.layer.cornerRadius = 100/2;
    [self.avatarBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.userNameLab = [[UILabel alloc] init];
    [_baseView addSubview:self.userNameLab];
    self.userNameLab.font = [UIFont systemFontOfSize:20];
    self.userNameLab.textAlignment = NSTextAlignmentCenter;
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseView);
        make.top.equalTo(self.avatarBtn.mas_bottom).offset(15);
//        make.bottom.equalTo(self.userIdLab).offset(0);
        make.width.mas_equalTo(MAINSCREEN_WIDTH);
        make.height.equalTo(@25);
    }];
    
    UIImageView* sectionLine = [[UIImageView alloc]init];
    sectionLine.backgroundColor = HEXCOLOR(0xe8e9ed);
    [self.baseView addSubview:sectionLine];
    [sectionLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userNameLab.mas_bottom).offset(20);
        make.height.equalTo(@1);
        make.leading.equalTo(@0);
        make.centerX.equalTo(self.baseView);
    }];
    
    [self.baseView layoutIfNeeded];
    
    NSArray* subtitleArray =@[
        @{@"mol":[UIImage imageNamed:@"li_kl"]},
        @{@"more":[UIImage imageNamed:@"li_fm"]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 8;
//        button.layer.borderWidth = 0;
        [button setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        [button setBackgroundImage:dic.allValues[0] forState:UIControlStateNormal];
//        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20];
        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.baseView addSubview:button];
        [_funcBtns addObject:button];
        
    }
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:6 leadSpacing:13 tailSpacing:13];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sectionLine.mas_bottom).offset(20);
        make.height.equalTo(@100);
    }];
    [self.baseView layoutIfNeeded];
    
    NSArray* texts =@[
    @{@"":@""},
    @{@"":@""}
    ];
    for (int i = 0; i < texts.count; i++) {
    NSDictionary* dic = texts[i];
    UIButton *titButton = [UIButton buttonWithType:UIButtonTypeCustom];
        titButton.userInteractionEnabled = NO;
    titButton.tag =  i;
    titButton.adjustsImageWhenHighlighted = NO;
    titButton.titleLabel.numberOfLines = 0;
    titButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        titButton.titleLabel.font = kFontSize(15);
//        titButton.layer.masksToBounds = YES;
//        titButton.layer.cornerRadius = 8;
//        button.layer.borderWidth = 0;
//        [titButton setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
    titButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
//        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
    [titButton setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@\n",dic.allKeys[0]] stringColor:HEXCOLOR(0xffffff) stringFont:[UIFont systemFontOfSize:18] subString:[NSString stringWithFormat:@"%@",dic.allValues[0]] subStringColor:HEXCOLOR(0xffffff) subStringFont:kFontSize(13) paragraphStyle:NSTextAlignmentLeft] forState:UIControlStateNormal];
    
    //        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
    UIButton* button = _funcBtns[i];
    [button addSubview:titButton];
        [_infoBtns addObject:titButton];
        [titButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(button.mas_left).offset(10);
            make.top.equalTo(button.mas_top).offset(10);
            make.height.equalTo(@50);
//            make.leading.equalTo(@5);
//            make.centerX.equalTo(self.baseView);
        }];
//        [titButton setImage:kIMG(@"m_startOpen") forState:UIControlStateNormal];
//        [titButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleBottom imageTitleSpace:15];
        
        UIButton *clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
        clickButton.userInteractionEnabled = NO;
        clickButton.adjustsImageWhenHighlighted = NO;
        clickButton.titleLabel.numberOfLines = 0;
        clickButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        clickButton.titleLabel.font = kFontSize(13);
    //        titButton.layer.masksToBounds = YES;
    //        titButton.layer.cornerRadius = 8;
    //        button.layer.borderWidth = 0;
        [clickButton setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        clickButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        clickButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [clickButton setTitle:i == 0?@"":@"" forState:UIControlStateNormal];
        
        
        //        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:clickButton];
            [clickButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(button.mas_left).offset(10);
                make.bottom.equalTo(button.mas_bottom).offset(-10);
                make.height.equalTo(@30);
                make.width.equalTo(@110);
    //            make.centerX.equalTo(self.baseView);
            }];
            [clickButton setBackgroundImage:kIMG(@"m_startOpen") forState:UIControlStateNormal];
//            [clickButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleBottom imageTitleSpace:15];
    }

    
    UIButton* btn0 = _funcBtns[0];
    UIImageView* sectionLine1 = [[UIImageView alloc]init];
    sectionLine1.backgroundColor = HEXCOLOR(0xe8e9ed);
    [self.baseView addSubview:sectionLine1];
    [sectionLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn0.mas_bottom).offset(20);
        make.height.equalTo(@1);
        make.leading.equalTo(@0);
        make.centerX.equalTo(self.baseView);
    }];
    
    return _baseView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = [self headerView];
        _tableView.backgroundColor = kTableViewBackgroundColor;
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
                    [EditUserInfoVC pushFromVC:self
                           requestParams:[UserInfoManager GetNSUserDefaults]
                                 success:^(id data) {

                    }];
                }
                    break;
                case 1:
                {
                    [BindInviteVC pushFromVC:self
                           requestParams:nil
                                 success:^(id data) {

                    }];
                }
                    break;
                case 2:
                {
                    [PNVC pushFromVC:self requestParams:0 success:^(id data) {
                                            
                    }];
                }
                    break;
                case 3:
                {
                    [PNVC pushFromVC:self requestParams:1 success:^(id data) {
                                            
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
