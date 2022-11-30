//
//  NewDynamicsTableViewCell.m
//  LooyuEasyBuy
//
//  Created by Andy on 2017/9/27.
//  Copyright © 2017年 Doyoo. All rights reserved.
//

#import "NewDynamicsTableViewCell.h"
#define ImgHeader @"http://static.soperson.com"
@implementation NewDynamicsGrayView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = MAINSCREEN_WIDTH - kDynamicsNormalPadding * 2 - kDynamicsPortraitNamePadding - kDynamicsPortraitWidthAndHeight;;
        frame.size.height = kDynamicsGrayBgHeight;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    [self addSubview:self.grayBtn];
    [self addSubview:self.thumbImg];
    [self addSubview:self.dspLabel];
    
    [self layout];
}
- (void)layout
{
    _grayBtn.frame = self.frame;
    
    _thumbImg.left = kDynamicsGrayPicPadding;
    _thumbImg.top = kDynamicsGrayPicPadding;
    _thumbImg.width = kDynamicsGrayPicHeight;
    _thumbImg.height = kDynamicsGrayPicHeight;

    _dspLabel.left = _thumbImg.right + kDynamicsNameDetailPadding;
    _dspLabel.width = self.right - kDynamicsNameDetailPadding - _dspLabel.left;
}

-(UIButton *)grayBtn
{
    if (!_grayBtn) {
        _grayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _grayBtn.backgroundColor = RGBSAMECOLOR(240);
        WS(weakSelf);
        [_grayBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.cell.delegate != nil && [weakSelf.cell.delegate respondsToSelector:@selector(DidClickGrayViewInDynamicsCell:)]) {
                [weakSelf.cell.delegate DidClickGrayViewInDynamicsCell:weakSelf.cell];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _grayBtn;
}
-(UIImageView *)thumbImg
{
    if (!_thumbImg) {
        _thumbImg = [UIImageView new];
        _thumbImg.userInteractionEnabled = NO;
        _thumbImg.backgroundColor = [UIColor grayColor];
    }
    return _thumbImg;
}
-(YYLabel *)dspLabel
{
    if (!_dspLabel) {
        _dspLabel = [YYLabel new];
        _dspLabel.userInteractionEnabled = NO;
    }
    return _dspLabel;
}

@end

@implementation NewDynamicsThumbCommentView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (frame.size.width == 0 && frame.size.height == 0) {
        frame.size.width = MAINSCREEN_WIDTH - kDynamicsNormalPadding * 2 - kDynamicsPortraitNamePadding - kDynamicsPortraitWidthAndHeight;;
        frame.size.height = 0;
    }
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup
{
    [self addSubview:self.bgImgView];
    [self addSubview:self.thumbLabel];
    [self addSubview:self.dividingLine];
    [self addSubview:self.commentTable];
    
}
- (void)setWithLikeArr:(NSMutableArray *)likeArr CommentArr:(NSMutableArray *)commentArr DynamicsLayout:(NewDynamicsLayout *)layout
{
    _likeArray = likeArr;
    self.commentArray = layout.commentLayoutArr;
    _layout = layout;
    [self layoutView];
}
- (void)layoutView
{
    _bgImgView.top = 0;
    _bgImgView.left = 0;
    _bgImgView.width = self.frame.size.width;
    _bgImgView.height = _layout.thumbCommentHeight;
    
    UIView * lastView = _bgImgView;
    
    if (_likeArray.count != 0) {
        _thumbLabel.hidden = NO;
        _thumbLabel.top = 10;
        _thumbLabel.left = kDynamicsNameDetailPadding;
        _thumbLabel.width = self.frame.size.width - kDynamicsNameDetailPadding*2;
        _thumbLabel.height = _layout.thumbLayout.textBoundingSize.height;
        _thumbLabel.textLayout = _layout.thumbLayout;
        lastView = _thumbLabel;
    }else{
        _thumbLabel.hidden = YES;
    }
    
    
    if (_likeArray.count != 0 && _commentArray.count != 0) {
        _dividingLine.hidden = NO;
        _dividingLine.top = _thumbLabel.bottom;
        _dividingLine.left = 0;
        _dividingLine.width = self.frame.size.width;
        _dividingLine.height = .5;
        lastView = _dividingLine;
    }else{
        _dividingLine.hidden = YES;
    }
    
    if (_commentArray.count != 0) {
        _commentTable.hidden = NO;
        _commentTable.left = _bgImgView.left;
        _commentTable.top = lastView == _dividingLine ? lastView.bottom + .5 : lastView.top + 10;
        _commentTable.width = _bgImgView.width;
        _commentTable.height = _layout.commentHeight;
        
        [_commentTable reloadData];
    }else{
        _commentTable.hidden = YES;
    }
    
}
#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YYTextLayout * layout = self.commentArray[indexPath.row];
    return layout.textBoundingSize.height + kDynamicsGrayPicPadding*2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell;//这里不使用重用机制(会出现评论窜位bug)
    
    YYTextLayout * layout = self.commentArray[indexPath.row];

    YYLabel * label;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"commentCell"];
        cell.backgroundColor = [UIColor clearColor];
        label = [YYLabel new];
        [cell addSubview:label];
    }
    
    label.top = kDynamicsGrayPicPadding;
    label.left = kDynamicsNameDetailPadding;
    label.width = self.frame.size.width - kDynamicsNameDetailPadding*2;
    label.height = layout.textBoundingSize.height;
    label.textLayout = layout;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    if (_cell.delegate != nil && [_cell.delegate respondsToSelector:@selector(DynamicsCell:didClickComment:)]) {
        [_cell.delegate DynamicsCell:_cell didClickComment:(DynamicsCommentItemModel *)_cell.layout.model.commentArr[indexPath.row]];
    }
}
-(UIImageView *)bgImgView
{
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        UIImage *bgImage = [[[UIImage imageNamed:@"LikeCmtBg"] stretchableImageWithLeftCapWidth:40 topCapHeight:30] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        _bgImgView.image = bgImage;
        _bgImgView.backgroundColor = [UIColor clearColor];
    }
    return _bgImgView;
}
-(YYLabel *)thumbLabel
{
    if (!_thumbLabel) {
        _thumbLabel = [YYLabel new];
    }
    return _thumbLabel;
}
-(UIView *)dividingLine
{
    if (!_dividingLine) {
        _dividingLine = [UIView new];
        _dividingLine.backgroundColor = RGBSAMECOLOR(210);
    }
    return _dividingLine;
}
-(UITableView *)commentTable
{
    if (!_commentTable) {
        _commentTable = [UITableView new];
        _commentTable.dataSource = self;
        _commentTable.delegate = self;
        _commentTable.scrollEnabled = NO;
        _commentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentTable.backgroundColor = [UIColor clearColor];
    }
    return _commentTable;
}
@end

