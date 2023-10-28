//
//  WDTimeLinePostVC.m
//  TimeLine
//
//  Created by Unique on 2019/10/30.
//  Copyright © 2019 Unique. All rights reserved.
//

#import "WDTimeLinePostVC.h"

#import "WDTimeLinePostTextViewCell.h"
#import "WDTimeLineImageSelectCell.h"
#import "WDTimeLineLocationCell.h"
#import "WDTimeLineTypeSelectCell.h"

@interface WDTimeLinePostVC ()<UITableViewDelegate, UITableViewDataSource, WDTimeLinePostTextViewCellDelegate, WDTimeLineImageSelectCellDelegate>
@property (nonatomic, copy)NSString* content;
@property (nonatomic, strong)NSMutableArray* reImgs;
@property (nonatomic, strong)NSMutableArray* reVids;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat textViewCellHeight;
@property (nonatomic, assign) CGFloat imageCellHeight;

@property (nonatomic, copy) NSString *typeString;

@property (nonatomic, copy) NSDictionary* requestParams;
@property (nonatomic, strong) NSMutableArray*selectPVList;


@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong) NSMutableArray*photoModels;
@property (nonatomic, strong) NSMutableArray*videoModels;
@end

@implementation WDTimeLinePostVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block{
    WDTimeLinePostVC *vc = [[WDTimeLinePostVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)postPVData{
    if(self.selectPVList.count==0)return;
    self.photoModels = [NSMutableArray array];
    self.videoModels = [NSMutableArray array];
    // 如果将_manager.configuration.requestImageAfterFinishingSelection 设为YES，
    // 那么在选择完成的时候就会获取图片和视频地址
    // 如果选中了原图那么获取图片时就是原图
    // 获取视频时如果设置 exportVideoURLForHighestQuality 为YES，则会去获取高等质量的视频。其他情况为中等质量的视频
    // 个人建议不在选择完成的时候去获取，因为每次选择完都会去获取。获取过程中可能会耗时过长
    // 可以在要上传的时候再去获取
    for (HXPhotoModel *model in self.selectPVList) {
        // 数组里装的是所有类型的资源，需要判断
        // 先判断资源类型
        if (model.subType == HXPhotoModelMediaSubTypePhoto) {
            // 当前为图片
//            if (model.photoEdit) {
//                // 如果有编辑数据，则说明这张图篇被编辑过了
//                // 需要这样才能获取到编辑之后的图片
//                model.photoEdit.editPreviewImage;
//                return;
//            }
            // 再判断具体类型
            if (model.type == HXPhotoModelMediaTypeCameraPhoto) {
                // 到这里就说明这张图片不是手机相册里的图片，可能是本地的也可能是网络图片
                // 关于相机拍照的的问题，当系统 < ios9.0的时候拍的照片虽然保存到了相册但是在列表里存的是本地的，没有PHAsset
                // 当系统 >= ios9.0 的时候拍的照片就不是本地照片了，而是手机相册里带有PHAsset对象的照片
                // 这里的 model.asset PHAsset是空的
                // 判断具体类型
                if (model.cameraPhotoType == HXPhotoModelMediaTypeCameraPhotoTypeLocal) {
                    // 本地图片
                
                }else if (model.cameraPhotoType == HXPhotoModelMediaTypeCameraPhotoTypeLocalGif) {
                    // 本地gif图片
                    
                }else if (model.cameraPhotoType == HXPhotoModelMediaTypeCameraPhotoTypeNetWork) {
                    // 网络图片
                
                }else if (model.cameraPhotoType == HXPhotoModelMediaTypeCameraPhotoTypeNetWorkGif) {
                    // 网络gif图片
                    
                }
                // 上传图片的话可以不用判断具体类型，按下面操作取出图片
                if (model.networkPhotoUrl) {
                    // 如果网络图片地址有值就说明是网络图片，可直接拿此地址直接使用。避免重复上传
                    // 这里需要注意一下，先要判断是否为图片。因为如果是网络视频的话此属性代表视频封面地址
                    
                }else {
                    // 网络图片地址为空了，那就肯定是本地图片了
                    // 直接取 model.previewPhoto 或者 model.thumbPhoto，这两个是同一个image
                    
                }
            }else {
                // 到这里就是手机相册里的图片了 model.asset PHAsset对象是有值的
                // 如果需要上传 Gif 或者 LivePhoto 需要具体判断
                if (model.type == HXPhotoModelMediaTypePhoto) {
                    // 普通的照片，如果不可以查看和livePhoto的时候，这就也可能是GIF或者LivePhoto了，
                    // 如果你的项目不支持动图那就不要取NSData或URL，因为如果本质是动图的话还是会变成动图传上去
                    // 这样判断是不是GIF model.photoFormat == HXPhotoModelFormatGIF
                    
                    // 如果 requestImageAfterFinishingSelection = YES 的话，直接取 model.previewPhoto 或者 model.thumbPhoto 在选择完成时候已经获取并且赋值了
                    // 获取image
                    // size 就是获取图片的质量大小，原图的话就是 PHImageManagerMaximumSize，其他质量可设置size来获取
                    CGSize size;
//                    if (self.original) {
                        size = PHImageManagerMaximumSize;
//                    }else {
                        size = CGSizeMake(model.imageSize.width * 0.5, model.imageSize.height * 0.5);
//                    }
                    [model requestPreviewImageWithSize:size startRequestICloud:^(PHImageRequestID iCloudRequestId, HXPhotoModel * _Nullable model) {
                        // 如果图片是在iCloud上的话会先走这个方法再去下载
                    } progressHandler:^(double progress, HXPhotoModel * _Nullable model) {
                        // iCloud的下载进度
                    } success:^(UIImage * _Nullable image, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                        // image
                    } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                        // 获取失败
                    }];
                }else if (model.type == HXPhotoModelMediaTypePhotoGif) {
                    // 动图，如果 requestImageAfterFinishingSelection = YES 的话，直接取 model.imageURL。因为在选择完成的时候已经获取了不用再去获取
                    //model.imageURL;
                    // 上传动图时，不要直接拿image上传哦。可以获取url或者data上传
                    // 获取url
                    [model requestImageURLStartRequestICloud:nil progressHandler:nil success:^(NSURL * _Nullable imageURL, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                        // 下载完成，imageURL 本地地址
                    } failed:nil];
                    
                    // 获取data
                    [model requestImageDataStartRequestICloud:nil progressHandler:nil success:^(NSData * _Nullable imageData, UIImageOrientation orientation, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                        // imageData
                    } failed:nil];
                }else if (model.type == HXPhotoModelMediaTypeLivePhoto) {
                    // LivePhoto，requestImageAfterFinishingSelection = YES 时没有处理livephoto，需要自己处理
                    // 如果需要上传livephoto的话，需要上传livephoto里的图片和视频
                    // 展示的时候需要根据图片和视频生成livephoto
                    [model requestLivePhotoAssetsWithSuccess:^(NSURL * _Nullable imageURL, NSURL * _Nullable videoURL, BOOL isNetwork, HXPhotoModel * _Nullable model) {
                        // imageURL - LivePhoto里的照片封面地址
                        // videoURL - LivePhoto里的视频地址
                        
                    } failed:^(NSDictionary * _Nullable info, HXPhotoModel * _Nullable model) {
                        // 获取失败
                    }];
                }
                // 也可以不用上面的判断和方法获取，自己根据 model.asset 这个PHAsset对象来获取想要的东西
//                PHAsset *asset = model.asset;
                // 自由发挥
            }
            
        }else if (model.subType == HXPhotoModelMediaSubTypeVideo) {
            // 当前为视频
            if (model.type == HXPhotoModelMediaTypeVideo) {
                // 为手机相册里的视频
                // requestImageAfterFinishingSelection = YES 时，直接去 model.videoURL，在选择完成时已经获取了
//                model.videoURL;
                // 获取视频时可以获取 AVAsset，也可以获取 AVAssetExportSession，获取之后再导出视频
                // 获取 AVAsset
                [model requestAVAssetStartRequestICloud:nil progressHandler:nil success:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                    // avAsset
                    // 自己根据avAsset去导出视频
                } failed:nil];
                
                // 获取 AVAssetExportSession
                [model requestAVAssetExportSessionStartRequestICloud:nil progressHandler:nil success:^(AVAssetExportSession * _Nullable assetExportSession, HXPhotoModel * _Nullable model, NSDictionary * _Nullable info) {
                    
                } failed:nil];
                
                // HXPhotoModel也提供直接导出视频地址的方法
                // presetName 导出视频的质量，自己根据需求设置
                [model exportVideoWithPresetName:AVAssetExportPresetMediumQuality startRequestICloud:nil iCloudProgressHandler:nil exportProgressHandler:^(float progress, HXPhotoModel * _Nullable model) {
                    // 导出视频时的进度，在iCloud下载完成之后
                } success:^(NSURL * _Nullable videoURL, HXPhotoModel * _Nullable model) {
                    // 导出完成, videoURL
                    
                } failed:nil];
                
                // 也可以不用上面的方法获取，自己根据 model.asset 这个PHAsset对象来获取想要的东西
//                PHAsset *asset = model.asset;
                // 自由发挥
            }else {
                // 本地视频或者网络视频
                if (model.cameraVideoType == HXPhotoModelMediaTypeCameraVideoTypeLocal) {
                    // 本地视频
                    // model.videoURL 视频的本地地址
                }else if (model.cameraVideoType == HXPhotoModelMediaTypeCameraVideoTypeNetWork) {
                    // 网络视频
                    // model.videoURL 视频的网络地址
                    // model.networkPhotoUrl 视频封面网络地址
                }
            }
            
        }
        if (model.subType == HXPhotoModelMediaSubTypeVideo) {
            [self.videoModels addObjectVerify:model.videoURL];
            [self.videoModels addObjectVerify:model.previewPhoto];
//            [self handleRs:@"video" withArr:self.videoModels];
            [self handleRs:@"video" withArr:@[self.videoModels.firstObject]];
            [self handleRs:@"image" withArr:@[self.videoModels.lastObject]];
            //model.thumbPhoto/model.previewPhoto可封面
        }else if (model.subType == HXPhotoModelMediaSubTypePhoto){
            UIImage* image = model.previewPhoto;
            [self.photoModels addObjectVerify:image];
        }
    }
    [self handleRs:@"image" withArr:self.photoModels];
}
- (void)handleRs:(NSString*)mineType withArr:(NSArray*)originArr{
    [SVProgressHUD showWithStatus:@"正在上传发布中..."];
    self.rightBtn.userInteractionEnabled = NO;
    [[YTSharednetManager sharedNetManager]postMoreFiles:[ApiConfig getAppApi:ApiType65] realmNameType:All parameters:mineType imageDataArray:originArr success:^(NSDictionary *dic) {
        
        NSLog(@".....%@",dic);
        NSMutableDictionary* handDic = [NSMutableDictionary dictionary];
        if ([NSString getDataSuccessed:dic]) {
            
            
            NSDictionary* dicc = dic[@"data"];
            
            if ([dicc[@"path"] isKindOfClass:[NSArray class]]) {
                NSArray* arr = dicc[@"path"];
                [self.reImgs addObjectsFromArray:arr];
            }else if ([dicc[@"path"] isKindOfClass:[NSString class]]){
                [self.reImgs addObject:dicc[@"path"]];
            }
            NSLog(@"ri....%@",self.reImgs);
            if (originArr.count >0&&
                self.reImgs.count >0) {
                if (self.reImgs.count == self.photoModels.count) {
                    NSString* jsonS = [NSString arrayToJson:self.reImgs];
                    [handDic addEntriesFromDictionary: @{@"thumbs":jsonS}];
                    [self postAllRe:handDic];
                
                    
                }
                if (self.reImgs.count == self.videoModels.count) {
                    
                    for (int i=0; i<self.reImgs.count; i++) {
                        NSString* st = self.reImgs[i];
                        if ([st containsString:@".mp4"]) {
                            NSString* jsonS = [NSString arrayToJson:@[st]];
                            [handDic addEntriesFromDictionary: @{@"video":jsonS}];
                        }
                        if ([st containsString:@".png"]) {
                            NSString* jsonS = [NSString arrayToJson:@[st]];
                            [handDic addEntriesFromDictionary: @{@"video_picture":jsonS}];
                        }
                    }
                    [self postAllRe:handDic];
                }
                
            }
            
        }
    } error:^(NSError *error) {
        self.rightBtn.userInteractionEnabled = YES;
    }];
}
- (void)postAllRe:(NSDictionary*)handDic{
    [SVProgressHUD showWithStatus:@"正在上传发布中..."];
    NSMutableDictionary* reDic = [NSMutableDictionary dictionary];
    [reDic addEntriesFromDictionary:@{@"category_id":[NSString stringWithFormat:@"%@",self.requestParams]}];
    if (self.content.length>0) {
        [reDic addEntriesFromDictionary:@{@"content":self.content}];
    }
    if (handDic) {
        [reDic addEntriesFromDictionary:handDic];
    }
//    if (self.photoModels.count >0&&
//        self.reImgs.count >0&&
//        self.reImgs.count == self.photoModels.count) {
//        NSString* jsonS = [NSString arrayToJson:self.reImgs];
//        [reDic addEntriesFromDictionary:@{@"thumbs":jsonS}];
//    }
//    if (self.videoModels.count >0&&
//        self.reImgs.count >0&&
//        self.reImgs.count == self.videoModels.count) {
//        NSString* jsonS = [NSString arrayToJson:self.reImgs];
//        [reDic addEntriesFromDictionary:@{@"video":jsonS}];
//    }
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType66] andType:All andWith:reDic success:^(NSDictionary *dic) {
        
        if ([NSString getDataSuccessed:dic]) {
            HomeModel* model = [HomeModel mj_objectWithKeyValues:dic];
            [YKToastView showToastText:model.msg];
            if (self.block) {
                [self.navigationController popViewControllerAnimated:true];
                self.block(@(1));
            }
        }
        self.rightBtn.userInteractionEnabled = YES;
    } error:^(NSError *error) {
        self.rightBtn.userInteractionEnabled = YES;
    }];
    
}
- (void)naviRightBtnEvent:(UIButton *)sender {
    self.reImgs = [NSMutableArray array];
//    self.reVids = [NSMutableArray array];
    if (self.selectPVList.count>0) {
        [self postPVData];
    }else{
        [self postAllRe:nil];
    }
    
    
    return;
    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.holder dismissViewControllerAnimated:YES completion:^{

        if (self.videoModels.count==1) {
            NSURL* vu = self.videoModels[0];
            AVPlayerViewController *aVPlayerViewController = [[AVPlayerViewController alloc]init];
            aVPlayerViewController.player = [[AVPlayer alloc]initWithURL:vu];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:aVPlayerViewController animated:YES completion:^{
                nil;
            }];
            
//            AVPlayer* player = [[AVPlayer alloc] init];
//            AVPlayerItem*  playerItem = [[AVPlayerItem alloc] initWithURL:vu];
//            [player replaceCurrentItemWithPlayerItem:playerItem];
//            AVPlayerLayer*  playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
//            CGFloat height = 1280./720.*ScreenWidth;
//            playerLayer.frame = CGRectMake(0, (ScreenHeight-height)/2., ScreenWidth, height);
//            [self.view.layer addSublayer:playerLayer];
//            [player play];
        }
            
//        }];
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.rightBtn.adjustsImageWhenHighlighted = NO;
    [self.rightBtn setTitle:@"发布" forState:0];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    
    self.title = @"发布帖子";
    self.typeString = @"";
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.textViewCellHeight = 130;
    self.imageCellHeight = (UIScreen.mainScreen.bounds.size.width - 25 * 2 - 3 * 2) / 3 + 10 * 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        WDTimeLinePostTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDTimeLinePostTextViewCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 1){
        WDTimeLineImageSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDTimeLineImageSelectCell" forIndexPath:indexPath];
        cell.delegate = self;
        return cell;
    } else if (indexPath.row == 2) {
        WDTimeLineLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDTimeLineLocationCell" forIndexPath:indexPath];
        return cell;
    } else {
        WDTimeLineTypeSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WDTimeLineTypeSelectCell" forIndexPath:indexPath];
        cell.currentTypeLabel.text = self.typeString.length > 0 ? self.typeString : @"选择分类";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return self.textViewCellHeight;
    } else if (indexPath.row == 1) {
        return self.imageCellHeight;
    } else if (indexPath.row == 2) {
        return 60;
    } else {
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    
    if (indexPath.row == 3) {
        [BRStringPickerView showPickerWithTitle:@"选择分类" dataSourceArr:@[@"AA", @"BB", @"CC"] selectIndex:0 resultBlock:^(BRResultModel * _Nullable resultModel) {
            self.typeString = resultModel.value;
            [self.tableView reloadData];
        }];
    }
}

