//
//  DraggableCVC.m


#import "DraggableCVC.h"
#import "DraggableCView.h"
#import "DraggableCVModel.h"
#import "CenterSpinView.h"
@interface DraggableCVC ()
@property (nonatomic, strong) NSMutableArray *funcBtns;
@property (nonatomic, strong) NSMutableArray *verticalFuncBtns;
@property (nonatomic, strong) NSDictionary *dicXY;
@property (nonatomic, strong) DraggableCView* cv;
@property (nonatomic, strong) CenterSpinView* csv;
@end

@implementation DraggableCVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    DraggableCVC *vc = [[DraggableCVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    _funcBtns = [NSMutableArray arrayWithCapacity:2];
    _verticalFuncBtns = [NSMutableArray arrayWithCapacity:2];
    self.dicXY = @{@(2):@(3)};
    
    UIButton *naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    naviBtn.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, [YBFrameTool safeAdjustNavigationBarHeight]);
    naviBtn.titleLabel.font = kFontSize(17);
    [naviBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    naviBtn.backgroundColor = YBGeneralColor.themeColor;
    [naviBtn setTitle:[NSString currentDataStringWithFormatString:[NSString ymSeparatedBySlashFormatString]] forState:UIControlStateNormal];
    naviBtn.tag = 9;
    naviBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    naviBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [self.view addSubview:naviBtn];
    naviBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 15, 0);
    
    NSArray* subtitleArray =@[
        @{@"难度系数":@""},
        @{@"重新开始":@""}
        ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
//                button.layer.masksToBounds = YES;
//                button.layer.cornerRadius = 6;
//                button.layer.borderWidth = 1;
        
        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        //        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [_funcBtns addObject:button];
//            [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:82 leadSpacing:13 tailSpacing:13];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(naviBtn.mas_bottom).offset(0);
        make.height.equalTo(@30);
    }];

    UIButton* fbtn1 = _funcBtns[1];
    fbtn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [fbtn1 setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [fbtn1 addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray* vsubtitleArray =@[
    @{@" 5* 8 ":@"checkbox-checked"},
    @{@" 6* 10 ":@"checkbox"},
    @{@" 4* 4 ":@"checkbox"},
    @{@" 8* 8 ":@"checkbox"},
    ];
    for (int i = 0; i < vsubtitleArray.count; i++) {
        NSDictionary* dic = vsubtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
        
        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:dic.allValues[0]] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];
        [_verticalFuncBtns addObject:button];
    }
    
    UIButton* fbtn0 = _funcBtns[0];
//    [self.view layoutIfNeeded];
    UIButton* vbtn0 = _verticalFuncBtns[0];
    vbtn0.selected = YES;
    [_verticalFuncBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:0];
    //MAINSCREEN_HEIGHT-[YBFrameTool safeAdjustNavigationBarHeight]-60
    [_verticalFuncBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(fbtn0.mas_bottom).offset(0);
        make.height.equalTo(@30);
//        make.width.equalTo(@90);
    }];
    
    [self richElementsInViewWithModel:nil];
    
    [self layoutCV];
}

- (void)layoutCV{
    if (self.cv) {
        [self.cv removeFromSuperview];
    }
    self.cv = [[DraggableCView alloc]init];
        [self.view addSubview:self.cv];
        self.cv.alpha = 1.0;
        self.cv.userInteractionEnabled = true;
        [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo([YBFrameTool safeAdjustNavigationBarHeight]+60);//60
         
                make.left.right.equalTo(self.view).offset(0);
                make.height.mas_equalTo([DraggableCView cellHeightWithModel]);
            }];
//        [self.accountTagView showInView:self.view];
        [self.cv actionBlock:^(NSDictionary* data) {
    //        [self.accountTagView disMissView];
            if ([UserInfoManager GetNSUserDefaults].recordedDate){
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"恭喜您🌹" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
                NSString* message = [NSString stringWithFormat:@"用了%@通关",[NSString currentDateComparePastDate:[UserInfoManager GetNSUserDefaults].recordedDate]];
                    
                [alert addAction:[UIAlertAction actionWithTitle:@"再来一局" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    [self layoutCV];
                }]];
                
                alert.message = message;
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        }];
    
    [self richElementsInCVWithModel:nil];
    if (self.csv) {
        [self.csv removeFromSuperview];
    }
}

- (void)layoutCentreSpinView{
    
    if (self.csv) {
        [self.csv removeFromSuperview];
    }
    self.csv = [[CenterSpinView alloc]init];
    [self.view addSubview:self.csv];
    self.csv.alpha = 1.0;
    self.csv.userInteractionEnabled = true;
    [self.csv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([YBFrameTool safeAdjustNavigationBarHeight]+60+20);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo([CenterSpinView cellHeightWithModel]);//init remeber right height or UI click expired
            }];
    
    [self richElementsInCSVWithModel:nil];
}

- (void)richElementsInViewWithModel:(id)model{
    UIButton* titleBtn = [self.view viewWithTag:9];
    [titleBtn setTitle:@"数排" forState:UIControlStateNormal];
}

- (void)richElementsInCVWithModel:(id)model{
     
    NSInteger x = [self.dicXY.allKeys[0] intValue];
    NSInteger y = [self.dicXY.allValues[0] intValue];
    [self.cv richElementsInCellWithModel:[[DraggableCVModel new]getCollectionDatasByX:x byY:y]];
}

- (void)richElementsInCSVWithModel:(id)model{
    NSInteger x = [self.dicXY.allKeys[0] intValue];
    NSInteger y = [self.dicXY.allValues[0] intValue];
    [self.csv richElementsInCellWithModel:[[DraggableCVModel new]getRotateDatasByX:x-1 byY:y-1]];
    [self.csv actionBlock:^(NSDictionary* data) {
//        NSInteger i = [data[kSubTit]intValue];
        [self.cv rotateModel:data];
        
    }];
}
- (void)funAdsButtonClickItem:(UIButton*)btn{
    UIButton* button = btn ;
    NSString* btnTit = btn.selected?button.titleLabel.text:@"";
    button.selected = !button.selected;
    if (button.selected) {
        
        for (UIButton *btn in self.verticalFuncBtns) {
            btn.selected = NO;
            [btn setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
            
            if (btn.tag == button.tag) {
                btn.selected = YES;
                [btn setImage:[UIImage imageNamed:@"checkbox-checked"] forState:UIControlStateNormal];
            }
        }

        btnTit = button.titleLabel.text;
        
    } else {
        
        
    }
    
    if (btn.tag == EnumActionTag0) {
        self.dicXY = @{@(5):@(8)};
        [self layoutCV];
    }else if (btn.tag == EnumActionTag1){
         self.dicXY = @{@(6):@(10)};
        [self layoutCV];
    }
    
    
    if (btn.tag == EnumActionTag2) {
        self.dicXY = @{@(4):@(4)};
        [self layoutCV];
        [self layoutCentreSpinView];
    }else if (btn.tag == EnumActionTag3){
         self.dicXY = @{@(8):@(8)};
        [self layoutCV];
        [self layoutCentreSpinView];
    }
    UIButton* fbtn1 = _funcBtns[1];
    fbtn1.tag = btn.tag;
}
@end
