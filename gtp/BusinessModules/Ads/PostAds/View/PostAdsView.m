//
//  PostAdsView.m
//  HHL
//
//  Created by WIQ on 2018/11/19.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "PostAdsView.h"
#import "PostAdsTypeCell.h"
#import "PostAdsSlideCell.h"
#import "PostAdsPaysCell.h"
#import "PostAdsReplyCell.h"
#import "PostAdsRestrictCell.h"
#import "BaseCell.h"

#import "PostAdsFV.h"

#import "PostAdsSectionHeaderView.h"

#import "HomeVM.h"
#import "InputPWPopUpView.h"

@interface PostAdsView () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSUInteger currentPage;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) PostAdsFV* pafv;
@property (nonatomic, copy) ActionBlock block;
@end

@implementation PostAdsView

#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = kWhiteColor;
        [self initViews];
        
        [self.tableView.mj_header beginRefreshing];
        
        
    }
    return self;
}

- (void)initViews {
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

#pragma mark - public
- (void)requestListSuccessWithArray:(NSArray *)array {
    
    if (array.count > 0) {
        if (self.currentPage == 0) {
            [self.sections removeAllObjects];
        }
        [self.sections addObjectsFromArray:array];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView.mj_header endRefreshing];
    _pafv = [[PostAdsFV alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 194) WithModel:@[@"需要",@"不与",@"同意"]];
    WS(weakSelf);
    [_pafv actionBlock:^(id data) {
//        if (weakSelf.block) {
//            weakSelf.block(data);
//        }
        EnumActionTag btnType  = [data integerValue];
        switch (btnType) {
                
            case EnumActionTag4:
            {//post
                InputPWPopUpView* popUpView = [[InputPWPopUpView alloc]init];
//                [popUpView richElementsInCellWithModel:nil];
                [popUpView showInView:self];
                [popUpView actionBlock:^(id data) {
                    if (weakSelf.block) {
                        weakSelf.block(data);
                    }

                }];
            }
                break;
                
            default:{
                if (weakSelf.block) {
                    weakSelf.block(data);
                }
            }
                
                break;
        }
        
    }];

    _tableView.tableFooterView = _pafv;
    _tableView.tableFooterView.backgroundColor = kWhiteColor;
}

- (void)requestListFailed {
    self.currentPage = 0;
    [self.sections removeAllObjects];
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
        case IndexSectionZero:
            return 5;
            break;
        case IndexSectionTwo:
        case IndexSectionThree:
        case IndexSectionFour:
            return [PostAdsSectionHeaderView viewHeight];
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
    
    NSString *sectionTitle = @"";
    NSString *sectionSubTitle = @"";
    
//    id sectionData = (_sections[section])[kIndexRow][0];
    
    switch (type) {
        case IndexSectionTwo:
        case IndexSectionThree:
        case IndexSectionFour: {
            NSArray* arr = (NSArray*)(_sections[section])[kIndexInfo];
            sectionTitle =  arr[0];
            sectionSubTitle = arr[1];
            WS(weakSelf) ;
            
            PostAdsSectionHeaderView * sectionHeaderView = (PostAdsSectionHeaderView *)[_tableView dequeueReusableHeaderFooterViewWithIdentifier:PostAdsSectionHeaderReuseIdentifier];
            [sectionHeaderView setDataWithType:type withTitle:sectionTitle withSubTitle:sectionSubTitle];
            sectionHeaderView.clickSectionBlock = ^(NSString* sec){
                [weakSelf sectionHeaderSubBtnClickTag:sec];
            };
            //    sectionHeaderView.delegate =self;
            return sectionHeaderView;
        }
            break;
        
        default:
            return [UIView new];
            break;
            
    }
    
}

- (void)sectionHeaderSubBtnClickTag:(NSString* )sec{
//    HomeMoreVC *moreVc = [[HomeMoreVC alloc] init];
//    moreVc.moreEnterType = Others;
//    moreVc.naviTitle = sec;
//    moreVc.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:moreVc animated:YES];
  
}
#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
    switch (type) {
        case IndexSectionZero:
        case IndexSectionOne:
            return 5.f;
            break;
        case IndexSectionTwo:
        case IndexSectionThree:
        case IndexSectionFour:
            return 14.f;
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section >= _sections.count) {
        section = _sections.count - 1;
    }
    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    
//        NSString *sectionTitle = @"";
//        NSString *sectionSubTitle = @"";
//
    
//        id sectionData = (_sections[section])[kIndexRow][0];
    
    switch (type) {
        case IndexSectionTwo:
        case IndexSectionThree:
        case IndexSectionFour:
        {
            UIView* sectionFooterView= [[UIView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 14.f)];
        sectionFooterView.backgroundColor = kWhiteColor;

            return sectionFooterView;
        }
            break;
        default:{

            return nil;
        }
            break;

    }
    
    return nil;
}
#pragma mark - cellForRow
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
        {
            PostAdsTypeCell *cell = [PostAdsTypeCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData];
            return cell;
            
        }
            break;
        case IndexSectionOne:
        {
            PostAdsSlideCell *cell = [PostAdsSlideCell cellWith:tableView];
            [cell richElementsInCellWithModel:itemData];
//            cell.clickGridRowBlock = ^(NSDictionary *dataModel) {
//                [weakSelf onGridCellClick:dataModel];
//            };
            
            return cell;
            
        }
            break;
        case IndexSectionTwo:
        {
            PostAdsPaysCell *cell = [PostAdsPaysCell cellWith:tableView];
            
            NSDictionary* paysDic = (NSDictionary*)itemData;
//            WData* wData = (WData*)itemData;
            [cell richElementsInCellWithModel:paysDic];
            [cell actionBlock:^(id data) {
                NSLog(@"seletedSwitchs %@",data);
            }];

            return cell;
            
        }
            break;
        case IndexSectionThree:
        {
            PostAdsReplyCell *cell = [PostAdsReplyCell cellWith:tableView];
            
            NSDictionary* paysDic = (NSDictionary*)itemData;
            //            WData* wData = (WData*)itemData;
            [cell richElementsInCellWithModel:paysDic];
            
            return cell;
            
        }
            break;
        case IndexSectionFour:
        {
            PostAdsRestrictCell *cell = [PostAdsRestrictCell cellWith:tableView];
            
            NSDictionary* paysDic = (NSDictionary*)itemData;
            //            WData* wData = (WData*)itemData;
            [cell richElementsInCellWithModel:paysDic];
            
            return cell;
            
        }
            break;
        default:{
            BaseCell *cell = [BaseCell cellWith:tableView];
            cell.hideSeparatorLine = YES;
            cell.frame = CGRectZero;
            return cell;
        }
            break;
    }
}

