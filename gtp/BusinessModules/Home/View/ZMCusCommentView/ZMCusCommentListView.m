//
//  ZMCusCommentListView.m
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import "ZMCusCommentListView.h"
#import "ZMCusCommentListTableHeaderView.h"
#import "ZMCusCommentListContentCell.h"
#import "ZMCusCommentListReplyContentCell.h"


#import "WTBottomInputView.h"
#import "HomeVM.h"

#import "HomeHV.h"
#import "HomeFV.h"
@interface ZMCusCommentListView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong)NSArray * lastSectionArr;
@property (nonatomic, strong)NSMutableArray * lastSectionSumArr;

@property (nonatomic, strong) UIView * dataEmptyView;
@property (nonatomic, strong) HomeVM *vm;

@property (nonatomic, strong) WTBottomInputView * bottomView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZMCusCommentListTableHeaderView *headerView;
@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, strong)UIView *hv;
@property (nonatomic, strong) HomeHV * hHV;

@property (nonatomic, strong)UIView *fv;
@property (nonatomic, strong) HomeFV * hFV;
@end


@implementation ZMCusCommentListView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = RGBHexColor(0xffffff, 1);
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 15;
        [self layoutUI];
        
    }
    return self;
}
- (void)richHeaderText:(NSInteger)s withData:(id)item{
    self.item = item;
    self.s = s;
    [_headerView.titleLabel setTitle: self.s == 1? @"回复" : @"大家都在讨论" forState:0];
    [_headerView.titleLabel setImage:kIMG(@"M_<") forState:0];
    [_headerView.titleLabel layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:5];
    [self requestHomeListWithPage:1 WithCid:0];
}
- (void)layoutUI{
    
    @weakify(self)
    _headerView = [[ZMCusCommentListTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 70)];
    _headerView.closeBtnBlock = ^{
        @strongify(self)
        if (self.closeBtnBlock) {
            self.closeBtnBlock();
        }
    };
    _headerView.titleBtnBlock = ^{
        @strongify(self)
        if (self.titleBtnBlock) {
            self.titleBtnBlock();
        }
    };
    [self addSubview:_headerView];


    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-ZMCusComentBottomViewHeight);
        make.top.mas_equalTo(70);
        make.center.equalTo(self);
//        make.edges.equalTo(self.view);
    }];
    
    

//    CGFloat toolViewY = CGRectGetMaxY(self.tableView.frame);
////    MAINSCREEN_HEIGHT- ZMCusComentBottomViewHeight-YBFrameTool.safeAdjustTabBarHeight - -YBFrameTool.safeAdjustNavigationBarHeight;
////    - YBFrameTool.safeAdjustNavigationBarHeight;
//    _toolView = [[ZMCusCommentToolView alloc] initWithFrame:CGRectZero];
//    [self addSubview:_toolView];
////    CGRectMake(0, toolViewY, MAINSCREEN_WIDTH, ZMCusComentBottomViewHeight);
//    _toolView.sendBtnBlock = ^(NSString *text){
//        @strongify(self)
//        if (self.sendBtnBlock) {
//            self.sendBtnBlock(text);
//        }
//    };
//    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self);
//        make.bottom.equalTo(self.mas_bottom).offset(-YBFrameTool.iphoneBottomHeight);
////        make.top.mas_equalTo(self.tableView.mas_bottom);
//        make.center.equalTo(self);
////        make.edges.equalTo(self.view);
//        make.height.mas_equalTo(ZMCusComentBottomViewHeight);
//    }];
    
    
//    self.bottomView = [[WTBottomInputView alloc]init];
////    [self addSubview:self.bottomView];
//    self.bottomView.delegate = self;
//    UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
//    [keyWindow addSubview:self.bottomView];
//    [self.bottomView showView];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.toolView hideTextView];
    
    if (self.scrollBlock) {
        self.scrollBlock();
    }
    
}

#pragma mark - public requestData(HomeViewDelegate)

