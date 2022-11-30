

#import "SlotAnimateView.h"
#import "ZCSlotMachine.h"
#import <AVFoundation/AVFoundation.h>

//#define SLOTICONSCOUNT (8-1)

@interface SlotAnimateView ()<ZCSlotMachineDelegate, ZCSlotMachineDataSource>
@property(assign,nonatomic)NSInteger SLOTICONSCOUNT;
@end

@implementation SlotAnimateView
{
    ZCSlotMachine *_slotMachine;
    NSMutableArray *_slotIcons;
    UIButton *_startButton;
    UIView  *_slotContainerView;
    UIImageView *_slotOneImageView;
    AVAudioPlayer *_backgroundMusicPlayer;
}

+ (SlotAnimateView *)customView {
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"SlotAnimateView" owner:nil options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _iconArray = [NSMutableArray array];
    _slotIcons = [NSMutableArray array];
    _iconUrlArray = [NSMutableArray array];
    
    _lineImg.hidden = YES;
    _midView.hidden = YES;
        
}

- (void)audioPlayer {
    NSError *error;
    NSURL * backgroundMusicURL = [[NSBundle mainBundle] URLForResource:@"scroll" withExtension:@"mp3"];
    _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:&error];
    // numberOfLoops 是重复播放次数，0为不重复，1为重复一遍，-1为无限循环。
//    _backgroundMusicPlayer.volume = 0.5;
    _backgroundMusicPlayer.numberOfLoops = 0;
    [_backgroundMusicPlayer prepareToPlay];
    [_backgroundMusicPlayer play];
}

- (void)setupOneAnimationView {

    _slotMachine = [[ZCSlotMachine alloc] initWithFrame:CGRectMake(0, 0, self.width, ((CGFloat)147/127*self.width))];
    _slotMachine.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    _slotMachine.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [_slotIcons removeAllObjects];
    
    _SLOTICONSCOUNT = _iconArray.count-1;
    
    for (int i=0; i<(_iconArray.count > _SLOTICONSCOUNT ? _iconArray.count : _SLOTICONSCOUNT); i++) {
        int j = arc4random() % _iconArray.count;
        WItem *model = _iconArray[j];
        UIImage *myImage = [self imageFromUrl:model.cover];
        if (i >= 0 && i < _SLOTICONSCOUNT - 1) {
            UIImage *myImage3 = [self getBgColorFrom:0];
            NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName: [UIColor whiteColor]};
            CGSize size= [model.title sizeWithAttributes:attrs];
            NSDictionary *attrs2 = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName: [UIColor whiteColor]};
            CGSize size2 = [model.subTitle sizeWithAttributes:attrs2];
            
            UIImage *changeImage = [self addImage:myImage3 addMsakImage:myImage];
            changeImage = [self imageSetString_image:changeImage text:model.title textPoint:CGPointMake((myImage3.size.width-size.width)/2, changeImage.size.height - 55) attributedString:attrs];
            changeImage = [self imageSetString_image:changeImage text:[NSString stringWithFormat:@"\n(%@)", model.subTitle] textPoint:CGPointMake((myImage3.size.width-size2.width)/2, changeImage.size.height - 40) attributedString:attrs2];
            
            [_slotIcons addObject:changeImage];
        } else if (i == _SLOTICONSCOUNT) {
            
            if (self.iconUrlArray.count>0) {
                WItem* detailModel = self.iconUrlArray[i-_SLOTICONSCOUNT];//+self.selectedIndex
                NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]};
                CGSize size= [detailModel.title sizeWithAttributes:attrs];
                NSDictionary *attrs2 = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]};
                CGSize size2 = [model.subTitle sizeWithAttributes:attrs2];
                
                UIImage *myImage2 = [self getBgColorFrom:0];
                UIImage *myImage3 =[self imageFromUrl: detailModel.cover];
                UIImage *changeImage = [self addImage:myImage2 addMsakImage:myImage3];
                changeImage = [self imageSetString_image:changeImage text:detailModel.title textPoint:CGPointMake((myImage2.size.width-size.width)/2, changeImage.size.height - 55) attributedString:attrs];
                changeImage = [self imageSetString_image:changeImage text:[NSString stringWithFormat:@"\n(%@)", model.subTitle] textPoint:CGPointMake((myImage2.size.width- size2.width)/2, changeImage.size.height - 40) attributedString:attrs2];
                [_slotIcons addObject:changeImage];
            }
            
            
        }
        
    }
