//
//  ViewController.m
//  CWCarousel
#import "LevelVC.h"
#import "LevelGridCell.h"
#import "CWCarousel.h"
#import "CWPageControl.h"
#import "MineVM.h"
#import "BottomListPopUpView.h"
#import "MyShareVC.h"
#import "WebViewController.h"
#define kViewTag 666
#define kCount 0

@interface LevelVC ()<CWCarouselDatasource, CWCarouselDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) NSString   *orderId;
@property (nonatomic, strong) CWCarousel *carousel;
@property (nonatomic, strong) UIImageView *animationView;
@property (nonatomic, assign) BOOL openCustomPageControl;

@property (nonatomic, strong) MineVM *vm;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView * baseView;
@property (nonatomic, strong) NSMutableArray * dataSource;
/// 数据源
@property (nonatomic, strong) NSArray   *dataArr;
@property (nonatomic, copy) NSArray   *methodsArr;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, strong) id selectedItem;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) UIButton *ficon;
@property (nonatomic, assign) NSInteger timeCount;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CFAbsoluteTime start;  //刷新数据时的时间

@property (nonatomic, copy) TwoDataBlock timeBlock;
@end

@implementation LevelVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    LevelVC *vc = [[LevelVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)dealloc {
    [self distoryTimer];
    NSLog(@"%s", __func__);
}

- (void)naviRightBtnEvent:(UIButton *)sender{
    [MyShareVC pushFromVC:self requestParams:1 success:^(id data) {
        
    }];
}

- (void)leftButtonEvent{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataSource = [NSMutableArray array];
    
//    self.view.backgroundColor = UIColor.whiteColor;
//    [self.view gradientLayerAboveView:self.view withShallowColor:HEXCOLOR(0x0D0D0D) withDeepColor:HEXCOLOR(0x414141) isVerticalOrHorizontal:true];
    self.view.backgroundColor = kBlackColor;
    [self.rightBtn setTitle:@"记录" forState:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    [self.navigationItem addCustomLeftButton:self withImage:[UIImage imageNamed:@"icon_back_white"] andTitle:@""];
    NSString *title = @"";
    switch ([self.requestParams intValue]) {
        case 0:
        {
            title = @"";
        }
            break;
        case 1:
        {
            title = @"";
        }
            break;
        default:
            break;
    }
    [self.navigationItem addNavTitle:title withTitleColor:kWhiteColor];
    
//    [self createButtons];
//    [self.cusSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self configureUI:[self.requestParams integerValue]];
}
- (void)configureUI:(NSInteger)tag {
    self.dataArr = nil;
    CATransition *tr = [CATransition animation];
    tr.type = @"cube";
    tr.subtype = kCATransitionFromRight;
    tr.duration = 0.25;
    [self.animationView.layer addAnimation:tr forKey:nil];
//    self.animationView.backgroundColor = [UIColor lightGrayColor];
    
    self.animationView.userInteractionEnabled = true;
    self.animationView.frame = CGRectMake(0, YBFrameTool.safeAdjustNavigationBarHeight, self.view.frame.size.width, 222);//MAINSCREEN_WIDTH*64/112
    
    self.animationView.image = kIMG(@"topup_bigBg");
    [self.view addSubview:self.animationView];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.top.equalTo(self.view).offset(CGRectGetMaxY(self.animationView.frame)+0);
        make.left.equalTo(self.view);
        make.center.equalTo(self.view);
//        make.edges.equalTo(self.view);
    }];
    
    if(self.carousel) {
        [self.carousel releaseTimer];
        [self.carousel removeFromSuperview];
        self.carousel = nil;
    }
    
    
    
    CWFlowLayout *flowLayout = [[CWFlowLayout alloc] initWithStyle:[self styleFromTag:tag]];
    
    // 使用layout创建视图(使用masonry 或者 系统api)
    
    CWCarousel *carousel = [[CWCarousel alloc] initWithFrame:CGRectMake(0, 9, MAINSCREEN_WIDTH, self.animationView.frame.size.height-30)
                                                    delegate:self
                                                  datasource:self
                                                  flowLayout:flowLayout];
//    carousel.translatesAutoresizingMaskIntoConstraints = NO;
    [self.animationView addSubview:carousel];
    
//    carousel.isAuto = YES;
//    carousel.autoTimInterval = 2;
//    carousel.endless = YES;
    carousel.pageControl.hidden = true;
    self.openCustomPageControl = false;
    carousel.backgroundColor = [UIColor clearColor];
    
    /* 自定pageControl */
    
    CGRect frame = carousel.bounds;
    if(self.openCustomPageControl) {
        CWPageControl *control = [[CWPageControl alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 20)];
        control.center = CGPointMake(CGRectGetWidth(frame) * 0.5, CGRectGetHeight(frame) - 10);
        control.pageNumbers = 5;
        control.currentPage = 0;
        carousel.customPageControl = control;
    }
//    [carousel registerViewClass:[UICollectionViewCell class] identifier:@"cellId"];
    self.carousel = carousel;
    //每一次刷新数据时，重置初始时间
    _start = CFAbsoluteTimeGetCurrent();
    [self requestNetworkData];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.navigationController.delegate = self;
    self.navigationController.navigationBar.alpha = 1;//0.300;
    // 背景设置为黑色
//        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
    // 设置为半透明
    self.navigationController.navigationBar.translucent = YES;
    //2.设置有没有Navi的情况
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if(@available(iOS 15, *)) {
     UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
     [appearance configureWithOpaqueBackground];
     appearance.backgroundColor = kBlackColor;
    appearance.shadowColor = [UIColor clearColor];
     self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance=self.navigationController.navigationBar.standardAppearance;
     }
    [self.carousel controllerWillAppear];
    
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.navigationController.delegate = self;
    self.navigationController.navigationBar.alpha = 1;
    // 背景颜色设置为系统默认颜色
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.translucent = NO;
    //设置有没有Navi的情况
//    [self.navigationController setNavigationBarHidden:NO animated:NO];
    if(@available(iOS 15, *)) {
     UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
     [appearance configureWithOpaqueBackground];
     appearance.backgroundColor = YBGeneralColor.navigationBarColor;
    appearance.shadowColor = [UIColor clearColor];
     self.navigationController.navigationBar.standardAppearance = appearance;
        self.navigationController.navigationBar.scrollEdgeAppearance=self.navigationController.navigationBar.standardAppearance;
     }
    [self.carousel controllerWillDisAppear];
    
    [SVProgressHUD dismiss];
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = true;
    if (self.orderId.length>0) {
        [self.vm network_postQueryLevelWithRequestParams:self.orderId success:^(id data) {
                    
                } failed:^(id data) {
                    
        }];
    }
}
#pragma mark - < 事件响应 >
- (void)buttonClick:(UIButton *)sender {
    static NSInteger tag = -1;
    if(tag == sender.tag) {
        return;
    }
    tag = sender.tag;
    [self configureUI:tag];
}
- (void)switchChanged:(UISwitch *)switchSender {
    self.openCustomPageControl = switchSender.on;
    if (self.carousel)
    {
        [self configureUI:self.carousel.flowLayout.style - 1];
    }
}
- (void)createButtons {
    NSArray *titles = @[@"正常样式", @"横向滑动两边留白", @"横向滑动两边留白渐变效果", @"两边被遮挡效果"];
    CGFloat height = 40;
    dispatch_apply(4, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.view addSubview:button];
            [button setTitle:titles[index] forState:UIControlStateNormal];
            button.tag = index;
            button.frame = CGRectMake(0, height * index + [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height + 10, CGRectGetWidth(self.view.frame), height);
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        });
    });