- (void) requestHomeListWithPage:(NSInteger)page WithCid:(NSInteger)cid{
   kWeakSelf(self);
    
//    HomeItem* item ;
//    item.vid = 1221;
//    item.comment_id = 1;
    [self.vm network_postCRListWithPage:page WithHomeItem:self.item WithSource:self.s
     success:^(NSArray * _Nonnull dataArray, NSArray * _Nonnull lastSectionArr,NSArray * _Nonnull lastSectionSumArr) {
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
    if (self.currentPage == 1) {
        self.tableView.tableFooterView = [UIView new];
        [self.sections removeAllObjects];
        [self.tableView reloadData];
        if (self.dataEmptyView) {
            [self.dataEmptyView removeFromSuperview];
        }
//        UIButton* btn0 = _funcBtns[0];
//        [self.view layoutIfNeeded];
        self.dataEmptyView = [self setDataEmptyViewInSuperView:self withTopMargin:70 withCustomTitle:@"" withCustomImageName:@""];
        if(!sections||sections.count==0){
            self.dataEmptyView.hidden = false;
        }else{
            self.dataEmptyView.hidden = true;
        }
    }
    if (sections.count > 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.dataEmptyView.hidden = true;
        self.lastSectionArr = lastSectionArr;
        
        self.lastSectionSumArr = [NSMutableArray array];
        [self.lastSectionSumArr addObjectsFromArray:lastSectionSumArr];
        
        [self.sections removeAllObjects];
        [self.sections addObjectsFromArray:sections];
        
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        self.tableView.mj_footer.hidden = NO;
        if (lastSectionArr.count == 0) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            self.tableView.mj_footer.hidden = YES;
        }
        
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
//        self.tableView.mj_footer.hidden = YES;//in 2 ways, footer no request
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

#pragma mark - <UITableViewDataSource, UITableViewDelegate>
#pragma mark - Sectons
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _sections.count;
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
//    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    return [(_sections[section])[kIndexRow] count];
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }

    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    switch (type) {
        case IndexSectionOne:{
            NSDictionary* model = (NSDictionary*)(_sections[section]);
            return 0.1f;//[HomeSectionHeaderView viewHeight:model];
        }
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section >= _sections.count) {
        section = _sections.count - 1;
    }
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];

    switch (type) {
        case IndexSectionOne:{
//            NSDictionary* model = (NSDictionary*)(_sections[section]);
//            HomeSectionHeaderView * sectionHeaderView = (HomeSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:HomeSectionHeaderViewReuseIdentifier];
//            [sectionHeaderView richElementsInViewWithModel:model];
            return  [UIView new];
        }
            break;

        default:
            return [UIView new];
            break;
    }
}

#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    switch (type) {
        case IndexSectionZero:
            return 0.1f;
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    WS(weakSelf);
    
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
            
        case IndexSectionOne:
        {
            ZMCusCommentListContentCell *cell = [ZMCusCommentListContentCell cellWith:tableView];
            [cell configData:itemData withSource:self.s];
            [cell actionBlock:^(id data) {
                NSString* s = @"";
                if (self.replyBtnBlock) {
                    self.replyBtnBlock(@{s:data});
                }
            }];
            return cell;
            
        }
            break;
        default:{
//            BaseCell *cell = [BaseCell cellWith:tableView];
//            cell.hideSeparatorLine = YES;
//            cell.frame = CGRectZero;
//            return cell;
       static NSString *name=@"defaultCell";
                               
       UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:name];
           
       if (cell==nil) {
           cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:name];
       }
       cell.selectionStyle=UITableViewCellSelectionStyleNone;
       cell.frame = CGRectZero;

       return cell;
        }
            break;
    }
}

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSInteger section = indexPath.section;
//    if(section >= _sections.count)
//    section = _sections.count - 1;
//
//    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
//    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
//    switch (type) {
//
//        case IndexSectionOne:
//            return [MyShareCell cellHeightWithModel];
//            break;
//
//        default:
//            return 0;
//            break;
//    }
    
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
        section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //防止重复点击
    if (!self.isSelect) {
        self.isSelect = YES;
        [self performSelector:@selector(repeatDelay) withObject:nil afterDelay:1.0f];
        
        self.toolView.textView.placeholder = @"回复：愤怒的小栗子";
//        self.toolView.textView.text = [NSString stringWithFormat:@"回复 %@：",@"愤怒的小栗子"];
        [self.toolView showTextView];
        
        
        

        NSString* s = @"回复：愤怒的小栗子";
        if (self.replyBtnBlock) {
            self.replyBtnBlock(@{s:itemData});
        }
    }
}
- (void)repeatDelay{
    self.isSelect = NO;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        
        //    CGFloat tableHeight  = MAINSCREEN_HEIGHT - CGRectGetMaxY(self.headerView.frame) - YBFrameTool.safeAdjustTabBarHeight - ZMCusComentBottomViewHeight-YBFrameTool.safeAdjustNavigationBarHeight;
            _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];//CGRectMake(0, CGRectGetMaxY(self.headerView.frame), MAINSCREEN_WIDTH, tableHeight)
        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator=NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 10000;
        