#pragma mark - WDTimeLinePostTextViewCell Delegate
- (void)postTextViewCell:(WDTimeLinePostTextViewCell *)cell didChangeFrame:(CGRect)frame didChangeText:(NSString *)text {
    self.content = cell.textView.text;
    self.textViewCellHeight = frame.size.height + 15 * 2;
    [UIView performWithoutAnimation:^{
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }];
}

- (void)postTextViewCell:(WDTimeLinePostTextViewCell *)cell reachedMaxNum:(BOOL)reached {
    
    if (reached) {
        NSLog(@"=============z最大");
    }
}

#pragma mark - WDTimeLineImageSelectCell Delegate
- (void)imageSelectCell:(WDTimeLineImageSelectCell *)cell didChangePhotos:(NSArray<HXPhotoModel *> *)photos didChangeVideos:(NSArray<HXPhotoModel *> *)videos{
    if (photos.count < 3) {
        self.imageCellHeight = (UIScreen.mainScreen.bounds.size.width - 25 * 2 - 3 * 2) / 3 + 10 * 2;
    } else if (photos.count < 6) {
        self.imageCellHeight = (UIScreen.mainScreen.bounds.size.width - 25 * 2 - 3 * 2) / 3 * 2 + 10 * 2 + 3;
    } else {
        self.imageCellHeight = (UIScreen.mainScreen.bounds.size.width - 25 * 2 - 3 * 2) / 3 * 3 + 10 * 2 + 3 * 2;
    }
    self.selectPVList = [NSMutableArray array];
    [self.selectPVList addObjectsFromArray:photos];
    [self.selectPVList addObjectsFromArray:videos];
    

    [UIView performWithoutAnimation:^{
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
    }];
}

#pragma mark - Lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_tableView registerClass:[WDTimeLinePostTextViewCell class] forCellReuseIdentifier:@"WDTimeLinePostTextViewCell"];
        [_tableView registerClass:[WDTimeLineImageSelectCell class] forCellReuseIdentifier:@"WDTimeLineImageSelectCell"];
        [_tableView registerClass:[WDTimeLineLocationCell class] forCellReuseIdentifier:@"WDTimeLineLocationCell"];
        [_tableView registerClass:[WDTimeLineTypeSelectCell class] forCellReuseIdentifier:@"WDTimeLineTypeSelectCell"];
    }
    return _tableView;
}
@end
