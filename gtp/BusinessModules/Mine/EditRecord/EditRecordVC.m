//
//  ViewController.m
//  pod_test
//
//  Created by YY_ZYQ on 2017/5/17.
//  Copyright © 2017年 YY_ZYQ. All rights reserved.
//

#import "EditRecordVC.h"
#import "EditDeleteBV.h"
#import "EditRecordCell.h"
#import "MineVM.h"
@interface EditRecordVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) UIView * dataEmptyView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong)NSArray * lastSectionArr;
@property (nonatomic, strong)NSMutableArray * lastSectionSumArr;

@property (nonatomic, strong) MineVM *vm;

@property (nonatomic ,strong) NSMutableArray *dataArray;//数据源
@property (nonatomic ,strong) NSMutableArray *deleteArray;//删除的数据

@property (nonatomic ,assign) BOOL isInsertEdit;//tableview编辑方式的判断
@property (nonatomic ,strong) EditDeleteBV *bottom_view;//底部视图
@property (nonatomic, assign) EditRecordSource requestParams;
@end

@implementation EditRecordVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(EditRecordSource )requestParams success:(DataBlock)block{
    EditRecordVC *vc = [[EditRecordVC alloc] init];
//    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

- (void)levSuccessMethod{
    [self requestList];
}

- (void)requestList{
    [self requestHomeListWithPage:1 WithSource:self.requestParams];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;//处理tablevie下移64
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.top.left.equalTo(self.view);
        make.center.equalTo(self.view);
//        make.edges.equalTo(self.view);
    }];
    _isInsertEdit = NO;
    
    [self.rightBtn setTitle:@"编辑" forState:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    self.title = self.requestParams == EditRecordSourcViewHistory? @"观看记录":@"我的收藏";
    //获取数据
//    [self getTableviewData];
    [self requestList];

}

- (void)getTableviewData{
    //拟造数据，此数据需要从服务器获取
    NSArray *array = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    //添加到数据源中
    [self.dataArray addObjectsFromArray:array];
    [self.tableView reloadData];
}

#pragma mark - public requestData(HomeViewDelegate)

- (void) requestHomeListWithPage:(NSInteger)page WithSource:(EditRecordSource)s{
   kWeakSelf(self);
    self.requestParams = s;
    [self.vm network_getEditRecordPage:page WithSource:s success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr,NSArray * _Nonnull lastSectionSumArr) {
        kStrongSelf(self);
        [self requestHomeListSuccessWithArray:dataArray WithLastSectionArr:lastSectionArr WithLastSectionSumArr:lastSectionSumArr WithPage:page];
    } failed:^(id model){
        kStrongSelf(self);
//        [self requestHomeListSuccessWithArray:model WithPage:page];
        [self requestHomeListFailed];
    }];
}

#pragma mark - public processData
- (void)requestHomeListSuccessWithArray:(NSArray *)sections WithLastSectionArr:(NSArray *)lastSectionArr WithLastSectionSumArr:(NSArray *)lastSectionSumArr WithPage:(NSInteger)page{
    self.currentPage = page;
    [self.deleteArray removeAllObjects];
    self.bottom_view.allBtn.selected = NO;
    
    if (self.currentPage == 1) {
        self.tableView.tableFooterView = [UIView new];
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        if (self.dataEmptyView) {
            [self.dataEmptyView removeFromSuperview];
        }
//        UIButton* btn0 = _funcBtns[0];
//        [self.view layoutIfNeeded];
        self.dataEmptyView = [self.view setDataEmptyViewInSuperView:self.view withTopMargin:0 withCustomTitle:@"" withCustomImageName:@""];
        if(!lastSectionSumArr||lastSectionSumArr.count==0){
            self.dataEmptyView.hidden = false;
        }else{
            self.dataEmptyView.hidden = true;
        }
    }
    if (lastSectionSumArr.count > 0) {
        
        self.dataEmptyView.hidden = true;
        self.lastSectionArr = lastSectionArr;
        
        self.lastSectionSumArr = [NSMutableArray array];
        [self.lastSectionSumArr addObjectsFromArray:lastSectionSumArr];
        
        [self.dataArray removeAllObjects];
        [self.dataArray addObjectsFromArray:lastSectionSumArr];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        if (lastSectionArr.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
            self.tableView.mj_footer.hidden = YES;
        }
        
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
        self.tableView.mj_footer.hidden = YES;//in 2 ways, footer no request
    }
    [self.tableView.mj_header endRefreshing];
}

