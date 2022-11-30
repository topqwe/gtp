//
//  NewDynamicsViewController.h
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/27.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WTBottomInputView.h"
#import "HomeSectionHeaderView.h"
@interface NewDynamicsDetailVC : BaseVC
@property (nonatomic, strong) DynamicsModel* requestParams;
@property (nonatomic, strong) HomeModel* myModel;
@property (nonatomic, strong) SuperPlayerView* playerView;
@property (nonatomic, assign) NSInteger  cid;
@property (nonatomic, strong) HomeVM *vm;
@property (nonatomic, strong) WTBottomInputView * bottomView;
@property(nonatomic,copy)NSString * dynamicsUserId;
@property(nonatomic,strong)UITableView * dynamicsTable;
@property (nonatomic, strong) NSMutableArray *sections;
@property(nonatomic,strong)NSMutableArray * layoutsArr;
@property(nonatomic,copy)NSString * toUserName;
@property(nonatomic,assign)NSIndexPath * commentIndexPath;
@property(nonatomic,strong)UITextField * commentInputTF;

- (void) requestHomeListWithPage:(NSInteger)page WithCid:(NSInteger)cid;
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block;
@end