//    [self.view addSubview:self.animationView];
}

- (CWCarouselStyle)styleFromTag:(NSInteger)tag {
    switch (tag) {
        case 0:
            return CWCarouselStyle_H_2;
            break;
        case 1:
            return CWCarouselStyle_Normal;
            break;
//        case 2:
//            return CWCarouselStyle_H_1;
//            break;
//        case 3:
//            return CWCarouselStyle_H_3;
//            break;
        default:
            return CWCarouselStyle_Unknow;
            break;
    }
}

- (void)showMethodsView{
    if (self.methodsArr.count>0) {
        BottomListPopUpView* popupView = [[BottomListPopUpView alloc]init];
        
        NSMutableArray* amountMethods =[NSMutableArray array];
        switch ([self.requestParams intValue]) {
            case 0:
            {
                HomeList* list = self.selectedItem;
                NSString* amountStr = list.valid_period>0 ? list.real_value: list.value;
                
                for (HomeItem* etm in self.methodsArr) {
                    if ([etm.money isEqualToString:amountStr]) {
                        [amountMethods addObjectsFromArray:[MinePayMethod mj_objectArrayWithKeyValuesArray:etm.types]];
                        break;
                    }
                }
                [popupView richElementsInViewWithModel:@[amountMethods] withTitle:[NSString stringWithFormat:@"%@",list.name] withSectionHeaderTitle: amountStr];
            }
            break;
            case 1:
            {
                HomeItem* item = self.selectedItem;
                for (HomeItem* etm in self.methodsArr) {
                    if ([etm.money isEqualToString:item.money]) {
                        [amountMethods addObjectsFromArray:[MinePayMethod mj_objectArrayWithKeyValuesArray:etm.types]];
                        break;
                    }
                }
                [popupView richElementsInViewWithModel:@[amountMethods] withTitle:[NSString stringWithFormat:@"%@",@""] withSectionHeaderTitle:item.money];
            }
            break;
        default:
            break;
    }

        [popupView showInView:self.view];
        [popupView actionBlock:^(MinePayMethod* seletedMeth) {
            
            if (seletedMeth == nil) {
                return;
            }
            [popupView disMissView];
            NSDictionary* dic = @{};
            switch ([self.requestParams intValue]) {
                case 0:
                {
                    HomeList* list = self.selectedItem;
                    dic  = @{@([seletedMeth.payMent integerValue]): list};
                }
                break;
                case 1:
                {
                    HomeItem* item = self.selectedItem;
                    dic  = @{@([seletedMeth.payMent integerValue]): item};
                }
                break;
            default:
                break;
        }
            [self.vm network_postLevelMethodSureWithRequestParams:dic
            success:^(HomeModel* model) {
                self.orderId = [NSString stringWithFormat:@"%@",model.data.pay_id];
                NSDictionary* dicc = @{@"pay_id":[NSString stringWithFormat:@"%@",model.data.pay_id],
                    @"type":[NSString stringWithFormat:@"%@",seletedMeth.type],
                    @"time":[NSString getCurrentTimestamp]
                };
                [self.vm network_postFinalLevelMethodSureWithRequestParams:dicc
                success:^(HomeModel* model) {
                    
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.data.msg.payUrl]]];
//                    
//                    AXWebViewController *webVC = [[AXWebViewController alloc] initWithAddress:[NSString stringWithFormat:@"%@",model.data.msg.payUrl]];
////                    webVC.showsToolBar = NO;
////                    webVC.showsNavigationBackBarButtonItemTitle = NO;
//                    webVC.navigationType = AXWebViewControllerNavigationToolItem;
//                    webVC.showsToolBar = YES;
//
//                    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:webVC];
//                    nav.navigationBar.tintColor = [UIColor colorWithRed:0.322 green:0.322 blue:0.322 alpha:1.00];
//                    [self presentViewController:nav animated:YES completion:NULL];
                    
//                    webVC.navigationController.navigationBar.translucent = NO;
//                    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.100f green:0.100f blue:0.100f alpha:0.800f];
//                    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.996f green:0.867f blue:0.522f alpha:1.00f];
//                    [self.navigationController pushViewController:webVC animated:YES];
                    
                    
                    
//                    [WebViewController pushFromVC:self req:@{@([seletedMeth.payMent integerValue]):[NSString stringWithFormat:@"%@",model.data.msg.payUrl]} withProgressStyle:DKProgressStyle_Gradual success:^(id data) {
//
//                        }];
                    
                    if (self.block) {
                        self.block(model);
                    }
                    
                  }
               failed:^(id model){

               }];
                
//                if (self.block) {
//                    self.block(model);
//                }
                
              }
           failed:^(id model){

           }];
            
        }];
    }
    
}
#pragma mark - 网络层
- (void)requestNetworkData {
    [self.vm network_getLevelInfoWithRequestParams:self.requestParams success:^(NSArray * results) {
        NSMutableArray *arr = [NSMutableArray array];
        NSMutableArray *amoutArr = [NSMutableArray array];
        NSString* amoutStr = @"";
//        NSString *imgName = @"";
        if ([self.requestParams intValue] == 0 ) {
            for (HomeList* list in results) {
                
                [arr addObject:list];
                [amoutArr addObject:list.valid_period>0?list.real_value:list.value];
                
            }
        }else{
            [arr addObjectsFromArray:results];
            for (HomeItem* item in results) {
                [amoutArr addObject:item.money];
            }
            
        }
        amoutStr = [amoutArr componentsJoinedByString:@","];
        self.dataArr = arr;
        
//        [self.carousel freshCarousel];
        if (self.dataArr.count>0) {//3
//            self.carousel.currentIndexPath  = [NSIndexPath indexPathForRow:4 inSection:0];
//            [self.carousel.carouselView  scrollToItemAtIndexPath:self.carousel.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
//            [self updateTableDatas:0];
            
            
            [self.vm network_getLevelMethodWithRequestParams:@{@"money":amoutStr} success:^(NSArray * model) {
                [self.carousel freshCarousel];
    //            self.carousel.currentIndexPath  = [NSIndexPath indexPathForRow:4 inSection:0];
    //            [self.carousel.carouselView  scrollToItemAtIndexPath:self.carousel.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                [self updateTableDatas:0];
                
                self.methodsArr = model;
                
                [self updateBV];
            } failed:^(id data) {
                
            }];
        }
        
        } failed:^(id data) {
            
        }];
    
    return;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSMutableArray *arr = [NSMutableArray array];
        NSString *imgName = @"";
        for (int i = 0; i < 8; i++) {
            imgName = [NSString stringWithFormat:@"topup_bg%i", i + 1];//02d= 0102
            [arr addObject:imgName];
        }
        self.dataArr = arr;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.carousel freshCarousel];
            if (self.dataArr.count>3) {
                self.carousel.currentIndexPath  = [NSIndexPath indexPathForRow:4 inSection:0];
    //            [self CWCarousel:self.carousel didEndScrollAtIndex:2 indexPathRow:<#(NSInteger)#>];
                [self.carousel.carouselView  scrollToItemAtIndexPath:self.carousel.currentIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                [self updateTableDatas:4];
            }
            
        });
    });
}
- (void)updateBV{
    if ([self.requestParams intValue]==1) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-YBFrameTool.iphoneBottomHeight-48.5);
        }];
    }else{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-YBFrameTool.iphoneBottomHeight-48.5-23);
        }];
    }
    [self.view bottomSingleButtonInSuperView:self.view WithButtionTitles:[self.requestParams intValue]==0?@"":@"" withBottomMargin:YBFrameTool.iphoneBottomHeight isHidenLine:YES leftButtonEvent:^(id data) {
        [self showMethodsView];
    }];
    if([self.requestParams intValue]==1)return;
    for (UIView* bV in self.view.subviews) {
        if (bV.tag == 88) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.adjustsImageWhenHighlighted = NO;
            
            button.titleLabel.font = kFontSize(13);
            
            button.layer.masksToBounds = YES;
        //    button.layer.cornerRadius = 4;
        //    button.layer.borderWidth = 1;
        //    button.layer.borderColor = HEXCOLOR(0x4c7fff).CGColor;
            [button setTitle:@"" forState:UIControlStateNormal];
            [button setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//                        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:button];
            
            button.backgroundColor = kWhiteColor;
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(@0);
                make.trailing.equalTo(@0);
                make.bottom.equalTo(bV.mas_top).offset(0);
                
                make.height.mas_equalTo(@23);
            }];
        }
    }
}