@implementation NewDynamicsTableViewCell
- (void)actionBlock:(TwoDataBlock)block
{
    self.block = block;
}
+(instancetype)cellWith:(UITableView*)tabelView{
    NewDynamicsTableViewCell *cell = (NewDynamicsTableViewCell *)[tabelView dequeueReusableCellWithIdentifier:@"NewDynamicsTableViewCell"];
    if (!cell) {
        cell = [[NewDynamicsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NewDynamicsTableViewCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NewDynamicsLayout *)layout{
    
    return layout.height;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)setup
{
    [self.contentView addSubview:self.portrait];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.locButton];
    [self.contentView addSubview:self.vBgV];
    [self setupBgVideoPlayer];
    [self.vBgV addSubview:self.coverImageView];
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    [self.contentView addSubview:self.chatBtn];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.moreLessDetailBtn];
    [self.contentView addSubview:self.picContainerView];
    [self.contentView addSubview:self.grayView];
    [self.contentView addSubview:self.spreadBtn];
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.deleteBtn];
    [self.contentView addSubview:self.menuBtn];
    [self.contentView addSubview:self.thumbCommentView];
    [self.contentView addSubview:self.dividingLine];
    
    [self setTopBtns];
    [self setBottomBtns];
}
- (void)setTopBtns{
    _topBtns = [NSMutableArray array];
    NSArray* subtitleArray =@[
    @{@"点赞":[UIImage imageWithColor:HEXCOLOR(0x21c244) rect:CGRectMake(0, 0, 16, 16)]},
    @{@"收藏":[UIImage imageWithColor:HEXCOLOR(0xe22323) rect:CGRectMake(0, 0, 16, 16)]}
    ,@{@"分享":[UIImage imageWithColor:HEXCOLOR(0xf59b22) rect:CGRectMake(0, 0, 16, 16)]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.userInteractionEnabled = NO;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
//            button.layer.masksToBounds = YES;
//            button.layer.cornerRadius = 6;
//            button.layer.borderWidth = 1;
//        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
//        [button setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        button.contentMode = UIViewContentModeScaleAspectFit;

        button.contentMode = UIViewContentModeScaleAspectFit;
//        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
//        button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
//        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        //        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [_topBtns addObject:button];
    }
    [_topBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kDynamicsNormalPadding);
        make.height.mas_equalTo(kDynamicsNameHeight);
    }];
//    NSString* namStr =  model.nickname;
    CGFloat typeStringWidth = 80;
//    [NSString getTextWidth:namStr withFontSize:kFontSize(13) withHeight:kDynamicsNameHeight];
    [_topBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:2 leadSpacing:kDynamicsNormalPadding+kDynamicsPortraitWidthAndHeight+kDynamicsPortraitNamePadding+typeStringWidth tailSpacing: kDynamicsNormalPadding+60];
    
}
- (void)setBottomBtns{
    _funcBtns = [NSMutableArray array];
    NSArray* subtitleArray =@[
    @{@"点赞":[UIImage imageWithColor:HEXCOLOR(0x21c244) rect:CGRectMake(0, 0, 16, 16)]},
    @{@"收藏":[UIImage imageWithColor:HEXCOLOR(0xe22323) rect:CGRectMake(0, 0, 16, 16)]}
    ,@{@"分享":[UIImage imageWithColor:HEXCOLOR(0xf59b22) rect:CGRectMake(0, 0, 16, 16)]}
    ,@{@"评论":[UIImage imageWithColor:HEXCOLOR(0xf59b22) rect:CGRectMake(0, 0, 16, 16)]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
//            button.layer.masksToBounds = YES;
//            button.layer.cornerRadius = 6;
//            button.layer.borderWidth = 1;
        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        //        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:button];
        [_funcBtns addObject:button];
    }
    UIButton* lastBtn = _funcBtns.lastObject;
    lastBtn.hidden = YES;
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:13 tailSpacing:13];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.height.equalTo(@50);
    }];
}
- (void)reloadBgVideoPlayerData:(DynamicsModel*)model{
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    // 设置播放地址，直播、点播都可以
    playerModel.videoURL = model.video.firstObject;
    // 开始播放
    _playerView.autoPlay = NO;
    [_playerView.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.video_picture.firstObject]]];
    [_playerView playWithModel:playerModel];
//    _playerView.state = StateStopped;
    [_coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.video_picture.firstObject]] forState:0];
    [_coverImageView.imageView setContentMode:UIViewContentModeScaleAspectFit];
}

