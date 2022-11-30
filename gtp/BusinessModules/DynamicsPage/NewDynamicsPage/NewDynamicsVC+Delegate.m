//
//  NewDynamicsViewController+Delegate.m
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/28.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import "NewDynamicsVC+Delegate.h"
#import "NewDynamicsDetailVC.h"
#import "ChatListController.h"
@implementation NewDynamicsVC (Delegate)

#pragma mark - TableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    return [NewDynamicsTableViewCell cellHeightWithModel:layout];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.layoutsArr.count;
}
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    NewDynamicsTableViewCell * fcell  = (id)cell;
    [fcell.playerView pause];
    fcell.playerView.playerConfig.mute = YES;
//    fcell.playerView.mute = YES;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewDynamicsTableViewCell * cell = [NewDynamicsTableViewCell cellWith:tableView];
    cell.myModel = self.myModel;
    cell.layout = self.layoutsArr[indexPath.row];
    cell.layout.model.state = self.myModel.state;
    cell.delegate = self;
    cell.playerView.hidden = YES;
    [cell.playerView pause];
    cell.playerView.playerConfig.mute = YES;
    cell.playerView.isLockScreen = YES;
//    [cell.playerView resetPlayer];
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
                [NewDynamicsDetailVC pushFromVC:self requestParams:data2 success:^(id data) {

                }];
            }
                break;
                
            default:
                break;
        }
    }];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [JRMenuView dismissAllJRMenu];
    if(!self.myModel.data.member_card.is_vip){
        [YKToastView showToastText:@"只有VIP用户才可以哦"];
        return;
    }
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    [NewDynamicsDetailVC pushFromVC:self requestParams:layout.model success:^(id data) {

    }];
}
#pragma mark - ScollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [JRMenuView dismissAllJRMenu];//收回JRMenuView
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
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
-(void)DidClickChatInDynamicsCell:(NewDynamicsTableViewCell *)cell{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    if([cell.myModel.state isEqualToString:@"1"]){
        [WebViewController pushFromVC:self requestUrl:[UserInfoManager GetNSUserDefaults].data.kf_url  withProgressStyle:DKProgressStyle_Gradual success:^(id data) {

        }];
    }else{
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    [ChatListController pushFromVC:self requestParams:@{[NSString stringWithFormat:@"%@",layout.model.nickname]:layout.model.uid} success:^(id data) {
                        
    }];
    }
                
}

-(void)DidClickContentInDynamicsCell:(NewDynamicsTableViewCell *)cell{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    [self tableView:self.dynamicsTable didSelectRowAtIndexPath:indexPath];
}
//- (BOOL)prefersStatusBarHidden
//{
////    return YES;//隐藏为YES，显示为NO//plist必须yes
//    return self.isStatusBarHidden;
//
//}
-(void)DidClickVideoInDynamicsCell:(NewDynamicsTableViewCell *)cell{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    [self tableView:self.dynamicsTable didSelectRowAtIndexPath:indexPath];
//    cell.coverImageView.hidden = YES;
//    [cell.playerView resume];
//    self.isStatusBarHidden = cell.playerView.isFullScreen;
    
}

-(void)DidClickMoreLessInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    [self tableView:self.dynamicsTable didSelectRowAtIndexPath:indexPath];
    return;
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    layout.model.isOpening = !layout.model.isOpening;
    [layout resetLayout];
    CGRect cellRect = [self.dynamicsTable rectForRowAtIndexPath:indexPath];

    [self.dynamicsTable reloadData];

    if (cellRect.origin.y < self.dynamicsTable.contentOffset.y + 64) {
        [self.dynamicsTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
-(void)DidClickGrayViewInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSLog(@"点击了灰色区域");
}

-(void)DidClickThunmbInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
    DynamicsModel * model = layout.model;

    NSMutableDictionary * dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"12345678910",@"userid",@"Andy",@"nick", nil];
    NSMutableArray * newThumbArr = [NSMutableArray arrayWithArray:model.optthumb];
    [newThumbArr addObject:dic];
    model.optthumb = [newThumbArr copy];
    [layout resetLayout];
    [self.dynamicsTable reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}
-(void)DidClickCancelThunmbInDynamicsCell:(NewDynamicsTableViewCell *)cell
{
    NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
    NewDynamicsLayout * layout = self.layoutsArr[indexPath.row];
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
    
    [self.view showAlertView:@"是否确定删除朋友圈" ok:^(UIAlertAction * _Nonnull action) {
        NSIndexPath * indexPath = [self.dynamicsTable indexPathForCell:cell];
        [SVProgressHUD showSuccessWithStatus:@"删除成功!"];
        [weakSelf.dynamicsTable beginUpdates];
        [weakSelf.layoutsArr removeObjectAtIndex:indexPath.row];
        [weakSelf.dynamicsTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf.dynamicsTable endUpdates];
        [SVProgressHUD dismissWithDelay:1];
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
    NewDynamicsLayout * layout = [self.layoutsArr objectAtIndex:commentRow];
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
@end
