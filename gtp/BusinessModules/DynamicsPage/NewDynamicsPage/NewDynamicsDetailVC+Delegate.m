//
//  NewDynamicsViewController+Delegate.m
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/28.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import "NewDynamicsDetailVC+Delegate.h"
#import "ChatListController.h"
@implementation NewDynamicsDetailVC (Delegate)
#pragma mark - <UITableViewDataSource, UITableViewDelegate>
#pragma mark - Sectons
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sections.count;
}
#pragma mark - Rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section >= self.sections.count) {
        section = self.sections.count - 1;
    }
//    IndexSectionType type = [(_sections[section])[kIndexSection] integerValue];
    return [(self.sections[section])[kIndexRow] count];
}

#pragma mark - SectonHeader
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section >= self.sections.count) {
        section = self.sections.count - 1;
    }

    IndexSectionType type = [(self.sections[section])[kIndexSection] integerValue];
    switch (type) {
//        case IndexSectionMinusOne:
//        case IndexSectionZero:
//            {
//                NSDictionary* model = (NSDictionary*)(_sections[section]);
//                return 20.1f;//[HomeSectionHeaderView viewHeight:model];
//            }
//                break;
        case IndexSectionOne:{
            NSDictionary* model = (NSDictionary*)(self.sections[section]);
            NSArray* arr = (NSArray*)(model[kIndexRow]);
            if (arr.count==0) {
                return 0.1f;
            }else{
                return [HomeSectionHeaderView viewHeight:model];
            }
            
        }
            break;
        default:
            return 0.1f;
            break;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section >= self.sections.count) {
        section = self.sections.count - 1;
    }
    IndexSectionType type = [(self.sections[section])[kIndexSection] integerValue];

    switch (type) {
//        case IndexSectionMinusOne:
//        case IndexSectionZero:
        case IndexSectionOne:{
            NSDictionary* model = (NSDictionary*)(self.sections[section]);
            HomeSectionHeaderView * sectionHeaderView = (HomeSectionHeaderView *)[self.dynamicsTable dequeueReusableHeaderFooterViewWithIdentifier:HomeSectionHeaderViewReuseIdentifier];
            [sectionHeaderView richElementsInViewWithModel:model];
            NSArray* arr = (NSArray*)(model[kIndexRow]);
            if (arr.count==0) {
                sectionHeaderView.hidden = YES;
            }else{
                sectionHeaderView.hidden = NO;
            }
            return  sectionHeaderView;
        }
            break;

        default:
            return [UIView new];
            break;
    }
}