- (UIButton *)coverImageView {
    if (!_coverImageView) {
        _coverImageView                        = [[UIButton alloc] init];
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode            = UIViewContentModeScaleAspectFit;
        _coverImageView.hidden                  = YES;
        _coverImageView.backgroundColor = [UIColor blackColor];
        [_coverImageView addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        UIButton *levBut = [[UIButton alloc]init];
        self.levBut = levBut;
    //    self.levBut.hidden = YES;
        levBut.userInteractionEnabled = NO;
    //    levBut.tag = 8002;
        [self.coverImageView addSubview:levBut];
        [levBut mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(8);
    //        make.right.mas_equalTo(-8);
            make.center.mas_equalTo(self.coverImageView);
            make.height.mas_equalTo(50);
            make.width.mas_equalTo(50);
        }];
        levBut.contentMode = UIViewContentModeScaleAspectFill;
        levBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        levBut.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        [levBut setImage:kIMG(@"M_pauseBtnIcon") forState:0];
//        [levBut addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _coverImageView;
}
- (void)playVideo:(UIButton*)sender{
//    self.coverImageView.hidden = YES;
//    [_playerView resume];
    WS(weakSelf);
    if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DidClickVideoInDynamicsCell:)]) {
        [weakSelf.delegate DidClickVideoInDynamicsCell:weakSelf];
    }
}

- (void)setupBgVideoPlayer{//:(DynamicsModel*)model
    
    _playerView = [[SuperPlayerView alloc] init];
    // 设置代理，用于接受事件
    _playerView.delegate = self;
    // 设置父View，_playerView会被自动添加到holderView下面
    _playerView.fatherView = self.vBgV;
//    _playerView.isFullScreen = true;

    _playerView.layoutStyle = SuperPlayerLayoutStyleCompact;
    SuperPlayerModel *playerModel = [[SuperPlayerModel alloc] init];
    // 设置播放地址，直播、点播都可以
    playerModel.videoURL = @"";
    // 开始播放
    [_playerView playWithModel:playerModel];
//    [self.playerView.coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.video_picture.firstObject]]];
    self.playerView.controlView.disableCaptureBtn = true;
    self.playerView.controlView.disableDanmakuBtn = true;
    self.playerView.controlView.disableMoreBtn = true;
    self.playerView.controlView.disableBackBtn = true;
    
}

-(void)setLayout:(NewDynamicsLayout *)layout
{
    UIView * lastView;
    _layout = layout;
    DynamicsModel * model = layout.model;
    
    //头像
    _portrait.left = kDynamicsNormalPadding;
    _portrait.top = kDynamicsNormalPadding;
    _portrait.size = CGSizeMake(kDynamicsPortraitWidthAndHeight, kDynamicsPortraitWidthAndHeight);
    [_portrait sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgHeader,model.portrait]]];
    if (model.avatar.length>0) {
        NSString* title = [NSString stringWithFormat:@"mine_avator%li",[model.avatar integerValue]];
        [_portrait setImage:[UIImage imageNamed:title]];
    }
    //昵称
    NSString* namStr = model.nick? model.nick: model.nickname;
    CGFloat typeStringWidth =  [NSString getTextWidth:namStr withFontSize:kFontSize(13) withHeight:kDynamicsNameHeight];
    _nameLabel.text = namStr;
    _nameLabel.top = kDynamicsNormalPadding;
    _nameLabel.left = _portrait.right + kDynamicsPortraitNamePadding;
//    CGSize nameSize = [_nameLabel sizeThatFits:CGSizeZero];
    _nameLabel.width = 120;
    _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    //typeStringWidth;
    _nameLabel.height = kDynamicsNameHeight;

    [_locButton
             setImage:[UIImage imageNamed:@"M_location"] forState:0];
    [_locButton setTitle:[NSString stringWithFormat:@"%@",model.location_name] forState:0];
    [_locButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
    _locButton.hidden = model.location_name.length>0?NO:YES;
    _locButton.userInteractionEnabled = YES;
//    [_locButton addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
    [_locButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.bottom.mas_equalTo(self.portrait.mas_bottom);
        make.width.mas_equalTo(100);
//        make.height.mas_equalTo(kDynamicsNameHeight);
        make.top.mas_equalTo(self.portrait.mas_top);
    }];
    _locButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _locButton.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    //昵称
    [_chatBtn setTitle:@"私聊" forState:0];
    [_chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(kDynamicsNormalPadding);
        make.right.equalTo(self.contentView.mas_right).offset(-kDynamicsNormalPadding);
        make.height.equalTo(@27);
        make.width.equalTo(@60);
    }];
    _chatBtn.layer.masksToBounds = true;
    _chatBtn.layer.cornerRadius = 27/2;
    //描述
    _detailLabel.left = _portrait.left;
    _detailLabel.top = _portrait.bottom + kDynamicsNameDetailPadding;
    _detailLabel.width = MAINSCREEN_WIDTH - kDynamicsNormalPadding * 2 ;
