
#import "TurntableView.h"

#define XHHTuanNumViewWidth MAINSCREEN_WIDTH
#define XHHTuanNumViewHight MAINSCREEN_WIDTH * 1323/1125

@interface TurntableView ()<UIGestureRecognizerDelegate,CAAnimationDelegate>
@property(nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong)UIImageView *turntableImgView;
@property (nonatomic,strong)UIButton *startBtn;
@property (nonatomic, assign) CGFloat contentViewHeigth;

@property (nonatomic,strong)NSMutableDictionary *angleDics;
@property (nonatomic,copy) NSArray *turnArr;
@property (nonatomic,strong)NSMutableArray *resultArray;
@property (nonatomic,strong)NSMutableArray *btns;
@property (nonatomic, copy) ActionBlock block;

@end
@implementation TurntableView{
    
    CGFloat startValue;
    CGFloat endValue;
    int resultIndex;
}
- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        [self setupContent];
    }
    
    return self;
}

- (void)clickright{
    if (self.block) {
        self.block(@0);
    }
}

- (void)setupContent {
    self.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT);
    
    self.backgroundColor = COLOR_HEX(0x000000, .6);
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
//        _contentView.backgroundColor = ColorWithHex(0xf3fdff,1);
        [self addSubview:_contentView];
        
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:17];
    //    titleLabel.textColor = [UIColor colorWithRed:246.0 green:160. blue:195 alpha:0];
        titleLabel.textColor = [UIColor colorWithRed:81.0f/255.0  green:81.0f/255.0f blue:81.0/255.0f alpha:1];

        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text =@"百搭";
    //    self.navigationItem.titleView = titleLabel;
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView);
            make.centerX.equalTo(self.contentView);
            make.width.equalTo(@160);
            make.height.equalTo(@40);
            
        }];
        
        UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_back_black"] forState:UIControlStateNormal];
        button.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
        button.tag = 3;
        [button addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left).offset(20);
            make.centerY.equalTo(titleLabel);
            make.right.equalTo(titleLabel.mas_left).offset(5);
            
        }];
        
        
        UIButton *safariButton =  [UIButton buttonWithType:UIButtonTypeCustom];
        [safariButton setTitle:@"" forState:UIControlStateNormal];
        [safariButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [safariButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
        [safariButton setTitleColor:[UIColor colorWithRed:137.0f/255.0  green:137.0f/255.0f blue:137.0/255.0f alpha:1] forState:UIControlStateNormal];
        safariButton.titleLabel.font = [UIFont systemFontOfSize: 12];
        safariButton.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentRight;
    //    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        safariButton.tag = 2;
        [safariButton addTarget:self action:@selector(clickright) forControlEvents:UIControlEventTouchUpInside];
    //    self.navigationItem.rightBarButtonItem = buttonItem;
        [self.contentView addSubview:safariButton];
        [safariButton mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).offset(-20);
            make.centerY.equalTo(titleLabel);
            make.left.equalTo(titleLabel).offset(5);
            
        }];
        
        [self setUpContentViewInSuperView:self.contentView withTopMargin:42];
        
        
    }
}

- (id)initWithFrame:(CGRect)frame InSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin{
    if (self == [super initWithFrame:frame]) {
        [self setUpContentViewInSuperView:superView withTopMargin:topMargin];
        
    }
        
    
    return self;
}


- (void)setUpContentViewInSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin{
    self.resultArray = [NSMutableArray array];
    startValue = 0;
    self.angleDics = [NSMutableDictionary dictionary];
    
    self.bgView = [[UIView alloc]init];
//        bottomView.backgroundColor = kGrayColor;
    self.bgView.userInteractionEnabled = YES;
    [superView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
        make.leading.equalTo(superView).offset(0);
        make.centerX.mas_equalTo(superView);
        make.top.mas_equalTo(topMargin);
        make.bottom.mas_equalTo(superView);
    }];
    
    UIImageView *turntableBgImgView = [[UIImageView alloc]init];
    turntableBgImgView.image = [UIImage imageNamed:@""];
    turntableBgImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.bgView addSubview:turntableBgImgView];
    [turntableBgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);
        
        make.width.height.equalTo(@300);

    }];
    
    self.turntableImgView = [[UIImageView alloc]init];
    self.turntableImgView.image = [UIImage imageNamed:@"turntableImg"];
    self.turntableImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.bgView addSubview:self.turntableImgView];
    [self.turntableImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bgView);

        make.width.height.equalTo(@320);
    }];
    
    
    UIButton *pointImgV = [[UIButton alloc]init];
    [pointImgV setBackgroundImage:[UIImage imageNamed:@"turntablePoint"] forState:0];
    pointImgV.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.bgView addSubview:pointImgV];
    [pointImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.bgView);
        make.top.equalTo(self.turntableImgView.mas_top).offset(-10);
    }];
    
    [self.bgView layoutIfNeeded];
}



