//
//  CollectionCell.m
//  SegmentController
//
//  Created by mamawang on 14-6-10.
//  Copyright (c) 2014年 WIQ. All rights reserved.
//

#import "SColCell.h"
@interface SColCell()
@property(nonatomic,strong)HomeItem* item;
@property(nonatomic,strong)FunctionMenuView * jrMenuView;
@property(nonatomic, strong)SLMarqueeControl* horizontalAnimationLabel;
@end
@implementation SColCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *contentBgV = [[UIButton alloc]init];
        contentBgV.userInteractionEnabled = NO;
        contentBgV.tag = 7000;
        [contentBgV setBackgroundColor:kClearColor];
        [self.contentView addSubview:contentBgV];
        [contentBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            
//            make.center.mas_equalTo(cell.contentView);
            make.centerX.mas_equalTo(self.contentView);
            
            make.bottom.mas_equalTo(self.contentView).offset(0);
        }];
//        icon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //⚠️
        contentBgV.contentMode = UIViewContentModeScaleAspectFill;
        contentBgV.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        contentBgV.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        contentBgV.titleLabel.font = kFontSize(18);
        [contentBgV setTitleColor:HEXCOLOR(0x000000) forState:0];
        contentBgV.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        [contentBgV setBackgroundImage:[UIImage new] forState:0];
        self.contentBgV = contentBgV;
        
        UIButton *icon = [[UIButton alloc]init];
        icon.userInteractionEnabled = NO;
        icon.tag = 8000;
        [icon setBackgroundColor:kClearColor];
        [self.contentView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            
//            make.center.mas_equalTo(cell.contentView);
            make.centerX.mas_equalTo(self.contentView);
            
            make.bottom.mas_equalTo(self.contentView).offset(-30);
        }];
//        icon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //⚠️
        icon.contentMode = UIViewContentModeScaleAspectFill;
        icon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
        icon.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
        icon.titleLabel.font = kFontSize(18);
        [icon setTitleColor:HEXCOLOR(0x717171) forState:0];
        icon.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [icon setBackgroundImage:[UIImage new] forState:0];
        
        UIButton *levBut = [[UIButton alloc]init];
        levBut.userInteractionEnabled = NO;
        levBut.tag = 8002;
        [levBut setBackgroundColor:kClearColor];
        [self.contentView addSubview:levBut];
        [levBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(12);
            make.width.mas_equalTo(30);
        }];
        levBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        levBut.titleLabel.font = kFontSize(10);
        [levBut setTitleColor:HEXCOLOR(0xffffff) forState:0];
        levBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        UIButton *timeBut = [[UIButton alloc]init];
        timeBut.userInteractionEnabled = NO;
        timeBut.tag = 8003;
        [self.contentView addSubview:timeBut];
        [timeBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-37);
            make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(60);
            
        }];
        timeBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        timeBut.titleLabel.font = kFontSize(11);
        [timeBut setTitleColor:HEXCOLOR(0xffffff) forState:0];
        
        timeBut.layer.masksToBounds = true;
        timeBut.layer.cornerRadius = 15/2;
        timeBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        
        UIButton *viewsBut = [[UIButton alloc]init];
        viewsBut.userInteractionEnabled = NO;
        viewsBut.tag = 8004;
        [self.contentView addSubview:viewsBut];
        [viewsBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-37);
            make.left.mas_equalTo(self.contentView.mas_left).offset(10);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(60);
            
        }];
        viewsBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        viewsBut.titleLabel.font = kFontSize(11);
        [viewsBut setTitleColor:HEXCOLOR(0xffffff) forState:0];
        
        viewsBut.layer.masksToBounds = true;
        viewsBut.layer.cornerRadius = 15/2;
        viewsBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        UIButton *titBut = [[UIButton alloc]init];
        titBut.userInteractionEnabled = NO;
        titBut.tag = 8001;
        [titBut setBackgroundColor:kClearColor];
        [self.contentView addSubview:titBut];
        [titBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-5);
            make.left.mas_equalTo(5);
//            make.width.mas_equalTo(MAINSCREEN_WIDTH/3);
//            make.centerX.mas_equalTo(self.contentView);
            make.right.mas_equalTo(-25);
        }];
        titBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        titBut.titleLabel.font = kFontSize(15);
        [titBut setTitleColor:HEXCOLOR(0x717171) forState:0];
        [titBut setBackgroundImage:[UIImage new] forState:0];
        titBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        
        SLMarqueeControl* horizontalAnimationLabel = [[SLMarqueeControl alloc] init];
        horizontalAnimationLabel.tag = 8006;
        self.horizontalAnimationLabel = horizontalAnimationLabel;
        
        horizontalAnimationLabel.marqueeLabel.textColor = HEXCOLOR(0x717171);
        horizontalAnimationLabel.marqueeLabel.font = kFontSize(15);
        [self.contentView addSubview:horizontalAnimationLabel];
        
        
        self.vBgV = [[UIView alloc]init];