//    _detailLabel.width = MAINSCREEN_WIDTH - kDynamicsNormalPadding * 2 - kDynamicsPortraitNamePadding - kDynamicsPortraitWidthAndHeight;
    _detailLabel.height = layout.detailLayout.textBoundingSize.height;
    _detailLabel.textLayout = layout.detailLayout;
    lastView = _detailLabel;
    
    //展开/收起按钮
    _moreLessDetailBtn.left = _portrait.left;
    _moreLessDetailBtn.top = _detailLabel.bottom + kDynamicsNameDetailPadding;
    _moreLessDetailBtn.height = kDynamicsMoreLessButtonHeight;
    [_moreLessDetailBtn sizeToFit];
    
    if (model.shouldShowMoreButton) {
        _moreLessDetailBtn.hidden = NO;
        
        if (model.isOpening) {
            [_moreLessDetailBtn setTitle:@"收起" forState:UIControlStateNormal];
        }else{
            [_moreLessDetailBtn setTitle:@"全文" forState:UIControlStateNormal];
        }
        
        lastView = _moreLessDetailBtn;
    }else{
        _moreLessDetailBtn.hidden = YES;
    }
    //视频
    if (model.video.count != 0) {
        _vBgV.hidden = NO;
        _playerView.hidden = NO;
        _coverImageView.hidden = NO;

        _vBgV.left = _portrait.left;
        _vBgV.top = lastView.bottom + kDynamicsNameDetailPadding;
        _vBgV.width = layout.videoContainerSize.width;
        _vBgV.height = layout.videoContainerSize.height;
        
        [self reloadBgVideoPlayerData:model];
//        [_playerView setState:StateStopped];
//        _playerView.coverImageView.alpha = 1;
        lastView = _vBgV;
    }else{
        _vBgV.hidden = YES;
        _playerView.hidden = YES;
        _coverImageView.hidden = YES;
        [_playerView resetPlayer];
    }
    //图片集
    if (model.photocollections.count != 0||
        model.thumbs.count != 0) {
        _picContainerView.hidden = NO;

        _picContainerView.left = _portrait.left;
        _picContainerView.top = lastView.bottom + kDynamicsNameDetailPadding;
        _picContainerView.width = layout.photoContainerSize.width;
        _picContainerView.height = layout.photoContainerSize.height;
        _picContainerView.picPathStringsArray = model.photocollections?model.photocollections:model.thumbs;
        _picContainerView.myModel = self.myModel;
        lastView = _picContainerView;
    }else{
        _picContainerView.hidden = YES;
    }
    //头条
    if (model.pagetype == 1) {
        _grayView.hidden = NO;
        
        _grayView.left = _portrait.left;
        _grayView.top = lastView.bottom + kDynamicsNameDetailPadding;
        _grayView.width = _detailLabel.right - _grayView.left;
        _grayView.height = kDynamicsGrayBgHeight;
        
        [_grayView.thumbImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImgHeader,model.thumb]]];
        _grayView.dspLabel.height = layout.dspLayout.textBoundingSize.height;
        _grayView.dspLabel.centerY = _grayView.thumbImg.centerY;
        _grayView.dspLabel.textLayout = layout.dspLayout;
        
        lastView = _grayView;
    }else{
        _grayView.hidden = YES;
    }
    
    //推广
    _spreadBtn.left = _portrait.left;
    _spreadBtn.top = lastView.bottom + kDynamicsNameDetailPadding;;
    
    if (model.spreadparams.count != 0) {
        _spreadBtn.hidden = NO;
        [_spreadBtn setTitle:model.spreadparams[@"name"] forState:UIControlStateNormal];
        CGSize fitSize = [_spreadBtn sizeThatFits:CGSizeZero];
        _spreadBtn.width = fitSize.width > _detailLabel.size.width ? _detailLabel.size.width : fitSize.width;
        _spreadBtn.height = kDynamicsSpreadButtonHeight;
        
        lastView = _spreadBtn;
    }else if (model.companyparams.count != 0){
        _spreadBtn.hidden = NO;
        [_spreadBtn setTitle:model.companyparams[@"name"] forState:UIControlStateNormal];
        CGSize fitSize = [_spreadBtn sizeThatFits:CGSizeZero];
        _spreadBtn.width = fitSize.width > _detailLabel.size.width ? _detailLabel.size.width : fitSize.width;
        _spreadBtn.height = kDynamicsSpreadButtonHeight;
        
        lastView = _spreadBtn;
    }else{
        _spreadBtn.hidden = YES;
    }
    
    //时间
    _dateLabel.left = _detailLabel.left;
    _dateLabel.top = lastView.bottom + kDynamicsPortraitNamePadding;
    NSString * newTime = [self formateDate:model.exttime withFormate:@"yyyyMMddHHmmss"];
    _dateLabel.text = newTime;
    CGSize dateSize = [_dateLabel sizeThatFits:CGSizeMake(100, kDynamicsNameHeight)];
    _dateLabel.width = dateSize.width;
    _dateLabel.height = kDynamicsNameHeight;
    
        
    _deleteBtn.left = _dateLabel.right + kDynamicsPortraitNamePadding;
    _deleteBtn.top = _dateLabel.top;
    CGSize deleteSize = [_deleteBtn sizeThatFits:CGSizeMake(100, kDynamicsNameHeight)];
    _deleteBtn.width = deleteSize.width;
    _deleteBtn.height = kDynamicsNameHeight;
    
    //更多
    _menuBtn.left = _detailLabel.right - 30 + 5;
    _menuBtn.top = lastView.bottom + kDynamicsPortraitNamePadding - 8;
    _menuBtn.size = CGSizeMake(30, 30);
    
    if (model.likeArr.count != 0 || model.commentArr.count != 0) {
        _thumbCommentView.hidden = NO;
        //点赞/评论
        _thumbCommentView.left = _detailLabel.left;
        _thumbCommentView.top = _dateLabel.bottom + kDynamicsPortraitNamePadding;
        _thumbCommentView.width = _detailLabel.width;
        _thumbCommentView.height = layout.thumbCommentHeight;
        
        [_thumbCommentView setWithLikeArr:model.likeArr CommentArr:model.commentArr DynamicsLayout:layout];
    }else{
        _thumbCommentView.hidden = YES;
    }
    
    
    //分割线
    _dividingLine.left = 15;
    _dividingLine.height = .5;
    _dividingLine.width = MAINSCREEN_WIDTH - 15;
    _dividingLine.bottom = layout.height - .5;
    
    WS(weakSelf);
    layout.clickUserBlock = ^(NSString *userID) {//点赞评论区域点击用户昵称操作
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DynamicsCell:didClickUser:)]) {
            [weakSelf.delegate DynamicsCell:weakSelf didClickUser:userID];
        }
    };
    
    layout.clickUrlBlock = ^(NSString *url) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DynamicsCell:didClickUrl:PhoneNum:)]) {
            [weakSelf.delegate DynamicsCell:weakSelf didClickUrl:url PhoneNum:nil];
        }
    };
    
    layout.clickPhoneNumBlock = ^(NSString *phoneNum) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DynamicsCell:didClickUrl:PhoneNum:)]) {
            [weakSelf.delegate DynamicsCell:weakSelf didClickUrl:nil PhoneNum:phoneNum];
        }
    };
    _chatBtn.hidden = [[UserInfoManager GetNSUserDefaults].data.ID isEqualToString:model.uid];
