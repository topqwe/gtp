//
//  SPCell.m
//  PPOYang
//
//  Created by WIQ on 2017/7/25.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "ShowFilmInfoCell.h"
#import "HomeModel.h"
#import "ShareVC.h"
#import "ZMCusCommentView.h"
@interface ShowFilmInfoCell ()
@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) UILabel *aliasLab;
@property (nonatomic, strong) UILabel *rmbLab;

@property (nonatomic, strong) UILabel *tdTagLab;
@property (nonatomic, strong) UILabel *tdLab;
@property (nonatomic, strong) UILabel *ydLab;

@property (nonatomic, strong) UILabel *tmTagLab;
@property (nonatomic, strong) UILabel *tmLab;
@property (nonatomic, strong) UILabel *ymLab;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *fanBtn;

@property (strong,nonatomic)UIButton *sectionHBtn;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@property (nonatomic, assign) NSInteger likes;
@property (strong,nonatomic)HomeItem* model;
@end

@implementation ShowFilmInfoCell
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self richEles];
    }
    return self;
}


- (void)richEles{
    
    UIButton *sectionHBtn = [[UIButton alloc]init];
    self.sectionHBtn = sectionHBtn;
    sectionHBtn.userInteractionEnabled = true;
    sectionHBtn.tag = 9000;
    [sectionHBtn setBackgroundColor:kClearColor];
    [self.contentView addSubview:sectionHBtn];
    [sectionHBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
//        make.height.mas_equalTo(70);
    }];
    sectionHBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    sectionHBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    sectionHBtn.titleLabel.numberOfLines = 0;
    
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
    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:13 tailSpacing:13];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.height.equalTo(@50);
    }];

    UIButton* btn0 = _funcBtns[0];
    UIImageView* sectionLine = [[UIImageView alloc]init];
    sectionLine.backgroundColor = HEXCOLOR(0xe8e9ed);
    sectionLine.backgroundColor = UIColor.clearColor;
    [self.contentView addSubview:sectionLine];
    [sectionLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(btn0.mas_bottom).offset(20);
        make.height.equalTo(@1);
        make.leading.equalTo(@0);
        make.centerX.equalTo(self.contentView);
    }];
}


