//
//  STPhotoBaseViewController.m
//  STTools
//
//  Created by stoneobs on 16/10/9.
//  Copyright © 2016年 stoneobs. All rights reserved.


#import "STPhotoBaseViewController.h"
#import <Photos/Photos.h>
#import "STPhotoCollectionViewController.h"
#import "STPhotoBaseTableViewCell.h"
#import "STImagePickerController.h"

@interface STPhotoBaseViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 相册所有资源数组，包括任何一个相册的子相册集
 */
@property(nonatomic,strong)NSMutableArray<NSMutableArray*>    *albumArray;
@property(nonatomic,strong)UIView                             *backView;//无权限显示
@property(nonatomic,strong)UITableView                        *tableView;
@end

@implementation STPhotoBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"相册";
    self.albumArray = [NSMutableArray new];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = BACKROUND_COLOR;
    self.tableView.separatorColor = STRGB(0xE5E5E5);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    
    [self configNav];
    [self initSystemAlbum];
    [self initMyselfAlbum];
    [self authDidChanged];
    [self initNoAuthView];
    [self judgeCureentAuth];
    
    
    
}
#pragma mark --SubView
//导航栏
- (void)configNav{
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction:)];
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15], NSFontAttributeName, nil] forState:UIControlStateNormal];
    right.tintColor = item_COLOR;
    STImagePickerController * nav = (STImagePickerController*)self.navigationController;
    if (nav.themeColor) {
        right.tintColor = nav.themeColor;
    }
    self.navigationItem.rightBarButtonItem = right;
}
//无权限View
- (void)initNoAuthView{
    
    
    _backView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
    _backView.backgroundColor = [UIColor whiteColor];
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    imageView.center = self.view.center;
    imageView.image = [UIImage imageNamed:@"STPhotoKit.bundle/STPhotoKitAuthLock.png"];
    [_backView addSubview:imageView];
    
    UILabel * label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 20, 300, 16)];
    label1.font = [UIFont systemFontOfSize:16];
    label1.textColor = FirstTextColor;
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"此应用没有权限访问您的照片或视频";
    label1.centerX = self.view.centerX;
    [_backView addSubview:label1];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label1.bottom + 5, 300, 14)];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = SecendTextColor;
    label2.textAlignment = NSTextAlignmentCenter;
    label2.centerX = self.view.centerX;
    label2.text = @"您可以在“隐私设置”中启用访问";
    [_backView addSubview:label2];
    [self.view addSubview:_backView];
    _backView.hidden = YES;
}

#pragma mark--UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.albumArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.albumArray[section].count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [STPhotoBaseTableViewCell height];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 12;
    }
    return 0.001;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return @"我的相簿";
    }
    return @"";
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier =  @"cell";
    STPhotoBaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[STPhotoBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
        
    }
    cell.model = self.albumArray[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
#pragma mark--UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //传入相册集合
    PHAssetCollection * selectdeAlbum = self.albumArray[indexPath.section][indexPath.row];
    STPhotoCollectionViewController * vc  = [STPhotoCollectionViewController new];
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:selectdeAlbum options:nil];
    vc.curentAlbum = fetchResult;
    vc.title = selectdeAlbum.localizedTitle;
    [self.navigationController pushViewController:vc animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark --Private Method
//获取系统相册
- (void)initSystemAlbum
{
    //智能获取所有相册
    NSMutableArray * albumOne = [NSMutableArray new];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        // 获取一个相册（PHAssetCollection）
        PHCollection *collection = smartAlbums[i];
       // NSLog(@"one-title%@",collection.localizedTitle);
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            NSNumber * count = [NSNumber numberWithInteger:fetchResult.count];
            PHAsset  * asset = fetchResult.lastObject;
            if (count.integerValue!=0 && ![collection.localizedTitle isEqualToString:@"视频"]) {
                [albumOne addObject:collection];
                PHImageRequestOptions *originRequestOptions = [[PHImageRequestOptions alloc] init];
                originRequestOptions.networkAccessAllowed = YES;
                originRequestOptions.synchronous = YES;
                originRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(75, 75) contentMode:PHImageContentModeAspectFill options:originRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    [self.tableView reloadData];
                    
                }];
            }
            
        }
    }
    if (albumOne.count > 0) {
        [self.albumArray addObject:albumOne];
    }
    
    
}
//获取自身的相册
- (void)initMyselfAlbum
{
    
    NSMutableArray * albumTwo = [NSMutableArray new];
    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (NSInteger i = 0; i < smartAlbums.count; i++) {
        // 获取一个相册（PHAssetCollection）
        PHCollection *collection = smartAlbums[i];
       // NSLog(@"two-title%@",collection.localizedTitle);
        if ([collection isKindOfClass:[PHAssetCollection class]]) {
            PHAssetCollection *assetCollection = (PHAssetCollection *)collection;
            // 从每一个智能相册中获取到的 PHFetchResult 中包含的才是真正的资源（PHAsset）
            PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:nil];
            NSNumber * count = [NSNumber numberWithInteger:fetchResult.count];
            PHAsset  * asset = fetchResult.lastObject;
            if (count.integerValue!=0) {
                [albumTwo addObject:collection];
                [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:[PHImageRequestOptions new] resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                    [self.tableView reloadData];
                }];
            }
        }
    }
    if (albumTwo.count > 0) {
        [self.albumArray addObject:albumTwo];
    }
    
    
    
    
    
}
//权限发生改变
- (void)authDidChanged{
    //获取同意的权限
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                //更新数据
                self.albumArray = [NSMutableArray new];
                [self initSystemAlbum];
                [self initMyselfAlbum];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
                
                
            }
            else
            {
                
                self.tableView.hidden = YES;
                self.backView.hidden = NO;
            }
        }];
    }
    
}
//查看当前权限
- (void)judgeCureentAuth{
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
        self.tableView.hidden = YES;
        self.backView.hidden = NO;
    }else if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
        self.tableView.hidden = NO
        ;
        self.backView.hidden = YES;
        
    
    }
    
}
#pragma mark --Action Method
-(void)rightBarAction:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

@end