//    [self alterTopButton:model];
//    [self alterButton:model];
    for (UIButton* btn in self.funcBtns) {
        btn.hidden = YES;
    }
    for (UIButton* btn in self.topBtns) {
        btn.hidden = YES;
    }
}
- (void)alterTopButton:(DynamicsModel*)model{

    [self.contentView layoutIfNeeded];
//    [_topBtns mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(kDynamicsNormalPadding);
//        make.height.mas_equalTo(kDynamicsNameHeight);
//    }];
//    NSString* namStr =  model.nickname;
//    CGFloat typeStringWidth =  [NSString getTextWidth:namStr withFontSize:kFontSize(15) withHeight:kDynamicsNameHeight];
//    [_topBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:2 leadSpacing:kDynamicsNormalPadding+kDynamicsPortraitWidthAndHeight+kDynamicsPortraitNamePadding+typeStringWidth tailSpacing: kDynamicsNormalPadding+60];
    
    
    NSArray* subtitleArray =@[
     @{@"":[UIImage imageNamed:[NSString stringWithFormat:@"M_sex_%ld",(long)model.sex]]},
     @{@"":[UIImage imageNamed:[NSString stringWithFormat:@"M_ is_office%ld",(long)model.is_office]]},
     
     @{@"":model.vipLevel >0? model.vipLevel <5?[UIImage imageNamed:[NSString stringWithFormat:@"M_vs_%ld",model.vipLevel]]:[UIImage imageNamed:[NSString stringWithFormat:@"M_vs_%@",@"5"]]:[UIImage new]},
//     @{@"":[UIImage imageNamed:[NSString stringWithFormat:@"M_vs_%@",@"5"]]},
     @{@"":[UIImage imageNamed:@"detail_share"]}
     ];
     for (int i = 0; i < subtitleArray.count; i++) {
         NSDictionary* dic = subtitleArray[i];
         UIButton* button = _topBtns[i];
//         [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
         [button setImage:dic.allValues[0] forState:UIControlStateNormal];
//         [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
         button.tag = [model.ID integerValue];
     }
     
     UIButton* btn0 = _topBtns[0];
     [btn0 addTarget:self action:@selector(delayLikeClick:) forControlEvents:UIControlEventTouchUpInside];
     
     UIButton* btn1 = _topBtns[1];
     [btn1 addTarget:self action:@selector(pushCRClick:) forControlEvents:UIControlEventTouchUpInside];
     
     UIButton* btn2 = _topBtns[2];
     btn2.hidden = [[NSNumber numberWithInteger:model.is_office]boolValue]? YES:model.vipLevel >0 ?NO: YES;
//    btn2.hidden = [[NSNumber numberWithInteger:model.is_office]boolValue]? YES: NO ;
     [btn2 addTarget:self action:@selector(delayCollectClick:) forControlEvents:UIControlEventTouchUpInside];
     
     UIButton* btn3 = _topBtns[3];
     btn3.hidden = YES;
     [btn3 addTarget:self action:@selector(pushShareVCClick:) forControlEvents:UIControlEventTouchUpInside];
     
}
- (void)alterButton:(DynamicsModel*)model{
    
   [self.contentView layoutIfNeeded];
   self.likes = model.likes;
    self.rewards = model.rewards;
   NSArray* subtitleArray =@[
    @{[NSString stringWithFormat:@"%ld",(long)model.likes]:[[NSNumber numberWithInteger:model.is_love]boolValue]? [UIImage imageNamed:@"detail_like_selected"]:[UIImage imageNamed:@"detail_like_normal"]},
    @{[NSString stringWithFormat:@"%ld",(long)model.comments]:[UIImage imageNamed:@"detail_comment"]},
    @{[NSString stringWithFormat:@"%ld",(long)model.rewards]:[UIImage imageNamed:@"M_hbic"] },
     
    @{@"分享":[UIImage imageNamed:@"detail_share"]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton* button = _funcBtns[i];
        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
//        button.tag = [model.ID integerValue];
    }
    
    UIButton* btn0 = _funcBtns[0];
    btn0.selected = [[NSNumber numberWithInteger:model.is_love]boolValue];
    [btn0 addTarget:self action:@selector(delayLikeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn1 = _funcBtns[1];
    [btn1 addTarget:self action:@selector(pushCRClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn2 = _funcBtns[2];
    btn2.selected = [[NSNumber numberWithInteger:model.is_collect]boolValue];
    [btn2 addTarget:self action:@selector(popUpClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn3 = _funcBtns[3];
    [btn3 addTarget:self action:@selector(pushShareVCClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)popUpClick{
    NSArray* arr = @[
        @[
            @"优先",
            @"豪",
        ]
    ];
    RewardPopUpView* popupView = [[RewardPopUpView alloc]init];
    [popupView richElementsInViewWithModel:arr WithConfig:self.layout.model WithTModel:@(99)];
    [popupView showInApplicationKeyWindow];
    [popupView actionBlock:^(NSNumber* data) {
        if ([data integerValue] == 0) {
            id object = [self nextResponder];
            while (![object isKindOfClass:[UIViewController class]] && object != nil) {
                object = [object nextResponder];
            }
            UIViewController *superController = (UIViewController*)object;
//            [superController.navigationController  showViewController:[LevelVC new] sender:nil];
            [LevelVC pushFromVC:superController
                   requestParams:@1
                         success:^(id data) {
            }];
            
        }
        else if ([data integerValue] == 2){
            UIButton* btn2 = self.funcBtns[2];
            NSInteger l = self.rewards;
//                if (sender.selected) {
                    l +=  1;
//                }else{
//                    if (l > 0) {
//                        l -=  1;
//                    }
//                }
            self.rewards = l;
            [btn2 setTitle:[NSString stringWithFormat:@"%ld",(long)self.rewards] forState:0];
            [btn2 setImage:[UIImage imageNamed:@"M_hbic"] forState:0];
            [btn2 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
            self.layout.model.rewards = self.rewards;
            [[MineVM new] network_getUserExtendInfoWithRequestParams:@(1)
                    success:^(HomeModel * _Nonnull model) {
                self.myModel = model;
            } failed:^(id data) {
                    
            }];
            if (self.block) {
                self.block(btn2,self.layout.model);
            }
        }
        else if ([data integerValue] == 3){
            [self popUpClick];
        }
    }];
}
- (void)pushCRClick:(UIButton*)sender{
    if(!self.myModel.data.member_card.is_vip){
        [YKToastView showToastText:@"只有VIP用户才可以哦"];
        return;
    }
    if (self.block) {
        self.block(sender,self.layout.model);
    }
}

- (void)pushShareVCClick:(UIButton*)sender{
    
}
- (void)likeClick:(UIButton*)sender{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayLikeClick:) object:sender];
    [self performSelector:@selector(delayLikeClick:) withObject:sender afterDelay:1];
}

- (void)delayLikeClick:(UIButton*)sender{
    sender.selected = !sender.selected;
//    SplashView *splashView = [[SplashView alloc] initWithFrame:CGRectMake((sender.bounds.size.width-25)/2, 0,  25, 25) withAnimationNamed:sender.isSelected ?@"likeAni":@"likeAni"];
//    __weak SplashView *weakSplashView = splashView;
//    [splashView showOnView:sender withAnimationCompleter:^{
//        [UIView animateWithDuration:0.5 animations:^{
//            weakSplashView.alpha = 0;
//        } completion:^(BOOL finished) {
//            [weakSplashView removeFromSuperview];
//            [self likeEvent:sender];
//        }];
//    }];
    [self likeEvent:sender];
    
}
- (void)likeEvent:(UIButton*)sender{
    
    NSString * str = [NSString stringWithFormat:@"%d",sender.isSelected];
    
    [sender setImage:sender.isSelected ? [UIImage imageNamed:@"detail_like_selected"]:[UIImage imageNamed:@"detail_like_normal"] forState:UIControlStateNormal];
    NSInteger l = self.likes;
    if (sender.selected) {
        l +=  1;
    }else{
        if (l > 0) {
            l -=  1;
        }
    }
    self.likes = l;
    [sender setTitle:[NSString stringWithFormat:@"%ld",(long)self.likes] forState:UIControlStateNormal];
    
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType61] andType:All andWith:@{@"like":str,@"bbs_id":self.layout.model.ID} success:^(NSDictionary *bdic) {
    //        NSDictionary* result = bdic[@"result"];
            if ([NSString getDataSuccessed:bdic]) {
                
                self.layout.model.is_love =sender.selected ? 1 :0;
                self.layout.model.likes = self.likes;
                if (self.block) {
                    self.block(sender,self.layout.model);
                }
                
            }
            else{
               
            }
        } error:^(NSError *error) {
            
        }];
}
- (void)collectClick:(UIButton*)sender{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayCollectClick:) object:sender];
    [self performSelector:@selector(delayCollectClick:) withObject:sender afterDelay:1];
   
}

- (void)delayCollectClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    [self collectEvent:sender];
//    SplashView *splashView = [[SplashView alloc] initWithFrame:CGRectMake((sender.bounds.size.width-25)/2, 0,  25, 25) withAnimationNamed:sender.isSelected ?@"colAni":@"colAni"];
//    __weak SplashView *weakSplashView = splashView;
//    [splashView showOnView:sender withAnimationCompleter:^{
//        [UIView animateWithDuration:0.5 animations:^{
//            weakSplashView.alpha = 0;
//        } completion:^(BOOL finished) {
//            [weakSplashView removeFromSuperview];
//            [self collectEvent:sender];
//        }];
//    }];
}
- (void)collectEvent:(UIButton*)sender{
    NSString * str = [NSString stringWithFormat:@"%d",sender.isSelected];
    
    [sender setImage:sender.isSelected ? [UIImage imageNamed:@"detail_collect_selected"]:[UIImage imageNamed:@"detail_collect_normal"] forState:UIControlStateNormal];
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType19] andType:All andWith:@{@"collect":str,@"id":@(sender.tag)} success:^(NSDictionary *bdic) {
    //        NSDictionary* result = bdic[@"result"];
            if ([NSString getDataSuccessed:bdic]) {
                
                self.layout.model.is_collect =sender.selected ? 1 :0;
                if (self.block) {
                    self.block(sender,self.layout.model);
                }
            }
            else{
                if (bdic&&
                    [bdic.allKeys containsObject:@"msg"]) {
                    NSString* str = [NSString stringWithFormat:@"%@",bdic[@"msg"]];
                    [YKToastView showToastText:str];
                }
                [sender setImage:[UIImage imageNamed:@"detail_collect_normal"] forState:UIControlStateNormal];
            }
        } error:^(NSError *error) {
            
        }];
}
#pragma mark - 弹出JRMenu
- (void)presentMenuController
{
    DynamicsModel * model = _layout.model;
    if (!model.isThumb) {//点赞
        if (!_jrMenuView) {
            _jrMenuView = [[JRMenuView alloc] init];
        }
        [_jrMenuView setTargetView:_menuBtn InView:self.contentView];
        _jrMenuView.delegate = self;
        [_jrMenuView setTitleArray:@[@"点赞",@"评论"]];
        [self.contentView addSubview:_jrMenuView];
        [_jrMenuView show];
    }else{//取消点赞
        if (!_jrMenuView) {
            _jrMenuView = [[JRMenuView alloc] init];
        }
        [_jrMenuView setTargetView:_menuBtn InView:self.contentView];
        _jrMenuView.delegate = self;
        [_jrMenuView setTitleArray:@[@"取消点赞",@"评论"]];
        [self.contentView addSubview:_jrMenuView];
        [_jrMenuView show];
    }
}
#pragma mark - 点击JRMenu上的Btn
-(void)hasSelectedJRMenuIndex:(NSInteger)jrMenuIndex
{
    DynamicsModel * model = _layout.model;
    if (jrMenuIndex == 0) {
        if (!model.isThumb) {
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DidClickThunmbInDynamicsCell:)]) {
                [_delegate DidClickThunmbInDynamicsCell:self];
            }
        }else{
            if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DidClickCancelThunmbInDynamicsCell:)]) {
                [_delegate DidClickCancelThunmbInDynamicsCell:self];
            }
        }
    }else{
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(DidClickCommentInDynamicsCell:)]) {
            [_delegate DidClickCommentInDynamicsCell:self];
        }
    }
}
#pragma mark - getter
-(UIImageView *)portrait
{
    if(!_portrait){
        _portrait = [UIImageView new];
        _portrait.userInteractionEnabled = YES;
        _portrait.backgroundColor = [UIColor clearColor];
        WS(weakSelf);
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DynamicsCell:didClickUser:)]) {
                [weakSelf.delegate DynamicsCell:weakSelf didClickUser:weakSelf.layout.model.uid];
            }
        }];
        [_portrait addGestureRecognizer:tapGR];
    }
    return _portrait;
}
-(YYLabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [YYLabel new];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor colorWithRed:74/255.0 green:90/255.0 blue:133/255.0 alpha:1];
        WS(weakSelf);
        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DynamicsCell:didClickUser:)]) {
                [weakSelf.delegate DynamicsCell:weakSelf didClickUser:weakSelf.layout.model.uid];
            }
        }];
        [_nameLabel addGestureRecognizer:tapGR];
    }
    return _nameLabel;
}