#pragma mark - SectonFooter
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section >= self.sections.count) {
        section = self.sections.count - 1;
    }
    
    IndexSectionType type = [(self.sections[section])[kIndexSection] integerValue];
    
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
    if(section >= self.sections.count)
    section = self.sections.count - 1;
    
    IndexSectionType type = [self.sections[section][kIndexSection] integerValue];
    id itemData = ((self.sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
            
            case IndexSectionZero:
            {
                NewDynamicsTableViewCell * cell = [NewDynamicsTableViewCell cellWith:tableView];
                cell.myModel = self.myModel;
                cell.layout = itemData;
                cell.layout.model.state =  self.requestParams.state;
                cell.delegate = self;
                if (!cell.playerView.hidden) {
                    cell.coverImageView.hidden = YES;
                    cell.playerView.autoPlay = YES;
                    [cell.playerView resume];
                    self.playerView = cell.playerView;
                }
                [cell actionBlock:^(UIButton* data,id data2) {
                    switch (data.tag) {
                        case 0:
                        case 2:
                        {
                            NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
                            if (indexPath) {
                                [self.dynamicsTable reloadRowsAtIndexPaths:[NSArray st_safeArrayWithValue:@[indexPath]] withRowAnimation:UITableViewRowAnimationNone];
                            }
                        }
                            break;
                        case 1:
                        {
                            [self.bottomView.textView becomeFirstResponder];
                        }
                            break;
                            
                        default:
                            break;
                    }
                }];
//                [self.layoutsArr addObjectsFromArray:((self.sections[section])[kIndexRow])];
                return cell;
                
            }
                break;
        case IndexSectionOne:
        {
            ZMCusCommentListContentCell *cell = [ZMCusCommentListContentCell cellWith:tableView];
            [cell configData:itemData withSource:0];
            [cell actionBlock:^(id data) {
//                NSString* s = @"";
//                if (self.replyBtnBlock) {
//                    self.replyBtnBlock(@{s:data});
//                }
            }];
            return cell;
            
        }
            break;
        default:{
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
    NSInteger section = indexPath.section;
    if(section >= self.sections.count)
    section = self.sections.count - 1;
    
    IndexSectionType type = [self.sections[section][kIndexSection] integerValue];
    id itemData = ((self.sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
            return [NewDynamicsTableViewCell cellHeightWithModel:itemData];
            break;
        case IndexSectionOne:
            return UITableViewAutomaticDimension;
            break;
            
        default:
            return 0;
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    if(section >= self.sections.count)
        section = self.sections.count - 1;
    
    IndexSectionType type = [self.sections[section][kIndexSection] integerValue];
    id itemData = ((self.sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        
        case IndexSectionOne:
        {
            
        }
            break;
        default:
            
            break;
    }
}
/**
 设置评论的头
 */
- (void)setupTableViewHeader
{    //这里要给cell添加一个父控件，为了不让cell高度减少
    UIView *view = [[UIView alloc] init];

    NewDynamicsTableViewCell *cell = [NewDynamicsTableViewCell cellWith:self.dynamicsTable];
    cell.layout = self.layoutsArr.firstObject;
    cell.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, [NewDynamicsTableViewCell cellHeightWithModel:cell.layout]);
    cell.delegate = self;
    [view addSubview:cell];
    //这个父控件的高度就等于cell的高度
    [view setHeight:cell.frame.size.height];
    
    self.dynamicsTable.tableHeaderView = view;
}
#pragma mark - ScollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [JRMenuView dismissAllJRMenu];//收回JRMenuView
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.bottomView.textView resignFirstResponder];
    [self.commentInputTF resignFirstResponder];
}
#pragma mark - NewDynamiceCellDelegate
-(void)DynamicsCell:(NewDynamicsTableViewCell *)cell didClickUser:(NSString *)userId
{
    NSLog(@"点击了用户");
    NewDynamicsVC* nw  =[NewDynamicsVC new];
    nw.isFromAvatar = YES;
    [nw requestHomeListWithPage:1 WithDict:@{@"id":userId}];
    [self.navigationController pushViewController:nw animated:YES];
}
//- (BOOL)prefersStatusBarHidden
//{
////    return YES;//隐藏为YES，显示为NO//plist必须yes
//    return self.playerView.isFullScreen;
//
//}
-(void)DidClickVideoInDynamicsCell:(NewDynamicsTableViewCell *)cell{
//    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
//    [self tableView:self.dynamicsTable didSelectRowAtIndexPath:indexPath];
//    cell.coverImageView.hidden = YES;
//    [cell.playerView resume];
}
-(void)DidClickChatInDynamicsCell:(NewDynamicsTableViewCell *)cell{
    
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NSInteger section = indexPath.section;
    if(section >= self.sections.count)
    section = self.sections.count - 1;
    
    IndexSectionType type = [self.sections[section][kIndexSection] integerValue];
    id itemData = ((self.sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
            {
                NewDynamicsLayout * layout = itemData;
                if([layout.model.state isEqualToString:@"1"]){
                    [WebViewController pushFromVC:self requestUrl:[UserInfoManager GetNSUserDefaults].data.kf_url  withProgressStyle:DKProgressStyle_Gradual success:^(id data) {

                    }];
                }else{
                NewDynamicsLayout * layout = itemData;
                [ChatListController pushFromVC:self requestParams:@{[NSString stringWithFormat:@"%@",layout.model.nickname]:layout.model.uid} success:^(id data) {
                                    
                }];
                }
                
            }
            break;
            
        default:
            break;
    }
}
-(void)DidClickMoreLessInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NSInteger section = indexPath.section;
    if(section >= self.sections.count)
    section = self.sections.count - 1;
    
    IndexSectionType type = [self.sections[section][kIndexSection] integerValue];
    id itemData = ((self.sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
            {
                NewDynamicsLayout * layout = itemData;
                layout.model.isOpening = !layout.model.isOpening;
                [layout resetLayout];
                CGRect cellRect = [self.dynamicsTable rectForRowAtIndexPath:indexPath];

                [self.dynamicsTable reloadData];

                if (cellRect.origin.y < self.dynamicsTable.contentOffset.y + 64) {
                    [self.dynamicsTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }
            break;
            
        default:
            break;
    }
//    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
//    layout.model.isOpening = !layout.model.isOpening;
//    [layout resetLayout];
//    CGRect cellRect = [self.dynamicsTable rectForRowAtIndexPath:indexPath];
//
//    [self.dynamicsTable reloadData];
//
//    if (cellRect.origin.y < self.dynamicsTable.contentOffset.y + 64) {
//        [self.dynamicsTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
//    }
}
-(void)DidClickGrayViewInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSLog(@"点击了灰色区域");
}

-(void)DidClickThunmbInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    
    NSInteger section = indexPath.section;
    if(section >= self.sections.count)
    section = self.sections.count - 1;
    
    IndexSectionType type = [self.sections[section][kIndexSection] integerValue];
    id itemData = ((self.sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
            {
                NewDynamicsLayout * layout = itemData;
                DynamicsModel * model = layout.model;

                NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"12345678910",@"userid",@"Andy",@"nick", nil];
                NSMutableArray * newThumbArr = [NSMutableArray arrayWithArray:model.optthumb];
                [newThumbArr addObject:dic];
                model.optthumb = [newThumbArr copy];
                [layout resetLayout];
                [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            break;
            
        default:
            break;
    }
//    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
//    DynamicsModel * model = layout.model;
//
//    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"12345678910",@"userid",@"Andy",@"nick", nil];
//    NSMutableArray * newThumbArr = [NSMutableArray arrayWithArray:model.optthumb];
//    [newThumbArr addObject:dic];
//    model.optthumb = [newThumbArr copy];
//    [layout resetLayout];
//    [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)DidClickCancelThunmbInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    
    NSInteger section = indexPath.section;
    if(section >= self.sections.count)
    section = self.sections.count - 1;
    
    IndexSectionType type = [self.sections[section][kIndexSection] integerValue];
    id itemData = ((self.sections[section])[kIndexRow])[indexPath.row];
    switch (type) {
        case IndexSectionZero:
            {
                NewDynamicsLayout * layout = itemData;
                DynamicsModel * model = layout.model;

                NSMutableArray * newThumbArr = [NSMutableArray arrayWithArray:model.optthumb];
                WS(weakSelf);
                [newThumbArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSDictionary * thumbDic = obj;
                    if ([thumbDic[@"userid"] isEqualToString:@"12345678910"]) {
                        [newThumbArr removeObject:obj];
                        model.optthumb = [newThumbArr copy];
                        [layout resetLayout];
                        [weakSelf.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                        *stop = YES;
                    }
                }];
            }
            break;
            
        default:
            break;
    }
    
//    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
//    DynamicsModel * model = layout.model;
//
//    NSMutableArray * newThumbArr = [NSMutableArray arrayWithArray:model.optthumb];
//    WS(weakSelf);
//    [newThumbArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSDictionary * thumbDic = obj;
//        if ([thumbDic[@"userid"] isEqualToString:@"12345678910"]) {
//            [newThumbArr removeObject:obj];
//            model.optthumb = [newThumbArr copy];
//            [layout resetLayout];
//            [weakSelf.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            *stop = YES;
//        }
//    }];
}
-(void)DidClickCommentInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    self.commentIndexPath = indexPath;

    self.commentInputTF.placeholder = @"输入评论...";
    [self.commentInputTF becomeFirstResponder];
    self.commentInputTF.hidden = NO;
}
-(void)DidClickSpreadInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSLog(@"点击了推广");
}
- (void)DidClickDeleteInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    WS(weakSelf);
    
    [self.view showAlertView:@"是否确定删除" ok:^(UIAlertAction * _Nonnull action) {
        NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
        
        
        NSInteger section = indexPath.section;
        if(section >= self.sections.count)
        section = self.sections.count - 1;
        
        IndexSectionType type = [self.sections[section][kIndexSection] integerValue];
        NSMutableArray* itemDatas = [NSMutableArray arrayWithArray:((self.sections[section])[kIndexRow])];
        switch (type) {
            case IndexSectionZero:
                {
                    [SVProgressHUD showSuccessWithStatus:@"删除成功!"];
                    [weakSelf.dynamicsTable beginUpdates];
                    [itemDatas removeObjectAtIndex:indexPath.row];
                    [weakSelf.dynamicsTable deleteRowsAtIndexPaths:[NSMutableArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    if (itemDatas.count<=0) {
                        [self.sections removeObjectAtIndex:indexPath.section];

                        [weakSelf.dynamicsTable deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
                    }
                    
                    [weakSelf.dynamicsTable endUpdates];
//                    [weakSelf.dynamicsTable reloadData];
            
                    [SVProgressHUD dismissWithDelay:1];
                }
                break;
                
            default:
                break;
        }
        
//        [SVProgressHUD showSuccessWithStatus:@"删除成功!"];
//        [weakSelf.dynamicsTable beginUpdates];
//        [weakSelf.layoutsArr removeObjectAtIndex:indexPath.row];
//        [weakSelf.dynamicsTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//        [weakSelf.dynamicsTable endUpdates];
//        [SVProgressHUD dismissWithDelay:1];
        
    } cancel:^(UIAlertAction * _Nonnull action) {
            
        }];
    
    
}
-(void)DynamicsCell:(NewDynamicsTableViewCell *)cell didClickUrl:(NSString *)url PhoneNum:(NSString *)phoneNum
{
    if (url) {
        if ([url rangeOfString:@"wemall"].length != 0 || [url rangeOfString:@"t.cn"].length != 0) {
            if (![url hasPrefix:@"http://"]) {
                url = [NSString stringWithFormat:@"http://%@",url];
            }
            NSLog(@"点击了链接:%@",url);
        }else{
            [SVProgressHUD showErrorWithStatus:@"暂不支持打开外部链接"];
        }
    }
    if (phoneNum) {
        NSLog(@"点击了电话:%@",phoneNum);
    }
}
#pragma mark - UITextfield Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSInteger commentRow = self.commentIndexPath.row;
    
    NSInteger section = self.commentIndexPath.section;
    if(section >= self.sections.count)
    section = self.sections.count - 1;
    
    IndexSectionType type = [self.sections[section][kIndexSection] integerValue];
    id itemDatas = ((self.sections[section])[kIndexRow]);
    switch (type) {
        case IndexSectionZero:
            {
                
                NewDynamicsLayout * layout = [itemDatas objectAtIndex:commentRow];
                DynamicsModel * model = layout.model;
                if (![self.commentInputTF.text isEqualToString:@""]) {

                    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"12345678910",@"userid",@"andy",@"nick",textField.text,@"message",nil,@"touser",nil,@"tonick", nil];//toUserID可能为nil,需放在最后
                    NSMutableArray * newCommentArr = [NSMutableArray arrayWithArray:model.optcomment];
                    [newCommentArr addObject:dic];
                    model.optcomment = [newCommentArr copy];
                    [layout resetLayout];
                    [self.dynamicsTable reloadRowsAtIndexPaths:@[self.commentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
                    
                    self.commentInputTF.text = nil;
                    [self.commentInputTF resignFirstResponder];
                }
                return YES;
            }
            break;
            
        default:
            return YES;
            break;
    }
//    NewDynamicsLayout * layout = [self.layoutsArr objectAtIndex:commentRow];
//    DynamicsModel * model = layout.model;
//    if (![self.commentInputTF.text isEqualToString:@""]) {
//
//        NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"12345678910",@"userid",@"andy",@"nick",textField.text,@"message",nil,@"touser",nil,@"tonick", nil];//toUserID可能为nil,需放在最后
//        NSMutableArray * newCommentArr = [NSMutableArray arrayWithArray:model.optcomment];
//        [newCommentArr addObject:dic];
//        model.optcomment = [newCommentArr copy];
//        [layout resetLayout];
//        [self.dynamicsTable reloadRowsAtIndexPaths:@[self.commentIndexPath] withRowAnimation:UITableViewRowAnimationNone];
//
//        self.commentInputTF.text = nil;
//        [self.commentInputTF resignFirstResponder];
//    }
//    return YES;
}

- (void)WTBottomInputViewSendTextMessage:(NSString *)message
{
    NSLog(@"=======>>%@",message);
    
    NSMutableDictionary * paramDic = [NSMutableDictionary dictionary];
    paramDic[@"content"] = message;
    paramDic[@"bbs_id"] = @(self.cid);
    
//    [_dataSource insertObject:paramDic atIndex:0];
//    [_tableView reloadData];
//    [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType63] andType:All andWith:paramDic success:^(NSDictionary *dic) {
        HomeModel* model = [HomeModel mj_objectWithKeyValues:dic];
        if ([NSString getDataSuccessed:dic]) {
            
//            NSArray* arr = @[];
//            arr = [HomeItem mj_objectArrayWithKeyValuesArray:dic[@"data"]];
            
            
//            success(weakSelf.model);
            [self requestHomeListWithPage:1 WithCid:self.cid];
        }
        else{
               NSLog(@".......dataErr");
//               failed(@"dataErr");
            }
        [YKToastView showToastText:[NSString stringWithFormat:@"%@",model.msg]];
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
//            failed(@"servicerErr");
        }];
    
    self.bottomView.textView.text = @"";
    [self.bottomView.textView resignFirstResponder];
    [self.view endEditing:YES];
}
-(void)dealloc{
    if (self.playerView) {
        [self.playerView resetPlayer];
    }
}
@end
