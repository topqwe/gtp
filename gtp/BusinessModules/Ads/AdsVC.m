//
//  AdsVC.m
//  HHL
//
//  Created by GT on 2018/12/19.
//  Copyright © 2018 GT. All rights reserved.
//

#import "AdsVC.h"
#import "TabScrollview.h"
#import "TabContentView.h"

#import "PageVC.h"
#import "PostAdsVC.h"
#import "InputPWPopUpView.h"
@interface AdsVC ()
@property (nonatomic,strong)TabScrollview *tabScrollView;
@property (nonatomic,strong)TabContentView *tabContent;
@property (nonatomic, strong) UIButton * editAdsBtn;
@property (nonatomic,strong)NSMutableArray *tabs;

@property (nonatomic,strong)NSMutableArray *contents;
@end

@implementation AdsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    
    NSArray* titles = @[@"全部",@"休闲中",@"拉拉",@"已朋友"];
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
            
        PageVC *con=[PageVC new];
        
        con.view.backgroundColor= RANDOMRGBCOLOR;
        con.tag=titleStr;
        [_contents addObject:con];
        [con actionBlock:^(id data, id data2,UIView* view,UITableView* tableView,NSMutableArray *dataSource,NSIndexPath* indexPath) {
            EnumActionTag sec = [data integerValue];
            switch (sec) {
                case EnumActionTag0:
                {
                    [PostAdsVC pushFromVC:self requestParams:@(PostAdsTypeEdit) success:^(id data) {
                        
                    }];
                }
                    break;
                case EnumActionTag1:
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好了要上架吗？" message:nil preferredStyle:  UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        InputPWPopUpView* popupView = [[InputPWPopUpView alloc]init];
                        [popupView showInView:self.view];
                        [popupView actionBlock:^(id data) {
                            [con pageListView:(PageListView *)view requestListWithPage:1];
                            [YKToastView showToastText:@"上架成功"];
                        }];
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [[YBNaviagtionViewController rootNavigationController] presentViewController:alert animated:true completion:nil];
                }
                    break;
                case EnumActionTag2:
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"好了要朋友吗？" message:nil preferredStyle:  UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        InputPWPopUpView* popupView = [[InputPWPopUpView alloc]init];
                        [popupView showInView:self.view];
                        [popupView actionBlock:^(id data) {
                            [tableView beginUpdates];
                            [dataSource removeObjectAtIndex:indexPath.section];
                            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]  withRowAnimation:UITableViewRowAnimationLeft];
                            [tableView reloadData];
                            [tableView endUpdates];
                            [YKToastView showToastText:@"朋友成功"];
                        }];
                    }]];
                    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [[YBNaviagtionViewController rootNavigationController] presentViewController:alert animated:true completion:nil];
                }
                    break;
                    
                default:
                    break;
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
    
    
    _editAdsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //        _editAdsBtn.tag = IndexSectionFour;
    [_editAdsBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
//    _editAdsBtn.backgroundColor = kGrayColor;
    [_editAdsBtn setImage:[UIImage imageNamed:@"editAds"] forState:UIControlStateNormal];
    _editAdsBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:self.editAdsBtn];
    [self.editAdsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.view).offset(-11);
        make.bottom.equalTo(self.view).offset(-70);
        make.width.height.equalTo(@54);
    }];
}

- (void)clickItem:(UIButton*)button{
    [PostAdsVC pushFromVC:self requestParams:@(PostAdsTypeCreate) success:^(id data) {
        
    }];
}
@end