- (void)requestHomeListFailed {
    self.currentPage = 0;
//    [self.sections removeAllObjects];
    [self.tableView reloadData];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

- (void)naviRightBtnEvent:(UIButton *)sender{
    if (self.tableView.isEditing&&_isInsertEdit==NO) {
        [_tableView reloadData];
        return;
    }
    sender.selected = !sender.selected;
    if (sender.selected) {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-50-[YBFrameTool iphoneBottomHeight]);
        }];
    //点击编辑的时候清空删除数组
        [self.deleteArray removeAllObjects];
        [self.rightBtn setTitle:@"取消" forState:UIControlStateNormal];
        _isInsertEdit = YES;//这个时候是全选模式
        [_tableView setEditing:YES animated:YES];
        
        //如果在全选状态下，点击完成，再次进来的时候需要改变按钮的文字和点击状态
        if (_bottom_view.allBtn.selected) {
            _bottom_view.allBtn.selected = !_bottom_view.allBtn.selected;
            [_bottom_view.allBtn setTitle:@"全选" forState:UIControlStateNormal];
        }
        
            //添加底部视图
        CGRect frame = self.bottom_view.frame;
            frame.origin.y -= 50+[YBFrameTool iphoneBottomHeight];
            [UIView animateWithDuration:0.5 animations:^{
                self.bottom_view.frame = frame;
                [self.view addSubview:self.bottom_view];
            }];
        
        
        
    }else{
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(0);
        }];
        [self.rightBtn setTitle:@"编辑" forState:UIControlStateNormal];
        _isInsertEdit = NO;
        [_tableView setEditing:NO animated:YES];
        
        [UIView animateWithDuration:0.5 animations:^{
            CGPoint point = self.bottom_view.center;
            point.y      += 50+[YBFrameTool iphoneBottomHeight];
            self.bottom_view.center   = point;
            
        } completion:^(BOOL finished) {
            [self.bottom_view removeFromSuperview];
        }];
    }
}


- (void)tapAllBtn:(UIButton *)btn{
    
    btn.selected = !btn.selected;

    if (btn.selected) {
        
        for (int i = 0; i< self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            //全选实现方法
            [_tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        
        //点击全选的时候需要清除deleteArray里面的数据，防止deleteArray里面的数据和列表数据不一致
        if (self.deleteArray.count >0) {
            [self.deleteArray removeAllObjects];
        }
        [self.deleteArray addObjectsFromArray:self.dataArray];
        
        [btn setTitle:@"全选" forState:UIControlStateNormal];
    }else{
        
        //取消选中
        for (int i = 0; i< self.dataArray.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
            [_tableView deselectRowAtIndexPath:indexPath animated:NO];
            
        }
        
        [btn setTitle:@"全选" forState:UIControlStateNormal];
        [self.deleteArray removeAllObjects];
    }
  
  
//    NSLog(@"+++++%ld",self.deleteArray.count);
//    NSLog(@"===%@",self.deleteArray);
    
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [EditRecordCell cellHeightWithModel];;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EditRecordCell *cell = [EditRecordCell cellWith:tableView];
    [cell richElementsInCellWithModel:self.dataArray[indexPath.row]];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}

//-(NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewRowAction* ra = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        [self rowDeleteAtIndexPath:indexPath];
//    }];
//    ra.backgroundColor = HEXCOLOR(0xFF7A7A);
//    return @[ra];
//}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //根据不同状态返回不同编辑模式
    if (_isInsertEdit) {
        
        return UITableViewCellEditingStyleDelete|UITableViewCellEditingStyleInsert;
        
    }else{

        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView*)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    //左滑删除数据方法
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self rowDeleteAtIndexPath:indexPath];
    }
}
- (void)rowDeleteAtIndexPath:(NSIndexPath*)indexPath{
    NSMutableArray* ids = [NSMutableArray array];
    HomeItem* item = self.dataArray[indexPath.row];
    [ids addObject:@(item.ID)];
    [self.vm network_getDeteleEditRecord:ids WithSource:self.requestParams success:^(NSArray * _Nonnull dataArray) {
        [self.dataArray removeObjectVerifyAtIndex: indexPath.row];
//            [self.tableView beginUpdates];
//
//            [self.tableView deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath]
//                                  withRowAnimation:UITableViewRowAnimationLeft];
//            [self.tableView endUpdates];
        [self.tableView reloadData];
        
        if (self.dataArray.count == 0) {
            
            [self requestHomeListWithPage:1 WithSource:self.requestParams];
        }
    } failed:^(id data) {
        
    }];
}
/**
 删除数据方法
 */