//        self.vBgV.userInteractionEnabled = NO;
        self.vBgV.tag = 8005;
        [self.vBgV setBackgroundColor:kClearColor];
        [self.contentView addSubview:self.vBgV];
        [self.vBgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            
//            make.center.mas_equalTo(cell.contentView);
            make.centerX.mas_equalTo(self.contentView);
            
            make.bottom.mas_equalTo(self.contentView).offset(-30);
        }];
//        icon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        //⚠️
        self.vBgV.contentMode = UIViewContentModeScaleAspectFill;
        
        self.menuBtn.tag = 8007;
        [self.contentView addSubview:self.menuBtn];
        [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-9);
            make.right.mas_equalTo(-5);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(90);
//            make.centerY.mas_equalTo(titBut);
//            make.centerX.mas_equalTo(self.contentView);
        }];
        self.menuBtn.hidden = NO;
        [self bringSubviewToFront:self.menuBtn];
    }
    return self;
}
+ (instancetype)cellAtIndexPath:(NSIndexPath*)indexPath inView:(UICollectionView *)collectionView{
//    [collectionView registerClass:[SColCell class] forCellWithReuseIdentifier:@"SColCell"];
    SColCell *cell = (SColCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"SColCell" forIndexPath:indexPath];
    return cell;
}
-(void)handleEVCell{
    UIButton* levBut = [self.contentView viewWithTag:8002];
    levBut.hidden = YES;
    UIButton* timeBut = [self.contentView viewWithTag:8003];
    timeBut.hidden = YES;
    UIButton* viewsBut = [self.contentView viewWithTag:8004];
    viewsBut.hidden = YES;
    
    self.menuBtn.hidden = YES;
    
    UIButton* horizontalAnimationLabel = [self.contentView viewWithTag:8006];
    horizontalAnimationLabel.hidden = YES;
    
    UIButton* icon = [self.contentView viewWithTag:8000];
    [icon sd_setImageWithURL:nil forState:0];
//    icon.hidden = YES;
    icon.titleLabel.numberOfLines = 2;
    icon.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    [icon setBackgroundColor:[UIColor clearColor]];
    icon.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    icon.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    icon.titleLabel.font = kFontSize(15);
    [icon setTitleColor:HEXCOLOR(0xffffff) forState:0];
//    [icon setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@\n",self.item.name.length>8?[self.item.name substringToIndex:8]:self.item.name] stringColor:HEXCOLOR(0xffffff) stringFont:kFontSize(15) subString:[NSString stringWithFormat:@"%@",self.item.name] subStringColor:HEXCOLOR(0xffffff) subStringFont:kFontSize(15) paragraphStyle:NSTextAlignmentLeft] forState:0];//intro
    NSMutableString *url = [NSMutableString string];
    [url appendString:[NSString stringWithFormat:@"%@\n",self.item.name.length>8?[self.item.name substringToIndex:8]:self.item.name]];
    [url appendString:[NSString stringWithFormat:@"%@",self.item.name]];
    [icon setTitle:[url copy] forState:0];
    
    [self.contentBgV sd_setImageWithURL:[NSURL URLWithString:self.item.cover_img] forState:0 placeholderImage:kIMG(@"M_SQUARE_PLACEDHOLDER_IMG") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView putView:self.contentBgV andCornerRadius:10 insideShadowWithColor:UIColor.lightGrayColor andRadius:2 andOffset:CGSizeMake(0,3) andOpacity:0.3];
    }];
    self.contentBgV.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
}

-(void)handleSRCell{
    UIButton* levBut = [self.contentView viewWithTag:8002];
    levBut.hidden = YES;
    UIButton* timeBut = [self.contentView viewWithTag:8003];
    timeBut.hidden = YES;
    UIButton* viewsBut = [self.contentView viewWithTag:8004];
    viewsBut.hidden = YES;
    self.menuBtn.hidden = YES;
    
    UIButton* horizontalAnimationLabel = [self.contentView viewWithTag:8006];
    horizontalAnimationLabel.hidden = YES;
    
    UIButton* icon = [self.contentView viewWithTag:8000];
    [icon sd_setImageWithURL:[NSURL URLWithString:self.item.cover_img] forState:0 placeholderImage:kIMG(@"M_SQUARE_PLACEDHOLDER_IMG") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [UIView putView:icon andCornerRadius:10 insideShadowWithColor:UIColor.lightGrayColor andRadius:2 andOffset:CGSizeMake(0,3) andOpacity:0.3];
    }];
    [icon.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    self.contentBgV.titleLabel.numberOfLines = 1;
    self.contentBgV.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentBgV setTitle:[NSString stringWithFormat:@"%@",self.item.name] forState:0];
    [self.contentBgV setBackgroundColor:[UIColor clearColor]];
    self.contentBgV.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.contentBgV.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    self.contentBgV.titleLabel.font = kFontSize(15);
    [self.contentBgV setTitleColor:HEXCOLOR(0x000000) forState:0];
}