- (UIButton*)locButton{
    if (!_locButton) {
        _locButton = [[UIButton alloc]init];
        _locButton.tag = 201;
        
        _locButton.adjustsImageWhenHighlighted = NO;
        _locButton.titleLabel.numberOfLines = 0;
        _locButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _locButton.titleLabel.font = kFontSize(14);
    //        titButton.layer.masksToBounds = YES;
    //        titButton.layer.cornerRadius = 8;
    //        button.layer.borderWidth = 0;
        [_locButton setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        _locButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _locButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            
        [_locButton
                 setImage:[UIImage imageNamed:@"M_location"] forState:0];
        [_locButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
        _locButton.hidden = YES;
        _locButton.userInteractionEnabled = YES;
        _locButton.adjustsImageWhenHighlighted = NO;
    //    [_locButton addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        WS(weakSelf);
        [_locButton bk_addEventHandler:^(id sender) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DynamicsCell:didClickUser:)]) {
                [weakSelf.delegate DynamicsCell:weakSelf didClickUser:weakSelf.layout.model.uid];
            }
        } forControlEvents:UIControlEventTouchUpInside];
        
//        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
//            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DynamicsCell:didClickUser:)]) {
//                [weakSelf.delegate DynamicsCell:weakSelf didClickUser:weakSelf.layout.model.uid];
//            }
//        }];
//        [_locButton addGestureRecognizer:tapGR];

    }
    return _locButton;
}

