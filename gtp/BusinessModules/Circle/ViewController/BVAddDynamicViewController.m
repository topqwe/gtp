//
//  SVFeadBackNewViewController.m
//  sixnineVideo
//
//  Created by Mac on 2019/1/17.
//  Copyright © 2019 猪八戒. All rights reserved.
//

#import "BVAddDynamicViewController.h"
#import "STTextView.h"
@interface BVAddDynamicViewController ()
@property(nonatomic, strong) STTextView                     *textView;/**<  */

@property(nonatomic, strong) TMTagMenuView                     *menuView;/**<  */
@property(nonatomic, strong) TMImageAutoChoseView                     *imageChoseView;/**<  */
@property(nonatomic, strong) NSArray                     *allMenuArray;/**<  */

@property(nonatomic, strong) NSArray                     *imageModelUrlArray;/**<  */

@property(nonatomic, strong) STButton                     *addButton;/**< 地址 */
@property(nonatomic, strong) NSString                     *region_id   ;/**< 地址id */

@property(nonatomic, strong) STButton                     *videoButton;/**<  */
@end

@implementation BVAddDynamicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布";
    [self sendFetchAddRequest];
    [self configSubView];
    // Do any additional setup after loading the view.
}
#pragma mark --subView
- (void)configSubView{
    self.textView = [[STTextView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth - 24 -20, 100 )];
    self.textView.placeholder = @"这一刻的想法 ";
    __weak typeof(self) weakSelf =  self;
    self.imageChoseView = [[TMImageAutoChoseView alloc] initWithFrame:CGRectMake(10, self.textView.bottom+10, UIScreenWidth - 24 -20, 100)];
    [self.imageChoseView setFrameDidChangedHandle:^(TMImageAutoChoseView *autochoseView) {
        weakSelf.imageModelUrlArray = nil;
        [weakSelf configTableFooterView];
    }];
    self.imageChoseView.maxCount = 9;
    self.imageChoseView.addImage = [UIImage imageNamed:@"icon_add_pic"];
    

    [self configTableHeaderView];
    [self configTableFooterView];
    self.tableView.backgroundColor = UIColor.whiteColor;
}
- (void)configTableHeaderView{
    
}
- (void)configTableFooterView{
    __weak typeof(self) weakSelf =  self;
    [self st_autoAdjustAllResponder];
    UIView * footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, 100)];
    footer.backgroundColor = UIColor.whiteColor;
    
    UIView * grawView = [[UIView alloc] initWithFrame:CGRectMake(12, 20, UIScreenWidth - 24, 180)];
    grawView.backgroundColor = TM_backgroundColor;
    [footer addSubview:grawView];
    self.textView.width = grawView.width;
    self.textView.backgroundColor = TM_backgroundColor;
    [grawView addSubview:self.textView];
    
    
    self.imageChoseView.backgroundColor = TM_backgroundColor;
    self.imageChoseView.top = self.textView.bottom;
    
    grawView.height = self.imageChoseView.bottom + 10;
    [grawView addSubview:self.imageChoseView];
    
    if (!self.addButton) {
        STButton * button = [[STButton alloc] initWithFrame:CGRectMake(15, 0, 80, 34)
                                                      title:@"添加地点"
                                                 titleColor:SecendTextColor
                                                  titleFont:12
                                               cornerRadius:17
                                            backgroundColor:self.textView.backgroundColor
                                            backgroundImage:nil
                                                      image:nil];
        [button setClicAction:^(UIButton *sender) {
            [weakSelf onSelctedAddButtton];
        }];
        [footer addSubview:button];
        self.addButton = button;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    }
    self.addButton.top = grawView.bottom + 10;
    [footer addSubview:self.addButton];
    
    STButton * confimButton = [[STButton alloc] initWithFrame:CGRectMake(80, self.addButton.bottom + 40, UIScreenWidth - 160 , 44)
                                                        title:@"发布"
                                                   titleColor:[UIColor whiteColor]
                                                    titleFont:18
                                                 cornerRadius:22
                                              backgroundColor:nil
                                              backgroundImage:nil
                                                        image:nil];
    [confimButton setClicAction:^(UIButton *sender) {
        [weakSelf onSelctedCommitButton];
    }];
    [TMUtils makeViewToThemeGrdualColor:confimButton];
    confimButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [footer addSubview:confimButton];
    
    footer.height = confimButton.bottom;
    self.tableView.tableFooterView = footer;
}
#pragma mark --Action Method
- (void)onSelctedAddButtton{
    if (!self.allMenuArray.count) {
        [self sendFetchAddRequest];
        [SVProgressHUD showInfoWithStatus:@"正在加载"];
    }else{
        NSArray * array = [self.allMenuArray st_arrayFromObjKeyName:@"obj.name"];
        array = [array subarrayWithRange:NSMakeRange(1, array.count-2)];
        STPickerViewController * vc = [[STPickerViewController alloc] initWithPickerArray:@[array] andWithHandle:^(NSArray<NSString *> *stringArray) {
            NSString* title = stringArray.lastObject;
            NSInteger index =  [array indexOfObject:title];
            NSArray * idarray = [self.allMenuArray st_arrayFromObjKeyName:@"obj.id"];
            self.region_id = idarray[index];
            [self.addButton setTitle:title forState:UIControlStateNormal];
        }];
        [self presentViewController:vc animated:NO completion:nil];
    }
}
- (void)onSelctedCommitButton{
    if (!self.textView.text.length) {
        [SVProgressHUD showInfoWithStatus:@"请输入您的想法"];
        return;
    }
    
    
    if (self.imageChoseView.allImages.count) {
        [SVProgressHUD showWithStatus:@"正在上传"];
        [TMUtils uploadMoreImage:self.imageChoseView.allImages handle:^(BOOL success, NSArray<NSDictionary *> *imageModels) {
            if (success) {
                self.imageModelUrlArray = imageModels;
                [self sendAddNewFeadBackRequest];
            }else{
                [SVProgressHUD showErrorWithStatus:@"上传失败,请重试"];
            }
        }];
    }else{
        [self sendAddNewFeadBackRequest];
    }
}

