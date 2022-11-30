//
//  MapPopUpView.m


#import "MapPopUpView.h"
#import "ClockInModel.h"
#define XHHTuanNumViewHight 332
#define XHHTuanNumViewWidth 306
@interface MapPopUpView()<UIGestureRecognizerDelegate>
@property(nonatomic,strong)UIView *contentView;
@property (nonatomic, strong) UIImageView *flagIv;
@property (nonatomic, strong) NSMutableArray* leftLabs;
@property (nonatomic, copy) NSString* model;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, assign) CGFloat contentViewHeigth;

@property (nonatomic, strong) NSMutableArray *btns;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@end

@implementation MapPopUpView

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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    _contentViewHeigth = XHHTuanNumViewHight;
    if (_contentView == nil) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
        _contentView.layer.cornerRadius = 6;
        _contentView.layer.masksToBounds = YES;
        _contentView.userInteractionEnabled = YES;
        _contentView.backgroundColor = HEXCOLOR(0xf3fdff);
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
        
        _flagIv = [[UIImageView alloc]init];
        [self.contentView addSubview:_flagIv];
//        _flagIv.backgroundColor = HEXCOLOR(0xe8e9ed);

        [_flagIv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(@0);
            make.trailing.equalTo(@0);
            make.top.offset(47);
            make.bottom.equalTo(_contentView.mas_bottom).offset(-104);
        }];
        
        [self layoutAccountPublic];
        
    }
}

-(void)layoutAccountPublic{
    
    NSArray* subtitleArray = [[ClockInModel new].getClickInStatusData mutableCopy];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIColor* color = dic[kColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  [dic[kType]intValue];
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(16);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 40;
        button.layer.borderWidth = 1;
        button.layer.borderColor = color.CGColor;
        [button setTitle:dic[kIndexInfo] forState:UIControlStateNormal];
        [button setTitleColor:color forState:UIControlStateNormal];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        [_funcBtns addObject:button];
        //        [_fucBtns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:24 tailSpacing:24];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_contentView.mas_bottom).offset(-12);
        
        make.height.mas_equalTo(@80);
    }];
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)funAdsButtonClickItem:(UIButton*)btn{
    
    
    if (self.block) {
        UserInfoModel *newUserInfoModel = [UserInfoManager GetNSUserDefaults];
            
        NSMutableArray* models = [NSMutableArray arrayWithArray:newUserInfoModel.tagArrs];

        UIButton* titBtn = [_contentView viewWithTag:9];
        NSMutableDictionary* dic0= [NSMutableDictionary dictionary];
        [dic0 addEntriesFromDictionary:@{kType:@(btn.tag)}];
        [dic0 addEntriesFromDictionary:@{kSubTit:self.model}];
        [dic0 addEntriesFromDictionary:@{kTit:titBtn.currentTitle}];
        [dic0 addEntriesFromDictionary:@{kDate:[NSString currentDataStringWithFormatString:[NSString ymdSeparatedByPointFormatString]]}];
        [dic0 addEntriesFromDictionary:@{kColor:btn.currentTitleColor}];

        [models addObject:dic0];

        
        newUserInfoModel.tagArrs = [[[ClockInModel new]setFilteredData:models withSameKey:kSubTit] mutableCopy];

        [UserInfoManager SetNSUserDefaults:newUserInfoModel];
        
        self.block(@(btn.tag));
    }
    [self disMissView];
}

- (void)richElementsInViewWithModel:(NSString*)model{
    if (!model) {
        return;
    }
    self.model = model;
    NSString *countryName = [NSLocale.currentLocale displayNameForKey:NSLocaleCountryCode
    value:model];
    
    UIButton* titBtn = [_contentView viewWithTag:9];
    [titBtn setTitle:countryName forState:UIControlStateNormal];
    
    for (NSString* str in [[ClockInModel new]getFlags]) {
        
        if ([model containsString:str]) {
            [_flagIv setImage:[UIImage imageNamed:str]];
            _flagIv.contentMode =  UIViewContentModeScaleAspectFit;
            [_flagIv setClipsToBounds:YES];
        }
    }
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