+(instancetype)cellWith:(UITableView*)tabelView{
    ShowFilmInfoCell *cell = (ShowFilmInfoCell *)[tabelView dequeueReusableCellWithIdentifier:@"ShowFilmInfoCell"];
    if (!cell) {
        cell = [[ShowFilmInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ShowFilmInfoCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(HomeItem*)model{
    NSAttributedString* atS = [NSString attributedStringWithString:[NSString stringWithFormat:@"%@\n\n",model.name] stringColor:HEXCOLOR(0x000000) stringFont:[UIFont boldSystemFontOfSize:18] subString:[NSString stringWithFormat:@"%@次播放",model.views] subStringColor:UIColor.lightGrayColor subStringFont:kFontSize(15) paragraphStyle:NSTextAlignmentLeft];
    CGFloat height = [NSString getAttributeContentHeightWithAttributeString:atS withFontSize:18 boundingRectWithWidth:MAINSCREEN_WIDTH-30];
    return 10+height+30+50;
}

- (void)richElementsInCellWithModel:(HomeItem*)model{
    self.model = model;
    NSAttributedString* atS = [NSString attributedStringWithString:[NSString stringWithFormat:@"%@\n\n",model.name] stringColor:HEXCOLOR(0x000000) stringFont:[UIFont boldSystemFontOfSize:18] subString:[NSString stringWithFormat:@"%@次播放",model.views] subStringColor:UIColor.lightGrayColor subStringFont:kFontSize(15) paragraphStyle:NSTextAlignmentLeft];
    [_sectionHBtn setAttributedTitle:atS forState:0];
    CGFloat height = [NSString getAttributeContentHeightWithAttributeString:atS withFontSize:18 boundingRectWithWidth:MAINSCREEN_WIDTH-30];
    [self.sectionHBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
//    [self alterButton:model];//imodel
    for (UIButton* btn in self.funcBtns) {
        btn.hidden = YES;
    }
}

- (void)alterButton:(HomeItem*)model{
    
   [self.contentView layoutIfNeeded];
   self.likes = model.likes;
   NSArray* subtitleArray =@[
    @{[NSString stringWithFormat:@"%ld",(long)model.likes]:[[NSNumber numberWithInteger:model.is_love]boolValue]? [UIImage imageNamed:@"detail_like_selected"]:[UIImage imageNamed:@"detail_like_normal"]},
    @{[NSString stringWithFormat:@"%ld",(long)model.comments]:[UIImage imageNamed:@"detail_comment"]},
    @{@"收藏":[[NSNumber numberWithInteger:model.is_collect]boolValue]? [UIImage imageNamed:@"detail_collect_selected"]:[UIImage imageNamed:@"detail_collect_normal"] },
     
    @{@"分享":[UIImage imageNamed:@"detail_share"]}
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton* button = _funcBtns[i];
        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:20];
//        button.tag = model.ID;
    }
    
    UIButton* btn0 = _funcBtns[0];
    btn0.selected = [[NSNumber numberWithInteger:model.is_love]boolValue];
    [btn0 addTarget:self action:@selector(delayLikeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn1 = _funcBtns[1];
    [btn1 addTarget:self action:@selector(pushCRClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn2 = _funcBtns[2];
    btn2.selected = [[NSNumber numberWithInteger:model.is_collect]boolValue];
    [btn2 addTarget:self action:@selector(delayCollectClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn3 = _funcBtns[3];
    [btn3 addTarget:self action:@selector(pushShareVCClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)pushCRClick:(UIButton*)sender{
    self.model.style = 0;
    [[ZMCusCommentManager shareManager] showCommentWithSourceId:self.model  success:^(id data) {
        NSInteger fID = self.model.ID;
        
        NSDictionary* filmDic = @{@"id":@(fID)};
        kWeakSelf(self);
        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType17] andType:All andWith:filmDic success:^(NSDictionary *dic) {
            kStrongSelf(self);
            if ([NSString getDataSuccessed:dic]) {
    //        weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
            HomeItem* item = [HomeItem mj_objectWithKeyValues:dic[@"data"]];
                self.model = item;
//                self.model.comments = item.comments;
//                [self alterButton:self.model];
                [sender setTitle:[NSString stringWithFormat:@"%ld",(long)self.model.comments] forState:UIControlStateNormal];
                if (self.block) {
                    self.block(self.model);
                }
            }
            else{
                NSString* str = [NSString stringWithFormat:@"%@",dic[@"msg"]];
    //            [YKToastView showToastText:str];
                   NSLog(@".......dataErr");
                
                if ([str containsString:@"b"]) {
                    HomeItem* item = [HomeItem mj_objectWithKeyValues:dic[@"data"]];
                    self.model = item;
                    [sender setTitle:[NSString stringWithFormat:@"%ld",(long)self.model.comments] forState:UIControlStateNormal];
//                    self.model.comments = item.comments;
//                    [self alterButton:self.model];
                    if (self.block) {
                        self.block(self.model);
                    }
                    
                }
                   
                }
            } error:^(NSError *error) {
                NSLog(@".......servicerErr");
            }];
    }];
//    if (self.block) {
//        self.block(@(sender.tag));
//    }
}

- (void)pushShareVCClick:(UIButton*)sender{
    id object = [self nextResponder];
    while (![object isKindOfClass:[UIViewController class]] && object != nil) {
        object = [object nextResponder];
    }
    UIViewController *superController = (UIViewController*)object;
    [superController.navigationController  showViewController:[ShareVC new] sender:nil];
}
- (void)likeClick:(UIButton*)sender{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayLikeClick:) object:sender];
    [self performSelector:@selector(delayLikeClick:) withObject:sender afterDelay:1];
}

- (void)delayLikeClick:(UIButton*)sender{
    sender.selected = !sender.selected;
    SplashView *splashView = [[SplashView alloc] initWithFrame:CGRectMake((sender.bounds.size.width-25)/2, 0,  25, 25) withAnimationNamed:sender.isSelected ?@"likeAni":@"likeAni"];
    __weak SplashView *weakSplashView = splashView;
    [splashView showOnView:sender withAnimationCompleter:^{
        [UIView animateWithDuration:0.5 animations:^{
            weakSplashView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSplashView removeFromSuperview];
            [self likeEvent:sender];
        }];
    }];
    
    
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
    
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType18] andType:All andWith:@{@"like":str,@"id":@(self.model.ID)} success:^(NSDictionary *bdic) {
    //        NSDictionary* result = bdic[@"result"];
            if ([NSString getDataSuccessed:bdic]) {
                
                self.model.is_love =sender.selected ? 1 :0;
                self.model.likes = self.likes;
                if (self.block) {
                    self.block(self.model);
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
    SplashView *splashView = [[SplashView alloc] initWithFrame:CGRectMake((sender.bounds.size.width-25)/2, 0,  25, 25) withAnimationNamed:sender.isSelected ?@"colAni":@"colAni"];
    __weak SplashView *weakSplashView = splashView;
    [splashView showOnView:sender withAnimationCompleter:^{
        [UIView animateWithDuration:0.5 animations:^{
            weakSplashView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSplashView removeFromSuperview];
            [self collectEvent:sender];
        }];
    }];
}
- (void)collectEvent:(UIButton*)sender{
    NSString * str = [NSString stringWithFormat:@"%d",sender.isSelected];
    
    [sender setImage:sender.isSelected ? [UIImage imageNamed:@"detail_collect_selected"]:[UIImage imageNamed:@"detail_collect_normal"] forState:UIControlStateNormal];
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType19] andType:All andWith:@{@"collect":str,@"id":@(self.model.ID)} success:^(NSDictionary *bdic) {
    //        NSDictionary* result = bdic[@"result"];
            if ([NSString getDataSuccessed:bdic]) {
                
                self.model.is_collect =sender.selected ? 1 :0;
                if (self.block) {
                    self.block(self.model);
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
@end