-(void)handleSSCell{
    self.menuBtn.hidden = YES;
    UIButton* horizontalAnimationLabel = [self.contentView viewWithTag:8006];
    horizontalAnimationLabel.hidden = YES;
    if ([self.item.cover_img containsString:@"priorty"]) {
        UIButton* icon = [self.contentView viewWithTag:7000];
        [icon setImage:kIMG(self.item.cover_img) forState:0];
        [UIView putView:icon andCornerRadius:10 insideShadowWithColor:UIColor.lightGrayColor andRadius:2 andOffset:CGSizeMake(0,3) andOpacity:0.3];
        [icon.imageView setContentMode:UIViewContentModeScaleAspectFill];
    }
}

-(void)hideHorLabShowTitBut:(BOOL)isHidden{
//    self.horizontalAnimationLabel.hidden = isHidden;
    self.horizontalAnimationLabel.rate = isHidden?0:50;
//    UIButton *titBut=(UIButton *)[self.contentView viewWithTag:8001];
//    titBut.hidden = !self.horizontalAnimationLabel.hidden;
}
-(void)richElementsInCellWithModel:(HomeItem*)fourPalaceData{
    if (![fourPalaceData isKindOfClass:[HomeItem class]]) {
        return;
    }
    self.item = fourPalaceData;
    self.menuBtn.tag = fourPalaceData.ID;
    self.menuBtn.selected = NO;
    [self.menuBtn addTarget:self action:@selector(presentMenuController:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView layoutIfNeeded];
    
    UIButton *titBut=(UIButton *)[self.contentView viewWithTag:8001];
//    if (_style == IndexSectionUIStyleSix) {
//        [titBut setAttributedTitle:[NSString attributedShadowWithString:fourPalaceData.name stringColor:[UIColor clearColor] stringFont:kFontSize(12)] forState:0];
//    }else{
//        [titBut setAttributedTitle:[NSString attributedShadowWithString:fourPalaceData.name stringColor:[UIColor whiteColor] stringFont:kFontSize(12)] forState:0];
//    }
    [titBut setTitle:[NSString stringWithFormat:@"%@",fourPalaceData.name] forState:0];
    if (_style == IndexSectionUIStyleEight||
        _style == IndexSectionUIStyleFour) {
        [titBut setTitleColor:kWhiteColor forState:0];
    }else{
        [titBut setTitleColor:HEXCOLOR(0x717171) forState:0];
    }
    titBut.hidden = true;
    [titBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-5);
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-25);
    }];
    [self.contentView layoutIfNeeded];
    if (fourPalaceData.name) {
        self.horizontalAnimationLabel.frame = titBut.frame;
        [self.horizontalAnimationLabel.marqueeLabel setText:[NSString stringWithFormat:@"%@",fourPalaceData.name] ];
        if (_style == IndexSectionUIStyleEight||
            _style == IndexSectionUIStyleFour) {
            [self.horizontalAnimationLabel.marqueeLabel setTextColor:kWhiteColor ];
        }else{
            [self.horizontalAnimationLabel.marqueeLabel setTextColor:HEXCOLOR(0x717171)];
        }
    }
    
    
