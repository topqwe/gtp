//
//  PieStatedView.m

#import "PieStatedView.h"
@interface PieStatedView()<PieViewDelegate>
@property (nonatomic,strong)UIButton *desview;
@property (nonatomic,strong)PieView *pieview;
@property (nonatomic,copy)NSArray *pieAry;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@end
@implementation PieStatedView
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        [self addSubview:self.pieview];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame withModels:(NSArray <PieModel*>*)ary{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.pieAry = [NSArray arrayWithArray:ary];
    
        [self stepView];
        
    }
    return self;
}
- (void)richEleInView:(id)model{
   self.pieAry = model;
   [self.pieview reloadWithAry:model];
   if (_funcBtns&&_funcBtns.count>0) {
        for (UIView* view in self.funcBtns) {
            [view removeAllSubViews];
        }
    }
    _funcBtns = [NSMutableArray array];
    [self stepView];
}

- (void)stepView{
    for (int i = 0; i < self.pieAry.count; i++) {
        PieModel *model = self.pieAry[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(10);
        button.layer.masksToBounds = YES;
        button.layer.cornerRadius = 2;
//            button.layer.borderWidth = 1;
        
        [button setTitle:model.title forState:UIControlStateNormal];
        [button setImage:[UIImage imageWithColor:model.color rect:CGRectMake(0, 0, 15, 15)] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        [button addTarget:self action:@selector(didSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        [_funcBtns addObject:button];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    }
    if (_funcBtns.count > 1) {
        [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:10 tailSpacing:10];
        
        [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).offset(-20);
            make.height.equalTo(@15);
        }];
    }else if (_funcBtns.count == 1){
        UIButton* btn0 = _funcBtns[0];
        [btn0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.bottom.equalTo(self.mas_bottom).offset(-20);
            make.height.equalTo(@15);
        }];
    }
    
//        UIButton* btn0 = _funcBtns[0];
    if (_desview) {
        [_desview removeFromSuperview];
    }
    _desview = [[UIButton alloc]initWithFrame:CGRectMake(13,self.frame.size.height, self.frame.size.width-13*2, -15)];
    _desview.backgroundColor = [UIColor grayColor];
    _desview.titleLabel.font = kFontSize(14);
    _desview.layer.cornerRadius = 5;
    _desview.transform = CGAffineTransformMakeTranslation(0, _desview.frame.size.height);
    [_desview setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:_desview];
    [_desview addTarget:self action:@selector(removeDesview) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
//    b.frame =CGRectMake(0, 0, 100, 60);
//    b.hidden = true;
//    [b setTitle:@"重置" forState:UIControlStateNormal];
//    [b setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [b addTarget:self action:@selector(animationadd) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:b];
    
}

- (void)animationadd{
    [self.pieview reloadWithAry:self.pieAry];
    [self removeDesview];
}

#pragma mark - action

- (void)didSelect:(UIButton *)sender{
    
    //选中
    [self.pieview selectAtIndet:sender.tag];
//    [self.pieview selectAtModel:self.pieAry[sender.tag]];
}

#pragma mark - PieViewDelegate
- (void)pie:(PieView *)pieview didSelectedAtIndex:(NSInteger)index{
    
    PieModel *model = [self.pieAry objectAtIndex:index];
    [_desview setTitle:[NSString stringWithFormat:@"%@:%@ %.2f🐶 占%.2f%%",model.title,model.descript,model.count,model.percent*100] forState:UIControlStateNormal];
    
    [self addDesView];
}


- (void)addDesView{
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.desview.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {

    }];
}

- (void)removeDesview{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.desview.transform = CGAffineTransformTranslate(self.desview.transform, 0, 0);//-5
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.desview.transform = CGAffineTransformTranslate(self.desview.transform,0, self.desview.frame.size.height);
        }completion:nil];
    }];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//
//    if (CGRectContainsPoint(_desview.frame, point)) {
//        [self removeDesview];
//    }
//}


#pragma mark - lazyload
- (PieView *)pieview{
    if (!_pieview) {
        CGFloat width = IS_iPhoneX?158:128;
        _pieview = [[PieView alloc]initWithFrame:CGRectMake(self.frame.size.width/2-width/2, 5, width, width)];
        _pieview.delegete = self;
    }
    return _pieview;
}
#pragma mark - CATextLayer
- (void)add1{
    
    NSString *str = @"空间看了好几块";
    CGSize size = [str boundingRectWithSize:CGSizeMake(400, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30.0]} context:nil].size;
    
    CATextLayer *lary = [CATextLayer layer];
    lary.string = @"空间看了好几块";
    lary.bounds = CGRectMake(0, 0, size.width, size.height);
    //    lary.font = (__bridge CFTypeRef)(@"HiraKakuProN-W3");//字体的名字 不是 UIFont
    lary.fontSize = 30.f;//字体的大小
    //    lary.backgroundColor = [UIColor grayColor].CGColor;
    lary.wrapped = YES;//默认为No.  自动换行
    lary.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
    lary.truncationMode = kCATruncationEnd; //超出范围结尾裁剪
    lary.position = CGPointMake(130, 410);//layer在view的位置 适用于跟随摸一个不固定长的的控件后面需要的
    lary.contentsScale = [UIScreen mainScreen].scale;//解决文字模糊 以Retina方式来渲染，防止画出来的文本像素化
    lary.foregroundColor =[UIColor blackColor].CGColor;//字体的颜色 文本颜色
    [self.layer addSublayer:lary];
}
- (void)add2{
    NSString *str = @"空间看了好几块";
    CGSize size = [str boundingRectWithSize:CGSizeMake(400, 100) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:30.0]} context:nil].size;
    
    CATextLayer *lary = [CATextLayer layer];
    lary.string = @"空间看了好几块";
    lary.bounds = CGRectMake(0, 0, size.width, size.height);
    //    lary.font = (__bridge CFTypeRef)(@"HiraKakuProN-W3");//字体的名字 不是 UIFont
    lary.fontSize = 30.f;//字体的大小
    //    lary.backgroundColor = [UIColor grayColor].CGColor;
    lary.wrapped = YES;//默认为No.  自动换行
    lary.alignmentMode = kCAAlignmentCenter;//字体的对齐方式
    lary.truncationMode = kCATruncationEnd; //超出范围结尾裁剪
    lary.position = CGPointMake(130, 410);//layer在view的位置 适用于跟随摸一个不固定长的的控件后面需要的
    lary.contentsScale = [UIScreen mainScreen].scale;//解决文字模糊 以Retina方式来渲染，防止画出来的文本像素化
    lary.foregroundColor =[UIColor orangeColor].CGColor;//字体的颜色 文本颜色
    //    lary.sca
    [self.layer addSublayer:lary];
    
    //shapeLayer 路径
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, lary.frame.size.height/2)];
    [path addLineToPoint:CGPointMake(lary.frame.size.width, lary.frame.size.height/2)];
    
    //shapeLayer 必须有路径
    CAShapeLayer *la = [CAShapeLayer layer];
    la.path = path.CGPath;
    la.strokeColor = [UIColor whiteColor].CGColor;
    la.strokeStart = 0;
    la.strokeEnd = 0.1;
    la.lineWidth = lary.frame.size.height;
    lary.mask = la;
    
    CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    an.duration = 5.0f;
    an.repeatCount = 10;
    an.fromValue = @(0.1);
    an.toValue = @(1);
    [la addAnimation:an forKey:@"sd"];
}

@end