#pragma mark - Delegate
- (NSInteger)numbersForCarousel {
//    return kCount;
    return self.dataArr.count;
}

- (UICollectionViewCell *)viewForCarousel:(CWCarousel *)carousel indexPath:(NSIndexPath *)indexPath index:(NSInteger)index{
//    UICollectionViewCell *cell = [carousel.carouselView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];//以indexPath来唯一确定cell
    [carousel registerViewClass:[UICollectionViewCell class] identifier:CellIdentifier];
    UICollectionViewCell *cell = [carousel.carouselView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath]; //出列可重用的cell
//    cell.tag = indexPath.row;
//    if (cell == nil) {
    
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.layer.masksToBounds = YES;
        cell.layer.cornerRadius = 8;
//    }
//    for(id subView in cell.subviews){
//
//    if(subView){
//
//    [subView removeFromSuperview];
//
//    }
//
//    }

    
    
    UIImageView *imgView = [cell.contentView viewWithTag:kViewTag];
    
    UIButton *vicon = [cell.contentView viewWithTag:kViewTag+1];
    vicon.userInteractionEnabled = NO;
    
    UIButton *ficon = [cell.contentView viewWithTag:kViewTag+2];
    ficon.userInteractionEnabled = NO;
    
    UIButton *timeBtn = [cell.contentView viewWithTag:kViewTag+3];
    timeBtn.userInteractionEnabled = NO;
    if(cell) {
        imgView = [[UIImageView alloc] init];
        imgView.tag = kViewTag;
        [cell.contentView addSubview:imgView];
        
        
        vicon = [[UIButton alloc]init];
        vicon.userInteractionEnabled = NO;
        vicon.tag = kViewTag+1;
        [vicon setBackgroundColor:kClearColor];
        [cell.contentView addSubview:vicon];
        
        vicon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        vicon.titleLabel.numberOfLines = 0;
        vicon.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //    icon.titleLabel.font = kFontSize(12);
        [vicon setBackgroundImage:[UIImage new] forState:0];
        
        ficon = [[UIButton alloc]init];
        self.ficon = ficon;
        ficon.userInteractionEnabled = NO;
        ficon.tag = kViewTag+2;
        [ficon setBackgroundColor:kClearColor];
        [cell.contentView addSubview:ficon];
        
        ficon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        ficon.titleLabel.numberOfLines = 0;
        ficon.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //    icon.titleLabel.font = kFontSize(12);
        [ficon setBackgroundImage:[UIImage new] forState:0];
        
        timeBtn = [[UIButton alloc]init];
        timeBtn.userInteractionEnabled = NO;
        timeBtn.tag = kViewTag+3;
        [timeBtn setBackgroundColor:kClearColor];
        [cell.contentView addSubview:timeBtn];
        
        timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        timeBtn.titleLabel.numberOfLines = 0;
        timeBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //    icon.titleLabel.font = kFontSize(12);
        [timeBtn setBackgroundImage:[UIImage new] forState:0];
    }
    
    
    switch ([self.requestParams intValue]) {
        case 0:
        {
            HomeList *list = self.dataArr[index];
            imgView.frame = cell.contentView.bounds;
            imgView.backgroundColor = [UIColor clearColor];
            NSString *name = [NSString stringWithFormat:@"topup_bg%li", (long)[list.bg_img integerValue]];//02d= 0102
            UIImage *img = [UIImage imageNamed:name];
            if(!img) {
                NSLog(@"%@", name);
            }
            [imgView setImage:img];
            self.animationView.userInteractionEnabled = YES;
            
            [vicon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(30);
                make.right.mas_equalTo(-15);
    //            make.center.mas_equalTo(cell.contentView);
                make.height.mas_equalTo(25);
                make.width.mas_equalTo(100);
            }];
            [vicon setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@",list.valid_period>0 ? list.real_value: list.value] stringColor:HEXCOLOR(0xffffff) stringFont:[UIFont boldSystemFontOfSize:30] subString:[NSString stringWithFormat:@"%@  元",@""] subStringColor:HEXCOLOR(0xffffff) subStringFont:kFontSize(13) paragraphStyle:NSTextAlignmentCenter] forState:UIControlStateNormal];
            
            if ([list.bg_img intValue] == 5&&
                list.valid_period >0) {
                
                [ficon mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(vicon.mas_bottom).offset(20);
                    make.right.mas_equalTo(-15);
        //            make.center.mas_equalTo(cell.contentView);
                    make.height.mas_equalTo(25);
                    make.width.mas_equalTo(100);
                }];
                [ficon setAttributedTitle:
                 [NSString attributedStringWithStrikethroughStyle:
                  [NSString attributedStringWithString:[NSString stringWithFormat:@"%@",list.value] stringColor:HEXCOLOR(0x9CA8C5) stringFont:[UIFont systemFontOfSize:20] subString:[NSString stringWithFormat:@"%@  元",@""] subStringColor:HEXCOLOR(0x9CA8C5) subStringFont:kFontSize(8) paragraphStyle:NSTextAlignmentCenter]
                     
                  ]
                        forState:UIControlStateNormal];
                
            self.timeBtn = timeBtn;
            [timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(60);
                make.left.mas_equalTo(15);
    //            make.center.mas_equalTo(cell.contentView);
                make.height.mas_equalTo(25);
                make.width.mas_equalTo(100);
            }];
            timeBtn.layer.masksToBounds = YES;
            timeBtn.layer.cornerRadius = 25/2;
            timeBtn.backgroundColor = HEXCOLOR(0x9CA8C5);

            NSInteger second = list.valid_period  - round(CFAbsoluteTimeGetCurrent()-_start);
            [self startTimeCount:[NSString stringWithFormat:@"%ld",(long)second]];
            }
        }
            break;
        case 1:
        {
            HomeItem *it = self.dataArr[0];
            imgView.frame = CGRectMake(20, 10, MAINSCREEN_WIDTH-40, cell.contentView.bounds.size.height-20);
            imgView.backgroundColor = [UIColor whiteColor];
            [imgView setImage:nil];
            imgView.layer.masksToBounds = YES;
            imgView.layer.cornerRadius = 8;
            self.animationView.userInteractionEnabled = NO;
            
            
            [vicon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(60);
                make.left.mas_equalTo(40);
    //            make.center.mas_equalTo(cell.contentView);
                make.height.mas_equalTo(25);
                make.width.mas_equalTo(150);
            }];
            [vicon setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@",@""] stringColor:HEXCOLOR(0x000000) stringFont:[UIFont systemFontOfSize:20] subString:[NSString stringWithFormat:@"%@",@""] subStringColor:HEXCOLOR(0x000000) subStringFont:kFontSize(13) paragraphStyle:NSTextAlignmentCenter] forState:UIControlStateNormal];
            
            [ficon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(60);
                make.right.mas_equalTo(-35);
    //            make.center.mas_equalTo(cell.contentView);
                make.height.mas_equalTo(25);
                make.width.mas_equalTo(100);
            }];
            [self updateCollectionDatas:it];
        }
            break;
        default:
            break;
    }
    
    
    
    return cell;
}