- (UIView*)vBgV{
    if (!_vBgV) {
        _vBgV = [[UIView alloc]init];
//        self.vBgV.userInteractionEnabled = NO;
//        _vBgV.tag = 8005;
        [_vBgV setBackgroundColor:UIColor.clearColor];
        _vBgV.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _vBgV;
}
-(YYLabel *)detailLabel
{
    if (!_detailLabel) {
        _detailLabel = [YYLabel new];
        _detailLabel.textLongPressAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
//            containerView.backgroundColor = RGBA_COLOR(1, 1, 1, .2);
            [SVProgressHUD showSuccessWithStatus:@"文字复制成功!"];
            UIPasteboard * board = [UIPasteboard generalPasteboard];
            board.string = text.string;
//            [Utils delayTime:.5 TimeOverBlock:^{
//                containerView.backgroundColor = [UIColor clearColor];
//            }];
            [SVProgressHUD dismissWithDelay:1];
            
        };
        WS(weakSelf);
        _detailLabel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DidClickContentInDynamicsCell:)]) {
                [weakSelf.delegate DidClickContentInDynamicsCell:weakSelf];
            }
        };
    }
    return _detailLabel;
}

-(UIButton *)chatBtn
{
    if (!_chatBtn) {
        _chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chatBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _chatBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_chatBtn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
//        _chatBtn.backgroundColor = YBGeneralColor.themeColor;
        _chatBtn.backgroundColor = [UIColor clearColor];//imodel
        WS(weakSelf);
        [_chatBtn bk_addEventHandler:^(id sender) {
            if(!self.myModel.data.member_card.is_vip){
                [YKToastView showToastText:@"只有VIP用户才可以哦"];
                return;
            }
            if (weakSelf.delegate != nil && [weakSelf.delegate respondsToSelector:@selector(DidClickChatInDynamicsCell:)]) {
                [weakSelf.delegate DidClickChatInDynamicsCell:weakSelf];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _chatBtn;
}
-(UIButton *)moreLessDetailBtn
{
    if (!_moreLessDetailBtn) {
        _moreLessDetailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _moreLessDetailBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_moreLessDetailBtn setTitleColor:[UIColor colorWithRed:74/255.0 green:90/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
        _moreLessDetailBtn.hidden = YES;
        WS(weakSelf);
        [_moreLessDetailBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(DidClickMoreLessInDynamicsCell:)]) {
                [weakSelf.delegate DidClickMoreLessInDynamicsCell:weakSelf];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreLessDetailBtn;
}
-(SDWeiXinPhotoContainerView *)picContainerView
{
    if (!_picContainerView) {
        _picContainerView = [SDWeiXinPhotoContainerView new];
        _picContainerView.hidden = YES;
    }
    return _picContainerView;
}
-(UIButton *)spreadBtn
{
    if (!_spreadBtn) {
        _spreadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _spreadBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _spreadBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [_spreadBtn setTitleColor:[UIColor colorWithRed:74/255.0 green:90/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
        WS(weakSelf);
        [_spreadBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.delegate != nil && [weakSelf.delegate respondsToSelector:@selector(DidClickSpreadInDynamicsCell:)]) {
                [weakSelf.delegate DidClickSpreadInDynamicsCell:weakSelf];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _spreadBtn;
}
-(NewDynamicsGrayView *)grayView
{
    if (!_grayView) {
        _grayView = [NewDynamicsGrayView new];
        _grayView.cell = self;
    }
    return _grayView;
}
-(YYLabel *)dateLabel
{
    if (!_dateLabel) {
        _dateLabel = [YYLabel new];
        _dateLabel.textColor = [UIColor lightGrayColor];
        _dateLabel.font = [UIFont systemFontOfSize:13];
    }
    return _dateLabel;
}
-(UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.hidden = YES;
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        _deleteBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_deleteBtn setTitleColor:[UIColor colorWithRed:74/255.0 green:90/255.0 blue:133/255.0 alpha:1] forState:UIControlStateNormal];
        WS(weakSelf);
        [_deleteBtn bk_addEventHandler:^(id sender) {
            if (weakSelf.delegate != nil && [weakSelf.delegate respondsToSelector:@selector(DidClickDeleteInDynamicsCell:)]) {
                [weakSelf.delegate DidClickDeleteInDynamicsCell:weakSelf];
            }
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteBtn;
}
-(UIButton *)menuBtn
{
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuBtn.hidden = YES;
        _menuBtn.contentMode = UIViewContentModeScaleAspectFit;
        [_menuBtn setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        WS(weakSelf);
        [_menuBtn bk_addEventHandler:^(id sender) {
            [weakSelf presentMenuController];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return _menuBtn;
}
-(NewDynamicsThumbCommentView *)thumbCommentView
{
    if (!_thumbCommentView) {
        _thumbCommentView = [NewDynamicsThumbCommentView new];
        _thumbCommentView.cell = self;
    }
    return _thumbCommentView;
}
-(UIView *)dividingLine
{
    if (!_dividingLine) {
        _dividingLine = [UIView new];
        _dividingLine.backgroundColor = [UIColor lightGrayColor];
        _dividingLine.alpha = .3;
    }
    return _dividingLine;
}

- (NSString *)formateDate:(NSString *)dateString withFormate:(NSString *) formate
{
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formate];
    
    NSDate * nowDate = [NSDate date];
    
    /////  将需要转换的时间转换成 NSDate 对象
    NSDate * needFormatDate = [dateFormatter dateFromString:dateString];
    /////  取当前时间和转换时间两个日期对象的时间间隔
    /////  这里的NSTimeInterval 并不是对象，是基本型，其实是double类型，是由c定义的:  typedef double NSTimeInterval;
    NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
    
    //// 再然后，把间隔的秒数折算成天数和小时数：
    
    NSString *dateStr = @"";
    
    if (time<=60) {  //// 1分钟以内的
        dateStr = @"刚刚";
    }else if(time<=60*60){  ////  一个小时以内的
        
        int mins = time/60;
        dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
        
    }else if(time<=60*60*24){   //// 在两天内的
        
        [dateFormatter setDateFormat:@"YYYY/MM/dd"];
        NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
        NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
        
        [dateFormatter setDateFormat:@"HH:mm"];
        if ([need_yMd isEqualToString:now_yMd]) {
            //// 在同一天
            dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
        }else{
            ////  昨天
            dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
        }
    }else {
        
        [dateFormatter setDateFormat:@"yyyy"];
        NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
        NSString *nowYear = [dateFormatter stringFromDate:nowDate];
        
        if ([yearStr isEqualToString:nowYear]) {
            ////  在同一年
            [dateFormatter setDateFormat:@"MM月dd日"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }else{
            [dateFormatter setDateFormat:@"yyyy/MM/dd"];
            dateStr = [dateFormatter stringFromDate:needFormatDate];
        }
    }
    
    return dateStr;
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
