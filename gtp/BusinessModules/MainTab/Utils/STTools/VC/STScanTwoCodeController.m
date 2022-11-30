//
//  LVScanTwoCodeController.m
//  lover
//
//  Created by stoneobs on 16/4/8.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STScanTwoCodeController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+STPresent.h"
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SCREEN_FRAME  [UIScreen mainScreen].bounds
#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define STRGB(v)     [UIColor colorWithRed:((float)((v & 0xFF0000) >> 16))/255.0 green:((float)((v & 0xFF00) >> 8))/255.0  blue:((float)(v & 0xFF))/255.0 alpha:1]
#define BACKROUND_COLOR  STRGB(0xF4F5F0)
@interface STScanTwoCodeController ()<AVCaptureMetadataOutputObjectsDelegate,AVAudioPlayerDelegate>
@property(nonatomic,strong)AVCaptureSession         *session;
@property(nonatomic,strong)AVCaptureDevice          *device;
@property(nonatomic,strong)AVAudioPlayer            *audioPlayer;
@property(nonatomic,strong)UIImageView              *scrollImageView;
@property(nonatomic,copy)STScanTwoCodeControllerResult resultBlock;
@property(nonatomic, assign) BOOL                     isHaveResult;//是否有结果,结束动画
@property(nonatomic, strong) UIButton                 *lightButton;
@property(nonatomic,strong)UIView                     *backView;//无权限显示
@end

@implementation STScanTwoCodeController
- (instancetype)initWithHandle:(STScanTwoCodeControllerResult)handle
{
    if (self = [super init]) {
        if (handle) {
            self.resultBlock = handle;
        }
    }
    return  self;
}
//播放器懒加载
- (AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer) {
        //扫描完成之后播放这个声音
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"STTools.bundle/STFiles/shake_match" withExtension:@".wav"];
        NSError *error = nil;
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        //设置播放器属性
        _audioPlayer.numberOfLoops = 0;//设置为0不循环
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
    }
    return _audioPlayer;
}
#pragma mark --subView
- (void)configSubView{
    UIImageView * scanView = [[UIImageView alloc] init];
    scanView.center = self.view.center;
    scanView.bounds = [UIScreen mainScreen].bounds;
    UIImage * scanViewImage =  [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"STTools.bundle/STImages/qrcode_scan_background_default@2x"] ofType:@"png"]];
    scanView.image = scanViewImage;
    [self.view addSubview:scanView];
    
    _scrollImageView = [[UIImageView alloc] initWithFrame:CGRectMake((UIScreenWidth-(UIScreenWidth/2))/2, UIScreenHeight/2-80-64, UIScreenWidth/2, 2)];
    UIImage * lineImage =  [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"STTools.bundle/STImages/qrcode_scan_line_default@2x"] ofType:@"png"]];
    _scrollImageView.image = lineImage;
    [scanView addSubview:_scrollImageView];
    [self startAnimation];
    
    _lightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, UIScreenHeight / 2 + 80 + 90, UIScreenWidth, 44)];
    [_lightButton setTitle:@"轻触点亮屏幕" forState:UIControlStateNormal];
     [_lightButton setTitle:@"轻触关闭屏幕" forState:UIControlStateSelected];
    [_lightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_lightButton addTarget:self action:@selector(onSelectedLightButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_lightButton];
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
    label1.text = @"此应用没有权限访问您的摄像头";
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
}
- (void)confiSession{
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    //创建输出流
    AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc]init];
//    (y,x,h,w)
    output.rectOfInterest = CGRectMake((self.view.center.y-SCREEN_HEIGHT/4)/SCREEN_HEIGHT,
                                       (self.view.center.x-SCREEN_WIDTH/4)/SCREEN_WIDTH,
                                       SCREEN_HEIGHT/2/SCREEN_HEIGHT,
                                       SCREEN_WIDTH/2/SCREEN_WIDTH);
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    _session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [_session addInput:input];
    }
    if (output) {
        [_session addOutput:output];
    }
    //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    layer.frame  = self.view.layer.bounds;
    [self.view.layer insertSublayer:layer atIndex:0];
    //开始捕获
    [_session startRunning];
}
#pragma mark --生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"扫一扫";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setRightTitle:@"相册"];
    [self getCameraAuthorizationStatus];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_session startRunning];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   // [self stopAllSession];
}

