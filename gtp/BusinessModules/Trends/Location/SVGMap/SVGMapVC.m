//
//  SVGMapVC.m
//  TestDemo

#import "SVGMapVC.h"
#import "FSInteractiveMapView.h"
#import "ClockInModel.h"
#import "MapPopUpView.h"
@interface SVGMapVC ()
@property (nonatomic, weak) CAShapeLayer* oldClickedLayer;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@end

@implementation SVGMapVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    SVGMapVC *vc = [[SVGMapVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    FSInteractiveMapView* map = [[FSInteractiveMapView alloc] initWithFrame:CGRectMake(8, [YBFrameTool safeAdjustNavigationBarHeight], self.view.frame.size.width - 16, 300)];
//    NSDictionary* data = @{@"CN" : @12,
//                           @"AU" : @2,
//                           @"US" : @5,
//                           @"RU" : @14,
//                           @"GL" : @5,
//                           @"CA" : @20
//                           };
//
//    [map loadMap:@"world-low" withData:data colorAxis:@[[UIColor blueColor], [UIColor greenColor], [UIColor yellowColor], [UIColor redColor]]];
    
    NSMutableDictionary* dic  = [NSMutableDictionary dictionary];
    [map loadMap:@"world-low" withColors:nil];
    
    NSArray* tags = [UserInfoManager GetNSUserDefaults].tagArrs;
    for (NSDictionary* dic0 in tags) {
        [dic addEntriesFromDictionary:@{dic0[kSubTit]:dic0[kColor]}];
    }
    [map setColors:dic];
    __weak FSInteractiveMapView* weakself = map;
    [map setClickHandler:^(NSString* identifier, CAShapeLayer* layer) {
        
        if(self.oldClickedLayer) {
            self.oldClickedLayer.zPosition = 0;
            self.oldClickedLayer.shadowOpacity = 0;
        }
        
        self.oldClickedLayer = layer;
        
        // We set a simple effect on the layer clicked to highlight it
        layer.zPosition = 10;
        layer.shadowOpacity = 0.5;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowRadius = 5;
        layer.shadowOffset = CGSizeMake(0, 0);
        
        MapPopUpView* popupView = [[MapPopUpView alloc]init];
        [popupView richElementsInViewWithModel:identifier];
        [popupView showInApplicationKeyWindow];
        [popupView actionBlock:^(id data) {
            
        NSArray* tags = [UserInfoManager GetNSUserDefaults].tagArrs;
                for (NSDictionary* dic0 in tags) {
                    NSString* countryTit = dic0[kSubTit];
                    if (countryTit.hash == identifier.hash) {
        
                        [dic addEntriesFromDictionary:@{identifier:dic0[kColor]}];
                        [weakself setColors:dic];
                    }
                }
            
        }];
    }];
    
    [self.view addSubview:map];
    
    _funcBtns = [NSMutableArray array];
    
    NSArray* subtitleArray = [[ClockInModel new].getClickInStatusData mutableCopy];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIColor* color = dic[kColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  [dic[kType]intValue];
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(16);
//        button.layer.masksToBounds = YES;
//        button.layer.cornerRadius = 40;
//        button.layer.borderWidth = 1;
//        button.layer.borderColor = color.CGColor;
        [button setTitle:dic[kIndexInfo] forState:UIControlStateNormal];
        [button setImage:[UIImage imageWithColor:color rect:CGRectMake(0, 0, 12, 12)] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:button];
        [_funcBtns addObject:button];
        [_funcBtns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:12 leadSpacing:(self.view.frame.size.height-3*12-[YBFrameTool safeAdjustNavigationBarHeight] -[YBFrameTool safeAdjustTabBarHeight]) tailSpacing:[YBFrameTool safeAdjustTabBarHeight]];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(12);
        
    }];
}


@end
