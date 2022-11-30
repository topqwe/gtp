
#import "PreviewPopUpView.h"
#define XHHTuanNumViewHight 182
#define XHHTuanNumViewWidth 306

@interface PreviewPopUpCell : UITableViewCell
- (void)actionBlock:(DataBlock)block;
+ (CGFloat)cellHeightWithModel:(id)model;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(id)model;
@end

@interface PreviewPopUpCell ()
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIButton *fanBtn;
@end

@implementation PreviewPopUpCell
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = kClearColor;
        self.contentView.backgroundColor = kClearColor;
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
        make.left.equalTo(self.contentView.mas_left).offset(13);
//        make.height.equalTo(@50);
        make.centerX.equalTo(self.contentView);
//        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
//    _titleBtn.layer.masksToBounds = true;
//    _titleBtn.layer.cornerRadius = 8;
    _titleBtn.userInteractionEnabled = NO;
   
    [_titleBtn setTitleColor:HEXCOLOR(0xffffff) forState:0];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _titleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
}

+(instancetype)cellWith:(UITableView*)tabelView{
    PreviewPopUpCell *cell = (PreviewPopUpCell *)[tabelView dequeueReusableCellWithIdentifier:@"PreviewPopUpCell"];
    if (!cell) {
        cell = [[PreviewPopUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PreviewPopUpCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(id)model{
//    return [NSString getContentHeightWithParagraphStyleLineSpacing:0 fontWithString:model fontOfSize:15 boundingRectWithWidth:MAINSCREEN_WIDTH-2*13]+5;
    return 40;
}

- (void)richElementsInCellWithModel:(NSString*)model{
    [_titleBtn setTitle:[NSString stringWithFormat:@"%@",model] forState:0];
    _titleBtn.titleLabel.numberOfLines = 0;
    _titleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleBtn.backgroundColor = [UIColor clearColor];
    [_titleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo([[self class]cellHeightWithModel:model]);
    }];
//    [self.contentView layoutIfNeeded];
}

@end

@interface PreviewPopUpView()<UIGestureRecognizerDelegate,UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) UIView *superV;
@property(nonatomic,strong)UIView *contentView;
@property (nonatomic, strong) UIImageView *flagIv;
@property (nonatomic, strong) NSMutableArray* leftLabs;
@property (nonatomic, copy) NSString* model;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) CGFloat contentViewHeigth;

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@property (nonatomic, strong) NSMutableArray *topBtns;
@end

@implementation PreviewPopUpView

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
    
    
    self.backgroundColor = COLOR_HEX(0x4A4A4A, .8);
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
        _contentView.backgroundColor = HEXCOLOR(0x646464);
        [self addSubview:_contentView];
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.tag = 100;
        closeBtn.frame = CGRectMake(_contentView.width -  70, 0, 90, 47);
        closeBtn.titleLabel.font = kFontSize(15);
//        [closeBtn setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
//        [closeBtn setTitle:@"取消" forState:UIControlStateNormal];
        [closeBtn setImage:kIMG(@"M_X_W") forState:0];
        [closeBtn addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
//        [closeBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
        [_contentView addSubview:closeBtn];
        
        // 左上角关闭按钮
        UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saftBtn.frame = CGRectMake(0, 0, _contentView.width, 47);
        saftBtn.titleLabel.font = kFontSize(17);
        [saftBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
        [saftBtn setTitle:@"" forState:UIControlStateNormal];
        saftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        saftBtn.tag = 9;
//        [_contentView addSubview:saftBtn];
        
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
        make.bottom.equalTo(self.contentView).offset(-100);
        make.top.equalTo(self.contentView).offset(40);
        make.left.equalTo(self.contentView).offset(0);
        make.center.equalTo(self.contentView);
    }];
    
    [self centerBtns];
    
    NSArray* subtitleArray =@[
    @{@"取消":[UIImage imageNamed:@"mine_vip"]},
    @{@"前往":[UIImage imageNamed:@"mine_purse"]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i+100;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        
        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [_funcBtns addObject:button];
    }
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:15 tailSpacing:15];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-30);
        make.height.equalTo(@15);
    }];
    
}
- (void)centerBtns{
    
    
    _topBtns = [NSMutableArray array];
    NSArray* subtitleArray =@[
    @{@"长视频免费":[UIImage imageWithColor:HEXCOLOR(0x21c244) rect:CGRectMake(0, 0, 16, 16)]},
    @{@"小视频免费":[UIImage imageWithColor:HEXCOLOR(0xe22323) rect:CGRectMake(0, 0, 16, 16)]}
    ,@{@"社区同城约炮":[UIImage imageWithColor:HEXCOLOR(0xf59b22) rect:CGRectMake(0, 0, 16, 16)]}
    ,@{@"直播免费":[UIImage imageWithColor:HEXCOLOR(0xf59b22) rect:CGRectMake(0, 0, 16, 16)]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i+100;
        button.userInteractionEnabled = NO;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(11);
//            button.layer.masksToBounds = YES;
//            button.layer.cornerRadius = 6;
//            button.layer.borderWidth = 1;
        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
//        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"m_poplim%d",i+1]] forState:0];
        [button setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        //        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [_topBtns addObject:button];
    }
    [_topBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [_topBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-45);
        make.height.equalTo(@80);
    }];
    [self.contentView layoutIfNeeded];
    for (int i = 0; i < _topBtns.count; i++) {
        UIButton* button = _topBtns[i];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:10];
    }
    
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
    PreviewPopUpCell *cell = [PreviewPopUpCell cellWith:tableView];
    [cell richElementsInCellWithModel:(_sections[indexPath.section])[indexPath.row]];
    [cell actionBlock:^(id data) {
//        if (self.block) {
//            self.block(data);
//        }
//        [self disMissView];
    }];
    return cell;
}

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [PreviewPopUpCell cellHeightWithModel:(_sections[indexPath.section])[indexPath.row]];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//     (_sections[indexPath.section])[indexPath.row];
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView YBGeneral_configuration];
        _tableView.backgroundColor = HEXCOLOR(0x646464);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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
    if (btn.tag -100 == 0) {
        [self disMissView];
    }else{
        
    }
    if (self.block) {
        self.block(@(btn.tag-100));
    }
    
