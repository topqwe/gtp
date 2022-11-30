
#import "RewResultPopUpView.h"
#define XHHTuanNumViewHight 382
#define XHHTuanNumViewWidth 306

@interface RewResultPopUpCell : UITableViewCell
@property (nonatomic, strong) UITextField * codeFiled;
- (void)actionBlock:(DataBlock)block;
+ (CGFloat)cellHeightWithModel:(id)model;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(id)model WithIndexRow:(NSInteger)row;
@end

@interface RewResultPopUpCell ()<UITextFieldDelegate>
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIButton *fanBtn;
@end

@implementation RewResultPopUpCell
- (void)actionBlock:(DataBlock)block
{
    self.block = block;
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
    
    
    _titleBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.titleBtn];
//    _titleBtn.frame = CGRectMake(_nameBtn.frame.origin.x, [[self class]cellHeightWithModel]-6*10, _nameBtn.frame.size.width, 50);
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(0);
//        make.left.equalTo(self.contentView.mas_left).offset(13);
        make.height.equalTo(@90);
        make.width.equalTo(@90);
        make.centerX.equalTo(self.contentView);
//        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
//    _titleBtn.layer.masksToBounds = true;
//    _titleBtn.layer.cornerRadius = 8;
    _titleBtn.userInteractionEnabled = NO;
    _titleBtn.backgroundColor = [UIColor clearColor];
    [_titleBtn setTitleColor:HEXCOLOR(0x8FAEB7) forState:0];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
//    _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//    _titleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    _titleBtn.contentMode = UIViewContentModeScaleToFill;
    _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
    _titleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    _titleBtn.imageView.contentMode = UIViewContentModeScaleToFill;
}

