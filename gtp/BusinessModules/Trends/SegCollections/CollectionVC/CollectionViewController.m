//
//  CollectionViewController.m
//  SegmentController
//
//  Created by mamawang on 14-6-12.
//  Copyright (c) 2014年 WIQ. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionCell.h"
#import "HomeVM.h"

#import "LocationVC.h"
#import "QuickeningVC.h"
#import "CircleAnimationVC.h"
#import "TagRunVC.h"
#import "ModelFilterVC.h"
#import "WKPopUpView.h"
#import "AppListVC.h"
@interface CollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray* dataSource;;
@property (nonatomic, strong) HomeVM *vm;


@end

@implementation CollectionViewController

- (HomeVM *)vm {
    if (!_vm) {
        _vm = [HomeVM new];
    }
    return _vm;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)getAndSetModel{
    WS(weakSelf);
    [self.vm network_getTrendsListWithPage:0 success:^(NSArray * _Nonnull array) {
        
        [weakSelf.dataSource addObjectsFromArray:array[0]];
        [weakSelf.collectionView reloadData];
    } failed:^{
        [weakSelf dataSourceLoadFail];
    }];
}
-(void)dataSourceLoadFail{
    [SVProgressHUD showErrorWithStatus:@"网络不给力哦~"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UICollectionViewFlowLayout *flayout=[[UICollectionViewFlowLayout alloc] init];
    flayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //1.按colCell真是的大小计算，得出可见为准的间距
    CGFloat itemWidth = 95;
    CGFloat visibleSpace = (MAINSCREEN_WIDTH  -3*itemWidth)/4;
    
    //2.1按collection热区计算，发现colCell布局默认左对齐，不居中
//    flayout.itemSize = CGSizeMake(MAINSCREEN_WIDTH /3, 135);
    //2.2按colCell在父视图布局的大小
    flayout.itemSize = CGSizeMake(itemWidth, 135);
    
    //3.设置第一个cell和最后一个cell,与父控件之间的间距，保持和第1步一样的可见距
    flayout.sectionInset = UIEdgeInsetsMake(0, visibleSpace, 0, visibleSpace);
    
    //4.设置cell之间的横、列项间距
    flayout.minimumLineSpacing = 15;
    flayout.minimumInteritemSpacing = visibleSpace;
    
    //（不建议.首部colCell布局前，对列项间距无效，所以对整体容器collectionView的初始x坐标一律从第1步计算的可见列间距开始，宽减一个x就行，因为尾部colCell布局后默认有热区多出来的空间
//    CGRectMake(visibleSpace,self.view.bounds.origin.y, self.view.bounds.size.width - visibleSpace,self.view.bounds.size.height)
    self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flayout];
    //  这里不要用UICollectionViewLayout，UICollectionViewLayout是抽象基类，是专门用于子类继承的; UICollectionViewFlowLayout是最基本的布局
    self.collectionView.backgroundColor = kWhiteColor;
    self.collectionView.dataSource = self;
    
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:self.collectionView];
    
    UINib * nib = [UINib nibWithNibName:@"CollectionCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:@"CollectionCell"];
    [self getAndSetModel];
}

//每个section的item个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell = [CollectionCell cellAtIndexPath:indexPath inView:collectionView];
    [cell richElementsInCellWithModel:_dataSource[indexPath.row]];

    //3.
    NSInteger number = indexPath.section * 10 + indexPath.row;
    cell.countLabel.layer.cornerRadius=10.0f;
    cell.countLabel.layer.borderWidth=0.0f;
    cell.countLabel.text = [NSString stringWithFormat:@"%ld", (long)number];
    cell.countLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0 blue:0 alpha:indexPath.row /10.0];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            [LocationVC pushFromVC:self];
        }
            break;
        case 1:
        {
            [QuickeningVC pushFromVC:self];
        }
            break;
        case 2:
        {
            [CircleAnimationVC pushFromVC:self];
        }
            break;
        case 3:
        {
            [TagRunVC  pushFromVC:self];
        }
            break;
        case 4:
        {
            [ModelFilterVC  pushFromVC:self];
        }
            break;
        case 5:
        {
            return;
            NSString *str = @"";
            str = @"http://baidu.com";

            if ([str containsString:@"http"]){
                
                WKPopUpView* popupView = [[WKPopUpView alloc]init];
                [popupView richElementsInViewWithModel:str];
                [popupView showInApplicationKeyWindow];
                [popupView actionBlock:^(NSNumber*  data) {
                    switch ([data integerValue]) {
                        case 2:
                        {
                            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:^(BOOL success) {}];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }];
            }
            else
            {
                //跳转到appstore
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://apps.apple.com/cn/app/qq/id444934666"] options:@{} completionHandler:^(BOOL success) {}];
            }
            
        }
            break;
        case 6:
        {
            [AppListVC  pushFromVC:self];
        }
            break;
        default:
            break;
    }
//    CollectionAndQuiltCellData* cellData = _dataArray[indexPath.row];
//    GridListVC *list = [[GridListVC alloc]initWithNibName:nil bundle:nil];
//    list.index = cellData.ID;
//    list.naviTitle = cellData.title;
//    list.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:list animated:YES];
    
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(self.collectionView.width / 3, 135);
//}
@end