//        _tableView.tableHeaderView = self.hv;
//        _tableView.tableFooterView = self.fv;
//        [HomeSectionHeaderView sectionHeaderViewWith:_tableView];
//        [_tableView registerClass:[HomeSectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"HomeSectionHeaderView"];
       kWeakSelf(self);
       [_tableView addMJHeaderWithBlock:^{
                    kStrongSelf(self);
                    self.currentPage = 1;
                    [self requestHomeListWithPage:self.currentPage WithCid:1];
        }];
        
       [_tableView addMJFooterWithBlock:^{
                    kStrongSelf(self);
                    ++self.currentPage;
           [self requestHomeListWithPage:self.currentPage WithCid:1];
        }];
    }
    return _tableView;
}

- (UIView *)hv {
    if (!_hv) {
        _hv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 50+20+YBFrameTool.statusBarHeight)];
        
        _hv.backgroundColor = [UIColor clearColor];
        
        UIButton *icon0 = [[UIButton alloc]init];
        [icon0
         setImage:[UIImage imageNamed:@"home_top_img"] forState:0];
        [icon0 setBackgroundColor:kClearColor];
        icon0.adjustsImageWhenHighlighted = NO;
        [_hv addSubview:icon0];
        [icon0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.top.mas_equalTo(YBFrameTool.statusBarHeight);
            make.centerX.mas_equalTo(self.hv);
            make.height.mas_equalTo(20);
        }];
        
        NSInteger topMar = 20+YBFrameTool.statusBarHeight;
        self.hHV = [[HomeHV alloc]initWithFrame:CGRectZero InSuperView:_hv withTopMargin:-topMar];
        
    }
    return _hv;
}

- (UIView *)fv {
    if (!_fv) {
        _fv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 50+20+YBFrameTool.iphoneBottomHeight)];
        
        _fv.backgroundColor = [UIColor clearColor];
        
        UIButton *icon0 = [[UIButton alloc]init];
        [icon0
         setImage:[UIImage imageNamed:@"home_top_img"] forState:0];
        [icon0 setBackgroundColor:kClearColor];
        icon0.adjustsImageWhenHighlighted = NO;
        [_fv addSubview:icon0];
        [icon0 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.bottom.mas_equalTo(-YBFrameTool.iphoneBottomHeight);
            make.centerX.mas_equalTo(self.fv);
            make.height.mas_equalTo(20);
        }];
        
        NSInteger topMar = 20+YBFrameTool.iphoneBottomHeight;
        self.hFV = [[HomeFV alloc]initWithFrame:CGRectZero InSuperView:_fv withTopMargin:-topMar];
        
    }
    return _fv;
}

- (NSUInteger)currentPage {
    if (!_currentPage) {
        _currentPage = 0;
    }
    return _currentPage;
}

- (NSMutableArray *)sections {
    if (!_sections) {
        _sections = [NSMutableArray array];
    }
    return _sections;
}

- (HomeVM *)vm {
    if (!_vm) {
        _vm = [HomeVM new];
    }
    return _vm;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