//    [self disMissView];
}

- (void)richElementsInViewWithModel:(NSArray*)model withItem:(HomeItem*)item{
    if (!model&&model.count!=0) {
        return;
    }
//    self.model = model;
    
    [self.sections addObjectsFromArray:model];
    [self.tableView reloadData];
    
//    UIButton* titBtn = [_contentView viewWithTag:9];
//    [titBtn setTitle:@"公告" forState:UIControlStateNormal];
    UIButton* btn0 = _funcBtns[0];
    
    UIButton* btn1 = _funcBtns[1];
    
    
    btn1.layer.masksToBounds = YES;
    btn1.layer.cornerRadius = 35/2;
//        button.layer.borderWidth = 0;
    [btn1 setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [btn1 setTitle:[item getLevLimitButTitle] forState:UIControlStateNormal];
    btn1.backgroundColor = YBGeneralColor.themeColor;
    
    [btn0 setTitleColor:YBGeneralColor.themeColor forState:UIControlStateNormal];
    [btn0 setTitle:@"重新播放" forState:UIControlStateNormal];
    [btn0 setImage:kIMG(@"M_O") forState:UIControlStateNormal];
    [btn0 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    btn0.backgroundColor = kClearColor;
    
    btn0.hidden = true;
    
    [btn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(35);
    }];
    
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
    self.superV = view;
    self.frame =  view.bounds;
//    [_contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, view.bounds.size.height, XHHTuanNumViewWidth, _contentViewHeigth)];
    self.alpha = 1.0;
    [self.contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (view.bounds.size.height - self.contentViewHeigth)/2,XHHTuanNumViewWidth,self.contentViewHeigth)];
    return;
    WS(weakSelf);
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.alpha = 1.0;
        
        [weakSelf.contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (view.bounds.size.height - weakSelf.contentViewHeigth)/2,XHHTuanNumViewWidth,weakSelf.contentViewHeigth)];
        
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
    
    [self removeFromSuperview];
    [self.contentView removeFromSuperview];
    return;
    WS(weakSelf);
    if (self.superV) {
//        self.frame =  CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (self.superV.bounds.size.height - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth);
//        [_contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (self.superV.bounds.size.height - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
        [UIView animateWithDuration:0.1f
                         animations:^{
                            weakSelf.alpha = 0.0;
//            [weakSelf  setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, self.superV.bounds.size.height, XHHTuanNumViewWidth, weakSelf.contentViewHeigth)];
                             [weakSelf.contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, self.superV.bounds.size.height, XHHTuanNumViewWidth, weakSelf.contentViewHeigth)];
                         }
                         completion:^(BOOL finished){
                             
                             [weakSelf removeFromSuperview];
                             [weakSelf.contentView removeFromSuperview];
                             
                         }];
    }else{
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
    
}

@end

