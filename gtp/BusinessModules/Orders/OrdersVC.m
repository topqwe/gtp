//
//  OrdersVC.m

#import "OrdersVC.h"
#import "TabScrollview.h"
#import "TabContentView.h"

#import "OrdersPageVC.h"

#import "DistributePopUpView.h"
#import "InputPWPopUpView.h"

#import "OrderDetailVC.h"
@interface OrdersVC ()
@property (nonatomic,strong)TabScrollview *tabScrollView;
@property (nonatomic,strong)TabContentView *tabContent;
@property (nonatomic,strong)NSMutableArray *tabs;

@property (nonatomic,strong)NSMutableArray *contents;
@end

@implementation OrdersVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    OrdersVC *vc = [[OrdersVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title=@"我的🌹";
    NSArray* titles = @[@"hello",@"未靓靓🐟",@"symbolic",@"粮农中",@"",@""];
    _tabs=[[NSMutableArray alloc]initWithCapacity:titles.count];
    _contents=[[NSMutableArray alloc]initWithCapacity:titles.count];
    

    for(int i=0;i<titles.count;i++){
        NSString *titleStr=titles[i];
        
        UILabel *tab=[[UILabel alloc]init];
        tab.textAlignment=NSTextAlignmentCenter;
        tab.font = kFontSize(14);
        tab.text=titleStr;
        tab.textColor=[UIColor blackColor];
        [_tabs addObject:tab];
        
        
        OrdersPageVC *con=[OrdersPageVC new];
        
        con.view.backgroundColor= RANDOMRGBCOLOR;
        con.tag=titleStr;
        [_contents addObject:con];
        
//        WS(weakSelf);
        [con actionBlock:^(id data,id data2) {
            NSDictionary* model = data2;
            OrderType type = [model[kType] integerValue];
            
            if ([data boolValue]==YES) {
                switch (type) {
                    case OrderTypeWaitPay:
                    {
                        [YKToastView showToastText:@"提醒已发送"];
                    }
                        break;
                    case OrderTypeWaitDistribute:
                    {
                        DistributePopUpView* popupView = [[DistributePopUpView alloc]init];
                        [popupView richElementsInViewWithModel:model];
                        [popupView showInApplicationKeyWindow];
                        [popupView actionBlock:^(id data) {
                            EnumActionTag tag = (EnumActionTag)[data integerValue];
                            switch (tag) {
                                case EnumActionTag1:
                                {//post
                                    InputPWPopUpView* popupView = [[InputPWPopUpView alloc]init];
                                    [popupView showInView:self.view];
                                    [popupView actionBlock:^(id data) {
                                        [YKToastView showToastText:@"已symbolic"];
                                    }];
                                    
                                }
                                    break;
                                    
                                default:
                                    break;
                            }
                        }];
                    }
                        break;
                    case OrderTypeAppeal:
                    {
                        NSLog(@"OrderTypeAppeal");
                    }
                        break;
                    default:
                        break;
                }
            }else{
                
                //            switch (type) {
                //                case OrderTypeWaitPay:
                //                {
                [OrderDetailVC  pushViewController:self requestParams:model success:^(id data) {
                    NSLog(@"....%@",model);
                }];
                //                }
                //                    break;
                //                case OrderTypeWaitDistribute:
                //                {
                //
                //                }
                //                    break;
                //                case OrderTypeAppeal:
                //                {
                //
                //                }
                //                    break;
                //                default:
                //                    break;
                //            }
                
            }
            
        }];

    }
    
    _tabScrollView=[[TabScrollview alloc]initWithFrame:CGRectZero];
    [self.view addSubview:_tabScrollView];
    [_tabScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@kTabScrollViewHeight);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
    }];
    WS(weakSelf);
    [_tabScrollView configParameter:horizontal viewArr:_tabs tabWidth:[UIScreen mainScreen].bounds.size.width/titles.count tabHeight:kTabScrollViewHeight index:0 block:^(NSInteger index) {
        
        [weakSelf.tabContent updateTab:index];
    }];
    
    
    _tabContent=[[TabContentView alloc]initWithFrame:CGRectZero];
    _tabContent.userInteractionEnabled = YES;
    [self.view addSubview:_tabContent];
    
    [_tabContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(weakSelf.tabScrollView.mas_bottom);
        make.bottom.equalTo(self.view);
    }];
    
    
    [_tabContent configParam:_contents Index:0 block:^(NSInteger index) {
        [weakSelf.tabScrollView updateTagLine:index];
    }];
    [_tabContent actionBlock:^(id data) {
//        [UIView  beginAnimations:nil context:NULL];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationDuration:0.75];
//        [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.navigationController.view cache:NO];
//        [UIView commitAnimations];
//
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDelay:0.375];
//        [self.navigationController popViewControllerAnimated:NO];
//        [UIView commitAnimations];
        
        CATransition* transition = [CATransition animation];
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        //transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [self.navigationController.view.layer addAnimation:transition forKey:nil];
        [[self navigationController] popViewControllerAnimated:NO];
        
//            [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
}

@end
