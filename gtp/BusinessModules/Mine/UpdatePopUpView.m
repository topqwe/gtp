
#import "UpdatePopUpView.h"
#define XHHTuanNumViewHight 382
#define XHHTuanNumViewWidth 306

@interface UpdatePopUpCell : UITableViewCell
- (void)actionBlock:(DataBlock)block;
+ (CGFloat)cellHeightWithModel:(id)model;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(id)model;
@end

@interface UpdatePopUpCell ()
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) UIButton *titleBtn;
@property (nonatomic, strong) UIButton *fanBtn;
@end

@implementation UpdatePopUpCell
- (void)actionBlock:(ActionBlock)block
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

- (void)refreshTopic:(UIButton*)sender {
    if (self.block) {
        self.block(@(sender.tag));
    }

}
- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    _titleBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.titleBtn];
    _titleBtn.tag = 100;
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
//    _titleBtn.userInteractionEnabled = NO;
    _titleBtn.backgroundColor = [UIColor clearColor];
//    [_titleBtn setTitleColor:HEXCOLOR(0x8FAEB7) forState:0];
//    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    _titleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _titleBtn.titleLabel.numberOfLines = 0;
    _titleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_titleBtn addTarget:self action:@selector(refreshTopic:) forControlEvents:UIControlEventTouchUpInside];
}

+(instancetype)cellWith:(UITableView*)tabelView{
    UpdatePopUpCell *cell = (UpdatePopUpCell *)[tabelView dequeueReusableCellWithIdentifier:@"UpdatePopUpCell"];
    if (!cell) {
        cell = [[UpdatePopUpCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UpdatePopUpCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(id)model{
//    return [NSString getContentHeightWithParagraphStyleLineSpacing:0 fontWithString:model fontOfSize:15 boundingRectWithWidth:MAINSCREEN_WIDTH-2*13]+5;
    return 40;
}

- (void)richElementsInCellWithModel:(NSArray*)model{
//    [_titleBtn setTitle:[NSString stringWithFormat:@"%@",model] forState:0];
    [_titleBtn setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@",model[0]] stringColor:YBGeneralColor.themeColor stringFont:[UIFont boldSystemFontOfSize:18] subString:[NSString stringWithFormat:@"%@",model[1]] subStringColor:HEXCOLOR(0x8FAEB7) subStringFont:kFontSize(15) paragraphStyle:NSTextAlignmentLeft] forState:UIControlStateNormal];
    
    [_titleBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo([[self class]cellHeightWithModel:model]);
    }];
//    [self.contentView layoutIfNeeded];
}

@end

@interface UpdatePopUpView()<UIGestureRecognizerDelegate,UITableViewDelegate, UITableViewDataSource>
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

@implementation UpdatePopUpView

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
        UIButton *saftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saftBtn.frame = CGRectMake(0, 0, _contentView.width, 47);
        saftBtn.titleLabel.font = kFontSize(17);
        [saftBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
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
        make.bottom.equalTo(self.contentView).offset(-60);
        make.top.equalTo(self.contentView).offset(50);
        make.left.equalTo(self.contentView).offset(0);
        make.center.equalTo(self.contentView);
    }];
    
    NSArray* subtitleArray =@[
    @{@"取消":[UIImage imageNamed:@"min"]},
    @{@"ok":[UIImage imageNamed:@"min2"]}
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
        button.backgroundColor = YBGeneralColor.themeColor;
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
    
//    UIButton* btn0  = [_contentView viewWithTag:0+100];
//    [btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
//        make.width.equalTo(@100);
//        make.height.equalTo(@40);
//        make.centerX.equalTo(self.contentView);
//    }];
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
    UpdatePopUpCell *cell = [UpdatePopUpCell cellWith:tableView];
    [cell richElementsInCellWithModel:(_sections[indexPath.section])[indexPath.row]];
    [cell actionBlock:^(id data) {
        if (self.block) {
            self.block(data);
        }
        [self disMissView];
    }];
    return cell;
}

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [UpdatePopUpCell cellHeightWithModel:(_sections[indexPath.section])[indexPath.row]];
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
        [self disMissView];
    }
    if (self.block) {
        self.block(@(btn.tag-100));
    }
    
//    [self disMissView];
}

- (void)richElementsInViewWithModel:(NSDictionary*)dic{
    NSArray* model = dic.allValues[0];
    if (!model&&model.count!=0) {
        return;
    }
//    self.model = model;
    
    [self.sections addObjectsFromArray:model];
    [self.tableView reloadData];
    
    UIButton* titBtn = [_contentView viewWithTag:9];
    [titBtn setTitle:[NSString stringWithFormat:@"%@",dic.allKeys[0]] forState:UIControlStateNormal];
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