//    [self.contentView layoutIfNeeded];
    
    UIButton *icon=(UIButton *)[self.contentView viewWithTag:8000];
    if ([fourPalaceData.cover_img containsString:@"http"] ) {
        [icon sd_setImageWithURL:[NSURL URLWithString:fourPalaceData.cover_img] forState:0 placeholderImage:kIMG(@"M_SQUARE_PLACEDHOLDER_IMG") completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [UIView putView:icon andCornerRadius:10 insideShadowWithColor:UIColor.lightGrayColor andRadius:2 andOffset:CGSizeMake(0,3) andOpacity:0.3];
        }];
        [icon.imageView setContentMode:UIViewContentModeScaleAspectFill];
    //    [icon setTitle:[NSString stringWithFormat:@"%@",fourPalaceData.name] forState:0];
    //    [icon  layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:8];
        
    //    [UIView putView:icon andCornerRadius:10 insideShadowWithColor:UIColor.clearColor andRadius:2 andOffset:CGSizeMake(0,3) andOpacity:0.3];
        
    }else{
        
    }
    

    UIButton *levBut=(UIButton *)[self.contentView viewWithTag:8002];
    
    if ([fourPalaceData getLevImg]!=nil) {
        if (fourPalaceData.restricted == 2) {
            [levBut setTitle:[NSString stringWithFormat:@"    %@",fourPalaceData.gold] forState:0];
            
        }else{
            [levBut setTitle:[NSString stringWithFormat:@"%@",@""] forState:0];
        }
        [levBut setBackgroundImage:[fourPalaceData getLevImg] forState:0];
    }else{
        [levBut setBackgroundImage:nil forState:0];
        [levBut setTitle:[NSString stringWithFormat:@"%@",@""] forState:0];
    }

    if (fourPalaceData.duration) {
        UIButton *timeBut=(UIButton *)[self.contentView viewWithTag:8003];
        [timeBut setTitle:[NSString stringWithFormat:@"%@",fourPalaceData.duration] forState:0];
        [timeBut setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        
    }
    if (fourPalaceData.views) {
        UIButton *viewsBut=(UIButton *)[self.contentView viewWithTag:8004];
        [viewsBut setImage:kIMG(@"m_eye") forState:0];
        [viewsBut setTitle:[NSString stringWithFormat:@"%@",fourPalaceData.views] forState:0];
        [viewsBut layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:4];
        
        [viewsBut setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
    }
    
    
//    if (fourPalaceData.type != 1) {
//        levBut.hidden = true;
//        viewsBut.hidden = true;
//        timeBut.hidden = true;
//    }else{
//        levBut.hidden = false;
//        viewsBut.hidden = false;
//        timeBut.hidden = false;
//    }
    
//    if (_selectedIndexPath) {
//        if (_selectedIndexPath == indexPath) {
//            [icon setTitleColor:[UIColor redColor] forState:0];
//            icon.layer.shadowColor = [UIColor blackColor].CGColor;
//        }else{
//            [icon setTitleColor:HEXCOLOR(0x202020) forState:0];
//            icon.layer.shadowColor = [UIColor clearColor].CGColor;
//        }
//    }else{
//        if (cell.tag == 0) {
//            [icon setTitleColor:[UIColor redColor] forState:0];
//            icon.layer.shadowColor = [UIColor blackColor].CGColor;
//        }
//    }
    
}
+(CGFloat)cellHeight{
    return 90000000;
}
//+(instancetype)cellWith:(UITableView*)tabelView{
//    GridCell *cell = (GridCell *)[tabelView dequeueReusableCellWithIdentifier:@"GridCell"];
//    if (!cell) {
//        cell = [[GridCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"GridCell"];
//    }
//    return cell;
//}

-(UIButton *)menuBtn
{
    if (!_menuBtn) {
        _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _menuBtn.contentMode = UIViewContentModeScaleAspectFill;
        _menuBtn.adjustsImageWhenHighlighted = NO;
        [_menuBtn setImage:[UIImage imageNamed:@"AlbumOperateMore"] forState:UIControlStateNormal];
        _menuBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _menuBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        
    }
    return _menuBtn;
}
#pragma mark - 弹出JRMenu
- (void)presentMenuController:(UIButton*)sender
{
    sender.selected = !sender.selected;
    if (!sender.selected) {
        [FunctionMenuView dismissAllJRMenu];
        return;
    }
    if (!_jrMenuView) {
        _jrMenuView = [[FunctionMenuView alloc] init];
    }
    [_jrMenuView setTargetView:_menuBtn InView:self.contentView];
    [self.contentView addSubview:_jrMenuView];
    [_jrMenuView show];
    
//    __block HomeItem* item = self.item;
    [_jrMenuView actionBlock:^(id data) {
        if ([data isKindOfClass:[HomeItem class]]) {
            self.item = data;
        }
    }];
    [_jrMenuView setData:self.item];
    [self.jrMenuView resetSelfFrame];
//    return;
    NSInteger fID = self.item.ID;
    
    NSDictionary* filmDic = @{@"id":@(fID)};
    kWeakSelf(self);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType17] andType:All andWith:filmDic success:^(NSDictionary *dic) {
        kStrongSelf(self);
        if ([NSString getDataSuccessed:dic]) {
//        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
        HomeItem* item = [HomeItem mj_objectWithKeyValues:dic[@"data"]];
            self.item = item;
            [self.jrMenuView resetButton:self.item];
        }
        else{
            NSString* str = [NSString stringWithFormat:@"%@",dic[@"msg"]];
//            [YKToastView showToastText:str];
               NSLog(@".......dataErr");
            
            if ([str containsString:@"b"]) {
                HomeItem* item = [HomeItem mj_objectWithKeyValues:dic[@"data"]];
                self.item = item;
                [self.jrMenuView resetButton:self.item];
                
            }if ([str containsString:@"noviews"]) {
                [self.jrMenuView resetButton:self.item];
            }
               
            }
        } error:^(NSError *error) {
            NSLog(@".......servicerErr");
            [self.jrMenuView resetButton:self.item];
        }];
}
@end