- (void)richElementsInViewWithModel:(id)model{
    self.turnArr = model;
    for (int i = 0; i < self.turnArr.count; i++) {
    NSInteger angle = 360/self.turnArr.count;
    NSInteger minBase = 4;
    NSInteger maxBase = angle -4;
    NSDictionary* min =@{
        [NSString stringWithFormat:@"%i",i] : @[
                @{@"min": [NSString stringWithFormat:@"%li",minBase+(i*angle)],
                  @"max":[NSString stringWithFormat:@"%li",maxBase+(i*angle)]
                  
                }
            ]
    };
    [self.angleDics addEntriesFromDictionary:min];
        
    
    WItem *accModel = self.turnArr[i];
        
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(self.turntableImgView.width/2-60, 0, 120, self.turntableImgView.width)];
    [self.turntableImgView addSubview:view];
    
    NSDictionary *radiusDic = [[self.angleDics valueForKey:[NSString stringWithFormat:@"%d",i]] firstObject];
    CGFloat aa = ([radiusDic[@"max"] floatValue] - [radiusDic[ @"min"] floatValue])/2+[radiusDic[@"min"] floatValue];
    view.transform = CGAffineTransformMakeRotation(radians(aa));
    
    UIImageView *ImgV = [[UIImageView alloc]init];
    ImgV.contentMode = UIViewContentModeScaleAspectFit;
    [view addSubview:ImgV];
    
    UILabel *label = [[UILabel alloc]init];
    label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blueColor];
    [view addSubview:label];
        

    NSString *nameStr = [NSString stringWithFormat:@"%@\n(%@)",accModel.title,accModel.subTitle] ;
    label.text = nameStr;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.font = [UIFont systemFontOfSize:6];

    [ImgV sd_setImageWithURL:[NSURL URLWithString:accModel.cover]];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.centerY.equalTo(view).multipliedBy(0.3);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);

    }];
    
    [ImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(view);
        make.width.height.mas_equalTo(30);
        make.top.equalTo(label.mas_bottom);
    }];

    

    }
    self.startBtn = [UIButton buttonWithType:0];
    [self.startBtn addTarget:self action:@selector(startButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.startBtn setTitle:@"开始" forState:0];
    [self.startBtn setTitleColor:kBlackColor forState:0];
    self.startBtn.layer.cornerRadius = 100/2;
    self.startBtn.layer.masksToBounds = true;
    self.startBtn.userInteractionEnabled = YES;
    [self.bgView addSubview:self.startBtn];
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.turntableImgView);
        make.width.height.equalTo(@100);
    }];
    self.startBtn.backgroundColor = UIColor.blueColor;
    
    
    
    

 
}
//角度转弧度
double radians(float degrees) {
    return degrees*M_PI/180;
}
- (void)addButtonClick{
    
}

- (void)startButtonClick{

    [self requestResult];
        
}
- (void)requestResult{
    self.startBtn.userInteractionEnabled = NO;

    [self.resultArray addObject:self.turnArr[2]];

    resultIndex = 0;
    WItem *resultAccModel;
    if (self.resultArray.count > 0) {
        resultAccModel = [self.resultArray lastObject];
        
    }
    for (int i = 0; i < self.turnArr.count; i ++) {
        WItem *accModel = self.turnArr[i];
        
        if ([resultAccModel.argValue isEqualToString:accModel.argValue]) {
            resultIndex = i;
        }
    }
//            resultIndex = arc4random()%8;

    endValue = [self fetchResult];
    CABasicAnimation* rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.delegate = self;
    rotationAnimation.fromValue = @(startValue);
    rotationAnimation.toValue = @(endValue);
    rotationAnimation.duration = 3.0f;
    rotationAnimation.autoreverses = NO;
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeBoth;
    [self.turntableImgView.layer addAnimation:rotationAnimation forKey:@"revItUpAnimation"];

}
- (CGFloat)fetchResult{
    srand((unsigned)time(0));
    float random = 0.0;
    for (NSString *str in [self.angleDics allKeys]) {
        if ([str intValue] == resultIndex) {
            int bb;
            if (resultIndex == 0) {
                bb = arc4random()%2;
            }else{
                bb = 0;
            }
            NSDictionary *content = self.angleDics[str][bb];
            int min = [content[@"min"] intValue];
            int max = [content[@"max"] intValue];
            srand((unsigned)time(0));
            random = rand() % (max - min) +min;
        }
    }
//    return radians(random + 360*5);
    return (M_PI*2 - radians(random)) + M_PI*2*5;

}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.startBtn.userInteractionEnabled = YES;

    startValue = endValue;
    
    if (startValue >= endValue) {
        startValue = startValue - radians(360*10);
    }
    
    if (self.resultArray.count > 0) {
        if (self.block) {
            self.block(self.resultArray.firstObject);
        }
    }
    
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
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
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        
        weakSelf.alpha = 1.0;
        
//        [weakSelf.contentView setFrame:CGRectMake((SCREEN_WIDTH - XHHTuanNumViewWidth)/2, (SCREENHEIGHT - weakSelf.contentViewHeigth)/2,XHHTuanNumViewWidth,weakSelf.contentViewHeigth)];
        [weakSelf.contentView setFrame:CGRectMake(0, MAINSCREEN_HEIGHT - XHHTuanNumViewHight, MAINSCREEN_WIDTH, XHHTuanNumViewHight)];
        
    } completion:nil];
}


- (void)disMissView {
    if (self.startBtn.userInteractionEnabled==NO) {
        return;
    }
    __weak __typeof(self)weakSelf = self;
    [_contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, (MAINSCREEN_HEIGHT - _contentViewHeigth)/2, XHHTuanNumViewWidth, _contentViewHeigth)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         weakSelf.alpha = 0.0;
                         
                         [weakSelf.contentView setFrame:CGRectMake((MAINSCREEN_WIDTH - XHHTuanNumViewWidth)/2, MAINSCREEN_HEIGHT, XHHTuanNumViewWidth, weakSelf.contentViewHeigth)];
                     }
                     completion:^(BOOL finished){
                         
                         [weakSelf removeFromSuperview];
                         [weakSelf.contentView removeFromSuperview];
                        if (self.block) {
                            self.block(@0);
                        }
        
                     }];
    
}

@end