//    _slotIcons = [NSArray arrayWithObjects:[UIImage imageNamed:@"blue_bg"], [UIImage imageNamed:@"green_bg"], [UIImage imageNamed:@"purple_bg"], nil];
    _slotMachine.delegate = self;
    _slotMachine.dataSource = self;
    [self addSubview:_slotMachine];
    [self start];
}

#pragma mark
- (UIImage *)getBgColorFrom:(int)bg_color {
    UIImage *myImage;
    switch (bg_color) {
        case 0:
            myImage = [UIImage imageNamed:@"home_top_img"];
            break;
        default:
            break;
    }
    return myImage;
}

#pragma mark - ZCSlotMachineDataSource
- (NSArray *)iconsForSlotsInSlotMachine:(ZCSlotMachine *)slotMachine {
    return _slotIcons;
}

- (NSUInteger)numberOfSlotsInSlotMachine:(ZCSlotMachine *)slotMachine {
    return 1;
}

#pragma mark - ZCSlotMachineDelegate

- (void)slotMachineWillStartSliding:(ZCSlotMachine *)slotMachine {
//    _startButton.enabled = NO;
}

- (void)slotMachineDidEndSliding:(ZCSlotMachine *)slotMachine {
//    _startButton.enabled = YES;

//    [_slotMachine removeFromSuperview];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSNumber *x = _slotMachine.slotResults[0];
        NSLog(@"number =%@",x);
        
//        [self setupContent];

    });
}

#pragma mark - Private Methods

- (void)start {
    
    [self audioPlayer];

    NSUInteger slotIconCount = [_slotIcons count];
    
//    NSUInteger slotOneIndex = abs(rand() % slotIconCount);
    NSUInteger slotOneIndex = _SLOTICONSCOUNT-1;

    NSLog(@"slotOneIndex =%ld",slotOneIndex);
    
    
    _slotMachine.slotResults = [NSArray arrayWithObjects:
                                [NSNumber numberWithInteger:slotOneIndex],
                                nil];
    
    [_slotMachine startSliding];
}

#pragma mark -
- (UIImage *)addImage:(UIImage *)useImage addMsakImage:(UIImage *)maskImage
{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 40000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0)
    {
        UIGraphicsBeginImageContextWithOptions(useImage.size ,NO, 0.0); // 0.0 for scale means "scale for device's main screen".
    }
#else
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 4.0)
    {
        UIGraphicsBeginImageContext(useImage.size);
    }
#endif
    [useImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height)];
    
    //四个参数为水印图片的位置
//    [maskImage drawInRect:CGRectMake(0, 0, useImage.size.width, useImage.size.height/2)];
//    [maskImage drawInRect:CGRectMake((useImage.size.width-maskImage.size.width)/2, (useImage.size.height-maskImage.size.height)/2, maskImage.size.width, maskImage.size.height)];
    [maskImage drawInRect:CGRectMake((useImage.size.width-175/2)/2, (useImage.size.height-103/2)/2, 175/2, 103/2)];
//    [maskImage drawInRect:CGRectMake(0, useImage.size.height/2, useImage.size.width, useImage.size.height/2)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

#pragma mark - 获取图片
- (UIImage *)imageFromUrl: (NSString *) iconUrl {
    UIImage *memoryImage = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:iconUrl];
    if (memoryImage) {
        // do
        return memoryImage;
    } else {
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:iconUrl];
        if (cacheImage) {
            // do
            return cacheImage;
        } else {
            UIImage *myImage =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]]];
            return myImage;
        }
    }
}

- (UIImage *)imageSetString_image:(UIImage *)image
                             text:(NSString *)text
                        textPoint:(CGPoint)point
                 attributedString:(NSDictionary * )attributed
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //2.绘制图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [text drawAtPoint:point withAttributes:attributed];
    //3.从上下文中获取新图片
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    //4.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return img;
}

@end