- (void)timeActionBlock:(TwoDataBlock)timeBlock{

    self.timeBlock = timeBlock;
}

/**设置倒计时时间，并启动倒计时*/
- (void)startTimeCount:(NSString *)sec
{
    if (sec) {
        self.timeCount = [sec integerValue];
    } else {
        self.timeCount = 60;
    }
    
    [self distoryTimer];
    self.timeBtn.enabled = false;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(_timerAction)
                                                userInfo:nil
                                                 repeats:YES];
    //    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**停止定时器*/
- (void)distoryTimer
{
    if (self.timer != nil)
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

#pragma mark timer
- (void) _timerAction
{
    self.timeCount--;
    [self.timeBtn setAttributedTitle:
     
      [NSString attributedStringWithString:[NSString stringWithFormat:@"%@",[NSString transToHMSSeparatedByColonFormatSecond:self.timeCount]] stringColor:HEXCOLOR(0xffffff) stringFont:[UIFont systemFontOfSize:18] subString:[NSString stringWithFormat:@"%@",@""] subStringColor:HEXCOLOR(0xffffff) subStringFont:kFontSize(8) paragraphStyle:NSTextAlignmentCenter]
      
                    forState:UIControlStateNormal];
    
    if(self.timeCount < 0){
        [self distoryTimer];
        self.timeBtn.enabled = false;
        self.timeBtn.hidden = true;
        self.ficon.hidden = true;
//        [self.timeBtn setTitle:@"00:00" forState:UIControlStateNormal];
        //        [self.timeBtn setTitleColor:HEXCOLOR(0xf6f5fa) forState:UIControlStateNormal];
        if (self.timeBlock) {
            self.timeBlock(@(_timeBtn.tag), _timeBtn);
        }
        
    }
}

//- (void) removeFromSuperview
//{
//    [super removeFromSuperview];
//
//    [self distoryTimer];
//}


- (void)CWCarousel:(CWCarousel *)carousel didSelectedAtIndex:(NSInteger)index {
    NSLog(@"...%ld...", (long)index);
//    [self updateTableDatas:index];
}


- (void)CWCarousel:(CWCarousel *)carousel didStartScrollAtIndex:(NSInteger)index indexPathRow:(NSInteger)indexPathRow {
    NSLog(@"开始滑动: %ld", index);
}


- (void)CWCarousel:(CWCarousel *)carousel didEndScrollAtIndex:(NSInteger)index indexPathRow:(NSInteger)indexPathRow {
    NSLog(@"结束滑动: %ld", index);
    if ([self.requestParams intValue] ==0) {
    [self updateTableDatas:index];
    }
    
}
- (void)updateTableDatas:(NSInteger)index{
    [_dataSource removeAllObjects];
    if ([self.requestParams intValue] ==0) {
        HomeList* list = _dataArr[index];
        self.selectedItem = list;
        
        NSMutableArray* marr = [[HomeItem mj_objectArrayWithKeyValuesArray:list.rights_list] mutableCopy];
        HomeItem* item = marr.firstObject;
        item.name = list.name_day;
        [marr replaceObjectAtIndex:0 withObject:item];
        [_dataSource addObject:@[
            marr
        ]];
    }else{
        [_dataSource addObject:@[_dataArr]];
    }
    
    [self.tableView reloadData];
}

- (void)updateCollectionDatas:(HomeItem*)item{
    for (HomeItem* it in _dataArr) {
        if ([item isEqual:it]) {
            self.selectedItem = it;
            [self.ficon setAttributedTitle:
             
              [NSString attributedStringWithString:[NSString stringWithFormat:@"%@",it.money] stringColor:HEXCOLOR(0x000000) stringFont:[UIFont systemFontOfSize:30] subString:[NSString stringWithFormat:@"%@  元",@""] subStringColor:HEXCOLOR(0x000000) subStringFont:kFontSize(13) paragraphStyle:NSTextAlignmentCenter]
                 
                    forState:UIControlStateNormal];
        }
    }
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
    return 75.0f;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];

    view.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, 75);
    view.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imgV = [[UIImageView alloc] init];
    [view addSubview:imgV];
    imgV.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    
    UIButton *btn = [[UIButton alloc] init];
    [imgV addSubview:btn];
