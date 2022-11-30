//
//  NewDynamicsViewController.h
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/27.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MineVM.h"
@interface NewDynamicsVC : BaseVC
@property (nonatomic, strong) HomeModel* myModel;
@property(nonatomic,assign)BOOL isFromAvatar;
@property(nonatomic,copy)NSString * dynamicsUserId;
@property(nonatomic,strong)UITableView * dynamicsTable;
@property(nonatomic,strong)NSMutableArray * layoutsArr;
@property(nonatomic,copy)NSString * toUserName;
@property(nonatomic,assign)NSIndexPath * commentIndexPath;
@property(nonatomic,strong)UITextField * commentInputTF;
@property(nonatomic,assign)BOOL isStatusBarHidden;
- (void) requestHomeListWithPage:(NSInteger)page WithDict:(NSDictionary*)dict;
-(void)richOnlyElementsInCellWithModel:(id)model;
@end
