//
//  SVFindTableViewCell.m
//  sixnineVideo
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 猪八戒. All rights reserved.
//

#import "SVFindTableViewCell.h"

@interface SVFindTableViewCell()


@property(nonatomic, strong) UIView                     *fatherView;/**<  */

@property(nonatomic, strong) STButton                     *titleButton;/**< 标题按钮 */
@property(nonatomic, strong) STLabel                     *numLable;/**< 数量 */


@end
@implementation SVFindTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self configSubView];
    }
    return self;
}
+ (CGFloat)cellHeight{
    return UIScreenHeight;
}
- (void)dealloc{
    DDLogInfo(@"SVFindTableViewCell dealloc");
}
#pragma mark --configSubView
- (void)configSubView{
    self.backgroundColor = UIColor.blackColor;
    self.fatherView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreenWidth, UIScreenHeight )];
    self.fatherView.contentMode = UIViewContentModeScaleAspectFill;
    self.fatherView.clipsToBounds = YES;
    self.fatherView.tag = 10000;
    [self addSubview:self.fatherView];
    _playerView = ZFPlayerView.alloc.init;
    _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspectFill;
    // 当cell播放视频由全屏变为小屏时候，不回到中间位置
    _playerView.cellPlayerOnCenter = NO;
    
    // 初始化播放数据
    UIImage * image = [TMRandImageTool bundleImageWithImageName:TMRandImageTool.randOneGoodBanner];
    _playerModel = [[ZFPlayerModel alloc] init];
    _playerModel.fatherView = self.fatherView;
    _playerModel.videoURL = [NSURL URLWithString:@""];
    _playerModel.placeholderImage =  image;

//    [self.playerView playerModel:_playerModel];
    
    //subView
    self.titleButton = [[STButton alloc] initWithFrame:CGRectMake(0, TMUtils.tabBarTop - 44 - 25, UIScreenWidth, 25)
                                                 title:@"视屏标题,视屏标题,视屏标题,"
                                            titleColor:UIColor.whiteColor
                                             titleFont:18
                                          cornerRadius:0
                                       backgroundColor:nil
                                       backgroundImage:nil
                                                 image:nil];
    [self addSubview:self.titleButton];
    self.titleButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 5);
    
    
    self.shareButton = [self defultButtonWithImageName:@"send_press"];
    self.shareButton.bottom = self.titleButton.top - 10;
    [self.shareButton setClicAction:^(UIButton *sender) {
        [TMUtils onSelctedShareButton];
    }];
    [self addSubview:self.shareButton];
    
    self.colButton = [self defultButtonWithImageName:@"爱心"];
    [self.colButton setImage:[UIImage imageNamed:@"爱心 _选择"] forState:UIControlStateSelected];
    self.colButton.bottom = self.shareButton.top - 10;
    [self addSubview:self.colButton];
    __weak typeof(self) weakSelf =  self;
    [self.colButton setClicAction:^(UIButton *sender) {
        [BVVideoDataController sendCollectVideoRequestWithVideo_id:weakSelf.model.v_id handle:^(NSError *error, BOOL success, NSDictionary *resp) {
            if (success) {
                sender.selected = !sender.selected;
                weakSelf.model.collcetion = !weakSelf.model.collcetion;
            }
        }];
    }];
    
    self.numLable = [[STLabel alloc] initWithFrame:CGRectMake(15, self.likeButton.top, 44, 20)
                                              text:@""
                                         textColor:UIColor.whiteColor
                                              font:13
                                       isSizetoFit:NO
                                     textAlignment:NSTextAlignmentCenter];
    [self addSubview:self.numLable];
    self.numLable.bottom = self.colButton.top - 10;
    self.numLable.right = UIScreenWidth - 15;
    
    self.likeButton = [self defultButtonWithImageName:@"favor_nopress"];
    self.likeButton.bottom = self.numLable.top - 10;
    [self.likeButton setImage:[UIImage imageNamed:@"favor_press"] forState:UIControlStateSelected];
    [self addSubview:self.likeButton];
    [self.likeButton setClicAction:^(UIButton *sender) {
        [BVVideoDataController sendLoveVideoRequestWithVideo_id:weakSelf.model.v_id handle:^(NSError *error, BOOL success, NSDictionary *resp) {
            if (success) {
                sender.selected = !sender.selected;
                weakSelf.model.islove = !weakSelf.model.islove;
                if (sender.selected) {
                    weakSelf.model.love = @(weakSelf.model.love.integerValue+1).description;
                }else{
                    weakSelf.model.love = @(weakSelf.model.love.integerValue-1).description;
                }
                weakSelf.numLable.text = weakSelf.model.love;
            }
        }];
    }];

    ZFPlayerControlView * controlView =  (id)_playerView.controlView;
    controlView.bottom = TMUtils.tabBarTop;
    self.playerView.disablePanGesture = YES;
}
- (STButton*)defultButtonWithImageName:(NSString*)imageName{
    STButton * button = [[STButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)
                                                  title:nil
                                             titleColor:nil
                                              titleFont:0
                                           cornerRadius:22
                                        backgroundColor:[UIColor.whiteColor colorWithAlphaComponent:0.4]
                                        backgroundImage:nil
                                                  image:[UIImage imageNamed:imageName]];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    button.bottom = self.class.cellHeight;
    button.right  = UIScreenWidth - 15;
    
    return button;
}
- (void)layoutSubviews{
    ZFPlayerControlView * controlView =  (id)_playerView.controlView;
    controlView.backBtn.hidden = YES;
    controlView.st_typeButton.hidden = YES;
    controlView.fullScreenBtn.hidden = YES;
    controlView.bottom = TMUtils.tabBarTop;
}
- (void)setModel:(BVVideoEasyModel *)model{
    _model = model;
    [self.playerView resetPlayer];
    self.playerModel.placeholderImageURLString = model.image;
    _playerModel.videoURL = [NSURL URLWithString:model.link];
    [self.playerView playerModel:_playerModel];
   
    [self.playerView autoPlayTheVideo];
    self.likeButton.selected = model.islove;
    [self.titleButton setTitle:model.title forState:UIControlStateNormal];
    self.colButton.selected = model.collcetion;
    
    self.numLable.text = model.love;
}

#pragma mark --Action Method
- (void)onSelctedDownloadButton{

   
}
@end