#pragma mark - heightForRow
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger section = indexPath.section;
    if(section >= _sections.count)
    section = _sections.count - 1;
    
    IndexSectionType type = [_sections[section][kIndexSection] integerValue];
    id itemData = ((_sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
            return [PostAdsTypeCell cellHeightWithModel];
            break;
            
        case IndexSectionOne:
            return [PostAdsSlideCell cellHeightWithModel];
            break;
        case IndexSectionTwo:
        {
            return [PostAdsPaysCell cellHeightWithModel:itemData];
        }
            break;
        case IndexSectionThree:
        {
            return [PostAdsReplyCell cellHeightWithModel:itemData];
        }
            break;
        case IndexSectionFour:
        {
            return [PostAdsRestrictCell cellHeightWithModel:itemData];
        }
            break;
        default:
            return 0;
            break;
    }
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

#pragma mark - getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
//        [_tableView YBGeneral_configuration];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [PostAdsSectionHeaderView sectionHeaderViewWith:_tableView];
        
       kWeakSelf(self);
        [_tableView YBGeneral_addRefreshHeader:^{
            kStrongSelf(self);
            self.currentPage = 0;
            [self.delegate postAdsView:self requestListWithPage:self.currentPage];
        }
//                                        footer:^{
//            kStrongSelf(self);
//            ++self.currentPage;
//            [self.delegate homeView:self requestHomeListWithPage:self.currentPage];
//        }
         ];
    }
    return _tableView;
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

@end