- (void)setRightTitle:(NSString*)title;
{
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(rightBarAction:)];
    right.tintColor = UIColor.blackColor;
    self.navigationItem.rightBarButtonItem = right;

}
- (void)rightBarAction:(id)sender
{
    [self st_showchosePhotoImagePicker:^(UIImage *image) {
        if (image) {
            NSString * result = [self decodeImage:image];
            [self stopAllSession];
            self.isHaveResult = YES;
            __weak typeof(self) weakSelf =  self;
            if (self.resultBlock) {
                self.resultBlock(result,weakSelf);
            }
        }
    }];
}
#pragma mark --Private Method
- (void)getCameraAuthorizationStatus
{
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusNotDetermined) {
        //未定义
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                //授权成功,主线程加载扫描视图
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self configSubView];
                    [self confiSession];
                });
                
            }else {
                //授权失败,主线程加载UI界面
                dispatch_async(dispatch_get_main_queue(), ^{
  [self initNoAuthView];
                });
              
            }
        }];
    }else if (authStatus == AVAuthorizationStatusAuthorized) {
        //已授权
        [self configSubView];
        [self confiSession];
    }else {
        //拒绝
        [self initNoAuthView];
    }
}
- (void)stopAllSession{
    [_session stopRunning];
    if (self.lightButton.selected) {
        [self onSelectedLightButton];
    }
    self.isHaveResult = YES;
}
//解码图片
- (NSString *)decodeImage:(UIImage *)image
{
    NSData *data = UIImagePNGRepresentation(image);
    CIImage *ciimage = [CIImage imageWithData:data];
    if (ciimage) {
        CIDetector *qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer:@(YES)}] options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
        NSArray *resultArr = [qrDetector featuresInImage:ciimage];
        if (resultArr.count > 0) {
            CIFeature *feature = resultArr.firstObject;
            CIQRCodeFeature *qrFeature = (CIQRCodeFeature *)feature;
            NSString *result = qrFeature.messageString;
            
            return result;
        }else {
            return nil;
        }
    }else {
        return nil;
    }
}
//开始动画
- (void)startAnimation
{
    [UIView animateWithDuration:1.5 animations:^{

        self.scrollImageView.bottom = SCREEN_HEIGHT / 2 + 80;
    
    } completion:^(BOOL finished) {
        [self cicleAnimation];
    }];
}
- (void)cicleAnimation
{
    [UIView animateWithDuration:1.5 animations:^{
        self.scrollImageView.bottom = SCREEN_HEIGHT / 2 - 80 - 64;
    } completion:^(BOOL finished) {
        if (!_isHaveResult) {
             [self startAnimation];
        }
    }];
}
#pragma mark --Action Method
- (void)onSelectedLightButton{
    self.lightButton.selected = !self.lightButton.selected ;
    if (self.lightButton.selected) {
        if ([_device hasFlash] && [_device hasTorch]) {
            [_device lockForConfiguration:nil];
            [_device setFlashMode:AVCaptureFlashModeOn];
            [_device setTorchMode:AVCaptureTorchModeOn];
            [_device unlockForConfiguration];
        }
    }
    else{
        if ([_device hasFlash] && [_device hasTorch]) {
            [_device lockForConfiguration:nil];
            [_device setFlashMode:AVCaptureFlashModeOff];
            [_device setTorchMode:AVCaptureTorchModeOff];
            [_device unlockForConfiguration];
        }
    }
}
#pragma mark --AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        [self stopAllSession];
        [self.audioPlayer play];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        NSString * result = metadataObject.stringValue;
        __weak typeof(self) weakSelf =  self;
        if (self.resultBlock) {
            self.resultBlock(result,weakSelf);
        }
        
    }
}

@end