- (void)deleteData{
    if (self.deleteArray.count >0) {
        NSMutableArray* ids = [NSMutableArray array];
        for (HomeItem* item in self.deleteArray) {
            [ids addObject:@(item.ID)];
        }
        
        [self.vm network_getDeteleEditRecord:ids WithSource:self.requestParams success:^(NSArray * _Nonnull dataArray) {
            [self.dataArray removeObjectsInArray:self.deleteArray];
            [self.tableView reloadData];
            if (self.dataArray.count == 0) {
                
                [self requestHomeListWithPage:1 WithSource:self.requestParams];
            }
        } failed:^(id data) {
            
        }];
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    //正常状态下，点击cell进入跳转下一页
    //在编辑模式下点击cell 是选中数据
    if (self.rightBtn.selected) {
         NSLog(@"选中");
        [self.deleteArray addObject:[self.dataArray objectAtIndex:indexPath.row]];

    }else{
//        NSLog(@"跳转下一页");
        HomeItem* item = self.dataArray[indexPath.row];
        [self pushMoviePlayerVC:item];
    }
    
    [self isAllSelected];
    
}

#pragma mark - clickEvent
- (void)pushMoviePlayerVC:(id) data{
//    [MoviePlayerVC pushFromVC:self requestParams:data success:^(id data) {
//
//    }];
    [ShowFilmVC pushFromVC:self requestParams:data success:^(id data) {

    }];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    if (self.rightBtn.selected) {
        NSLog(@"撤销");
        [self.deleteArray removeObject:[self.dataArray objectAtIndex:indexPath.row]];
        
    }else{
        NSLog(@"取消跳转");
    }

    [self isAllSelected];
}

 
- (void)isAllSelected{
    
    if (self.deleteArray.count == self.dataArray.count) {
        
        self.bottom_view.allBtn.selected = YES;
    }
    else
    {
        self.bottom_view.allBtn.selected = NO;
    }
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        kWeakSelf(self);
        [_tableView addMJHeaderWithBlock:^{
                     kStrongSelf(self);
                     self.currentPage = 1;
                     [self requestHomeListWithPage:self.currentPage WithSource:self.requestParams];
         }];
         
        [_tableView addMJFooterWithBlock:^{
                     kStrongSelf(self);
                     ++self.currentPage;
            [self requestHomeListWithPage:self.currentPage WithSource:self.requestParams];
         }];
    }
    return _tableView;
}

- (EditDeleteBV *)bottom_view{
    if (!_bottom_view) {
        self.bottom_view = [[EditDeleteBV alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 50+[YBFrameTool iphoneBottomHeight])];
        _bottom_view.backgroundColor = [UIColor whiteColor];
        [_bottom_view.deleteBtn setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
        [_bottom_view.deleteBtn addTarget:self action:@selector(deleteData) forControlEvents:UIControlEventTouchUpInside];
        [_bottom_view.allBtn setImage:[UIImage imageNamed:@"editRecordDeselected"] forState:0];
        [_bottom_view.allBtn setImage:[UIImage imageNamed:@"editRecordSelected"] forState:UIControlStateSelected];
        [_bottom_view.allBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_bottom_view.allBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
        [_bottom_view.allBtn addTarget:self action:@selector(tapAllBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bottom_view;
}

- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (NSMutableArray *)deleteArray{
    if (!_deleteArray) {
        self.deleteArray = [NSMutableArray array];
    }
    return _deleteArray;
}

- (NSUInteger)currentPage {
    if (!_currentPage) {
        _currentPage = 0;
    }
    return _currentPage;
}

- (MineVM *)vm {
    if (!_vm) {
        _vm = [MineVM new];
    }
    return _vm;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