#pragma mark --NetWork Method
- (void)sendFetchAddRequest{
    [BVCircleDataController sendGetGeginRequestWithHandle:^(NSArray * _Nonnull reginArray) {
        if (reginArray.count) {
            self.allMenuArray = reginArray;
        }
    }];
}
- (void)sendAddNewFeadBackRequest{
    [SVProgressHUD showWithStatus:@"请稍后"];
    NSMutableDictionary * paramDic = [NSMutableDictionary new];
    NSString * token = STUserManger.defult.loginedUser.token;
    if (token.length) {
        [paramDic setObject:token forKey:@"token"];
    }
    if (self.textView.text.length) {
        [paramDic setObject:self.textView.text forKey:@"content"];
    }
    if (self.region_id.length) {
        [paramDic setObject:self.region_id forKey:@"region_id"];
    }
    if (self.imageModelUrlArray.count) {
        [paramDic setObject:@"1" forKey:@"type"];
        [paramDic setObject:self.imageModelUrlArray.mj_JSONString forKey:@"images"];
    }
    NSString * url = [NSString stringWithFormat:@"%@%@",releaseServerUrlHeader,@"Circle/saveCircle"];
    DDLogInfo(@"url:%@",url);
    DDLogInfo(@"param:%@",paramDic);
    [[STNetWrokManger defaultClient] requestWithPath:url
                                              method:STHttpRequestTypePost
                                          parameters:paramDic
                                             success:^(NSURLSessionDataTask *operation, id responseObject) {
                                                 [SVProgressHUD dismiss];
                                                 [SVProgressHUD showSuccessWithStatus:@"发布成功，请等待后台审核"];
                                                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                     [self.navigationController popViewControllerAnimated:YES];
                                                 });
                                                 
                                                 DDLogInfo(@"%@请求成功:resp\n%@",url,responseObject);
                                                 
                                                 
                                             } failure:^(NSString *stateCode, STError *error,NSError *originError) {
                                                 [SVProgressHUD dismiss];
                                                 [SVProgressHUD showErrorWithStatus:error.desc];
                                                 DDLogError(@"\n请求失败:\nurl:%@\nparam:%@\n失败原因:%@\n错误码:%ld",
                                                            url,paramDic,error.desc,error.code);
                                             }];
}
@end