//    btn.frame = CGRectMake(0, 0, 100, view.frame.size.height);
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(@15);
//        make.trailing.equalTo(btn.mas_left).offset(-10);
        make.center.mas_equalTo(imgV);
        make.height.mas_equalTo(imgV.frame.size.height);
        make.width.equalTo(@100);
    }];
    
    UIImageView* line0 = [[UIImageView alloc]init];
    [imgV addSubview:line0];
    line0.backgroundColor = HEXCOLOR(0x000000);


    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imgV.mas_left).offset(15);
        make.right.equalTo(btn.mas_left).offset(-10);
        make.centerY.mas_equalTo(btn);
        make.height.equalTo(@.5);
    }];
//
    UIImageView* line1 = [[UIImageView alloc]init];
    [imgV addSubview:line1];
    line1.backgroundColor = HEXCOLOR(0x000000);


    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(imgV.mas_right).offset(-15);
        make.left.equalTo(btn.mas_right).offset(10);
        make.centerY.mas_equalTo(btn);
        make.height.equalTo(@.5);
    }];
    
    NSArray *titles = @[];
    switch ([self.requestParams intValue]) {
        case 0:
        {
            titles = @[@""];
        }
            break;
        case 1:
        {
            titles = @[@""];
        }
            break;
        default:
            break;
    }
    [btn setTitle:titles[section] forState:0];
    btn.titleLabel.font = kFontSize(18);
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [btn setTitleColor:kBlackColor forState:0];;
    
    return view;
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
    return [LevelGridCell cellHeightWithModel:(_dataSource[indexPath.section])[indexPath.row] requestParams:[self.requestParams intValue]];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LevelGridCell *cell = [LevelGridCell cellWith:tableView];
    [cell richElementsInCellWithModel:(_dataSource[indexPath.section])[indexPath.row] requestParams:[self.requestParams intValue]];
    [cell actionBlock:^(HomeItem *item) {
        [self updateCollectionDatas:item];
    }];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.tableHeaderView = [self headerView];
        _tableView.backgroundColor = kWhiteColor;
    }
    return _tableView;
}

- (UIView *)animationView{
    if(!_animationView) {
        self.animationView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250, CGRectGetWidth(self.view.frame), 230)];
    }
    return _animationView;
}

- (MineVM *)vm {
    if (!_vm) {
        _vm = [MineVM new];
    }
    return _vm;
}

@end