+(instancetype)cellWith:(UITableView*)tabelView{
    RewResultPopUpCell *cell = (RewResultPopUpCell *)[tabelView dequeueReusableCellWithIdentifier:@"RewResultPopUpCell"];
    if (!cell) {
        cell = [[RewResultPopUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RewResultPopUpCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(id)model{
    return 105;
}

- (void)richElementsInCellWithModel:(NSString*)model WithIndexRow:(NSInteger)row{
    _titleBtn.tag = row;
    [_titleBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",model]] forState:0];
//    _titleBtn.titleLabel.numberOfLines = 0;
//    _titleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
//    [_titleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
//
//        make.height.mas_equalTo([[self class]cellHeightWithModel:model]);
//    }];
    //    [self.contentView layoutIfNeeded];
}
@end

@interface RewResultPopUpView()<UIGestureRecognizerDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sections;

@property(nonatomic,strong)UIView *contentView;
@property (nonatomic, strong) UIImageView *flagIv;
@property (nonatomic, strong) NSMutableArray* leftLabs;
@property (nonatomic, copy) NSString* model;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) CGFloat contentViewHeigth;

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@end

@implementation RewResultPopUpView

- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self setupContent];
    }
    
    return self;
}

- (void)setupContent {
    _leftLabs = [NSMutableArray array];
    
    _funcBtns = [NSMutableArray array];
    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    
    
    self.backgroundColor = COLOR_HEX(0x000000, .8);
    self.userInteractionEnabled = YES;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
//    tap.delegate = self;
//    [self addGestureRecognizer:tap];
    _contentViewHeigth = XHHTuanNumViewHight;
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
        _contentView.layer.cornerRadius = 6;
        _contentView.layer.masksToBounds = YES;
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = HEXCOLOR(0xffffff);
        [self addSubview:_contentView];
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(_contentView.width -  90, 0, 90, 47);
        closeBtn.titleLabel.font = kFontSize(15);
        [closeBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [closeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
//        [_contentView addSubview:closeBtn];
        
        // 左上角关闭按钮
        UIButton *bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = CGRectMake(0, 0, _contentView.width, 130);
        bgBtn.titleLabel.font = kFontSize(17);
        [bgBtn setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        [bgBtn setTitle:@"" forState:UIControlStateNormal];
        [bgBtn setImage:kIMG(@"M_hbicHead") forState:0];
        bgBtn.contentMode = UIViewContentModeScaleToFill;
        bgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        bgBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        bgBtn.imageView.contentMode = UIViewContentModeScaleToFill;
//        bgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        bgBtn.tag = 8;
        [_contentView addSubview:bgBtn];
        
        UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saftBtn.backgroundColor = kClearColor;
        saftBtn.frame = CGRectMake(0, 13, _contentView.width, 100);
        saftBtn.titleLabel.font = kFontSize(17);
        [saftBtn setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        [saftBtn setTitle:@"" forState:UIControlStateNormal];
        saftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        saftBtn.tag = 9;
        [_contentView addSubview:saftBtn];
//        _flagIv = [[UIImageView alloc]init];
//        [self.contentView addSubview:_flagIv];
////        _flagIv.backgroundColor = HEXCOLOR(0xe8e9ed);
//
//        [_flagIv mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(@0);
//            make.trailing.equalTo(@0);
//            make.top.offset(47);
//            make.bottom.equalTo(_contentView.mas_bottom).offset(-104);
//        }];
        [self layoutAccountPublic];
        
        
    }
    
}

-(void)layoutAccountPublic{
    [self.contentView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-140);
        make.top.equalTo(self.contentView).offset(140);
        make.left.equalTo(self.contentView).offset(0);
        make.center.equalTo(self.contentView);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag =  10;
    button.adjustsImageWhenHighlighted = NO;
//    button.titleLabel.font = kFontSize(12);
//  button.layer.borderWidth = 0;
//    [button setTitleColor:YBGeneralColor.themeColor forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [button setTitle:@"" forState:0];
//    button.backgroundColor = YBGeneralColor.themeColor;
    [self.contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-110);
        make.left.equalTo(self.contentView).offset(14);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@130);
        make.height.equalTo(@40);
    }];
    
    UIButton *reButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reButton.hidden = YES;
    reButton.tag =  2+100;
    reButton.adjustsImageWhenHighlighted = NO;
    reButton.titleLabel.font = kFontSize(15);
//  button.layer.borderWidth = 0;
    [reButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    reButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    reButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [reButton setTitle:@"打赏" forState:0];
    reButton.backgroundColor = YBGeneralColor.themeColor;
    [self.contentView addSubview:reButton];
    [reButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-60);
        make.centerX.equalTo(self.contentView);
        make.width.equalTo(@130);
        make.height.equalTo(@40);
    }];
    reButton.layer.masksToBounds = YES;
    reButton.layer.cornerRadius = 40/2;
    [reButton addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray* subtitleArray =@[
    @{@"继续打赏":[UIImage new]},
    @{@"不了，回家":[UIImage new]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i+100;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 40/2;
//        button.layer.borderWidth = 0;
        [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
//        [button setBackgroundImage:dic.allValues[0] forState:UIControlStateNormal];
//        button.backgroundColor = YBGeneralColor.themeColor;
//        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20];
        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [_funcBtns addObject:button];
    }
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:13 tailSpacing:13];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.height.equalTo(@40);
    }];
    UIButton* btn0 = _funcBtns[0];
    btn0.titleLabel.font = kFontSize(12);
    btn0.backgroundColor = YBGeneralColor.themeColor;
    [btn0 setTitleColor:HEXCOLOR(0xffffff) forState:0];

    UIButton* btn1 = _funcBtns[1];
    btn1.titleLabel.font = kFontSize(12);
    btn1.backgroundColor = HEXCOLOR(0xD9E3E6);
    [btn1 setTitleColor:kBlackColor forState:0];
}
#pragma mark - <UITableViewDataSource, UITableViewDelegate>
#pragma mark - Sectons
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections.count;
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [(_sections[section]) count];
}

#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RewResultPopUpCell *cell = [RewResultPopUpCell cellWith:tableView];
    [cell richElementsInCellWithModel:(_sections[indexPath.section])[indexPath.row] WithIndexRow:indexPath.row];
//    [cell actionBlock:^(id data) {
//        
//    }];
    return cell;
}

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RewResultPopUpCell cellHeightWithModel:(_sections[indexPath.section])[indexPath.row]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//     (_sections[indexPath.section])[indexPath.row];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView YBGeneral_configuration];
        _tableView.backgroundColor = UIColor.whiteColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)funAdsButtonClickItem:(UIButton*)btn{
    if (btn.tag -100 == 1) {
        [self disMissView];
    }else if (btn.tag -100 == 2){
        if (self.text0.length == 0||
            self.text1.length == 0) {
            [YKToastView showToastText:@"请填齐信息"];
            return;
        }
        [self disMissView];
        NSDictionary* posDic = @{
            @"content":[NSString stringWithFormat:@"%@",self.text1],
                              
            @"money":[NSString stringWithFormat:@"%@",self.text0],
            
            @"bbs_id":[NSString stringWithFormat:@"%@",self.configModel.ID],
                              
            @"to_user_id":[NSString stringWithFormat:@"%@",self.configModel.uid],
        };
        
        
        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType64] andType:All andWith:posDic success:^(NSDictionary *dic) {
            HomeModel* model = [HomeModel mj_objectWithKeyValues:dic];
            if ([NSString getDataSuccessed:dic]) {
            
            }
            [YKToastView showToastText:[NSString stringWithFormat:@"%@",model.msg]];
        } error:^(NSError *error) {
             NSLog(@".......servicerErr");
        }];
    }else if (btn.tag -100 == 0){
        [self disMissView];
        
    }
    
    if (self.block) {
        self.block(@(btn.tag-100));
    }
    
//    [self disMissView];
}



- (void)richElementsInViewWithModel:(NSArray*)model WithConfig:(DynamicsModel*)configModel WithTModel:(NSInteger)tModel{
    if (!model&&model.count!=0) {
        return;
    }
//    self.model = model;
    
    [self.sections addObjectsFromArray:model];
    [self.tableView reloadData];
//    self.configModel = configModel;
    UIButton* titBtn = [_contentView viewWithTag:9];
    [titBtn setTitle:@"打赏完成" forState:UIControlStateNormal];
//    NSString* title = [NSString stringWithFormat:@"mine_avator%li",[configModel.avatar integerValue]];
//    [titBtn setImage:[UIImage imageNamed:title] forState:0];
//    [titBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
//
    UIButton* amouBtn = [_contentView viewWithTag:10];
    
    [amouBtn setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@.",@"🙏"] stringColor:YBGeneralColor.themeColor stringFont:[UIFont boldSystemFontOfSize:10] subString:[NSString stringWithFormat:@"%@",@"ok"] subStringColor:HEXCOLOR(0x000000) subStringFont:kFontSize(11) paragraphStyle:NSTextAlignmentCenter] forState:0];
    
//    UIButton* btn0 = _funcBtns[0];
//    btn0.titleLabel.font = kFontSize(12);
//    btn0.backgroundColor = kClearColor;
//    [btn0 setTitle:@"在线充值" forState:0];
//    [btn0 setTitleColor:YBGeneralColor.themeColor forState:0];
//
//    UIButton* btn1 = _funcBtns[1];
//    btn1.titleLabel.font = kFontSize(12);
//    btn1.backgroundColor = kClearColor;
//    [btn1 setTitle:@"取消" forState:0];
//    [btn1 setTitleColor:kBlackColor forState:0];
    
//    if (configModel.anActionType == BannerTypeForce&&
//        [YBSystemTool compareWithVersion1:configModel.version] == 1) {
//        UIButton* btn0 = _funcBtns[0];
//        btn0.hidden = true;
//
//        UIButton* btn1 = _funcBtns[1];
//        [btn1 mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.contentView);
//        }];
//    }
}

- (void)showInApplicationKeyWindow{
    [self showInView:[[UIApplication sharedApplication] delegate].window];
    
    //    [popupView showInView:self.view];
    //
    //    [popupView showInView:[UIApplication sharedApplication].keyWindow];
    //
    //    [[UIApplication sharedApplication].keyWindow addSubview:popupView];
}

- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, MAINSCREEN_HEIGHT, XHHTuanNumViewWidth, _contentViewHeigth)];
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.alpha = 1.0;
        
        [weakSelf.contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - weakSelf.contentViewHeigth)/2,XHHTuanNumViewWidth,weakSelf.contentViewHeigth)];
        
    } completion:nil];
}

- (void)changeContentViewFrame:(CGRect)frame{
    __weak __typeof(self)weakSelf = self;
    [_contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         weakSelf.alpha = 1.0;
                         
                         [weakSelf.contentView setFrame:frame];
                     }
                     completion:^(BOOL finished){
                         
//                         [weakSelf removeFromSuperview];
//                         [weakSelf.contentView removeFromSuperview];
                         
                     }];
}
//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    WS(weakSelf);
    [_contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         weakSelf.alpha = 0.0;
                         
                         [weakSelf.contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, MAINSCREEN_HEIGHT, XHHTuanNumViewWidth, weakSelf.contentViewHeigth)];
                     }
                     completion:^(BOOL finished){
                         
                         [weakSelf removeFromSuperview];
                         [weakSelf.contentView removeFromSuperview];
                         
                     }];
    
}

@end

