
#import "NewDynamicsHV.h"
@interface NewDynamicsHV ()
@property (nonatomic,copy) NSArray *arr;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic,strong)UIImageView *bgView;
@property (nonatomic, strong) NSMutableArray *topBtns;
@property (nonatomic, strong) NSMutableArray *funcBtns;

@property(nonatomic,strong)DynamicsModel * model;
@property (nonatomic, assign) NSInteger likes;
@end
@implementation NewDynamicsHV

- (id)initWithFrame:(CGRect)frame InSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin{
    if (self == [super initWithFrame:frame]) {
        
        self.bgView = [[UIImageView alloc]init];
        self.bgView.backgroundColor = UIColor.clearColor;
        self.bgView.userInteractionEnabled = YES;
        [superView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
            make.leading.equalTo(superView).offset(0);
            make.centerX.mas_equalTo(superView);
            make.top.mas_equalTo(topMargin);
            make.bottom.mas_equalTo(superView);
        }];
        
        [self.bgView layoutIfNeeded];
//        [self.bgView setImage:kIMG(@"m_commheader")];
//        self.bgView.contentMode = UIViewContentModeScaleAspectFit;
//
//        self.tagsView =[[LXTagsView alloc]init];
//        self.tagsView.s = SearchRecordSourceWords;
////        self.tagsView.layer.borderWidth = 10;
////        self.tagsView.layer.borderColor = [UIColor clearColor].CGColor;
//        [self.bgView addSubview:self.tagsView];
//
//        [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.bottom.equalTo(self.bgView);
//        }];
        [self setTopBtns];
        [self setBottomBtns];
        
    }
        
    
    return self;
}
- (void)setTopBtns{
    _topBtns = [NSMutableArray array];
    NSArray* subtitleArray =@[
    @{@"获赞":[UIImage imageWithColor:HEXCOLOR(0x21c244) rect:CGRectMake(0, 0, 16, 16)]},
    @{@"关注":[UIImage imageWithColor:HEXCOLOR(0xe22323) rect:CGRectMake(0, 0, 16, 16)]}
    ,@{@"粉丝":[UIImage imageWithColor:HEXCOLOR(0xf59b22) rect:CGRectMake(0, 0, 16, 16)]}
    
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
//        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
//            button.layer.masksToBounds = YES;
//            button.layer.cornerRadius = 6;
//            button.layer.borderWidth = 1;
//        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
//        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 0;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        //        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:button];
        [_topBtns addObject:button];
    }

    [_topBtns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:5 leadSpacing:5 tailSpacing:60];
    
//    [_topBtns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedItemLength:18 leadSpacing:5 tailSpacing:60];
    
    [_topBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.height.equalTo(@20);
    }];
//    UIButton* btn0 = _topBtns[0];
//    [btn0 mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.bgView);
//        make.width.height.equalTo(@50);
//    }];
    
    UIButton* btn1 = _topBtns[1];
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    btn1.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [btn1 setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
//    btn1.backgroundColor = YBGeneralColor.themeColor;
    [btn1 setTitle:@"" forState:0];
    
    UIButton* btn2 = _topBtns[2];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    btn2.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [btn2 setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    [btn2 setTitle:@"" forState:0];
    
//    [btn1 addTarget:self action:@selector(pushCRClick:) forControlEvents:UIControlEventTouchUpInside];
    
//
}
- (void)setBottomBtns{
    _funcBtns = [NSMutableArray array];
    NSArray* subtitleArray =@[
    @{@"获赞":[UIImage imageWithColor:HEXCOLOR(0x21c244) rect:CGRectMake(0, 0, 16, 16)]},
    @{@"关注":[UIImage imageWithColor:HEXCOLOR(0xe22323) rect:CGRectMake(0, 0, 16, 16)]}
    ,@{@"粉丝":[UIImage imageWithColor:HEXCOLOR(0xf59b22) rect:CGRectMake(0, 0, 16, 16)]}
    
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
//        NSDictionary* dic = subtitleArray[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.adjustsImageWhenHighlighted = NO;
        button.titleLabel.font = kFontSize(15);
//            button.layer.masksToBounds = YES;
//            button.layer.cornerRadius = 6;
//            button.layer.borderWidth = 1;
//        [button setTitle:dic.allKeys[0] forState:UIControlStateNormal];
//        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
        [button setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 0;
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        //        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
        [self.bgView addSubview:button];
        [_funcBtns addObject:button];
    }

    [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:13 tailSpacing:13];
    
    [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
        make.height.equalTo(@50);
    }];
}
-(void)richElementsInCellWithModel:(id)model{
    self.model = model;
    [self.bgView setImage:kIMG(@"m_commheader")];
//    self.bgView.contentMode = UIViewContentModeScaleAspectFit;
    [self alterTopButton:model];
    [self alterButton:model];
    
    [self layoutIfNeeded];

}

- (void)alterTopButton:(DynamicsModel*)model{
    
   [self.bgView layoutIfNeeded];
    
    UIButton* btn0 = _topBtns[0];
    if (model.avatar.length>0) {
        NSString* title = [NSString stringWithFormat:@"mine_avator%li",[model.avatar integerValue]];
        [btn0 setImage:[UIImage imageNamed:title] forState:0];
        
        [btn0 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.top.mas_equalTo(self.bgView.mas_top).offset(15);
            make.width.height.equalTo(@80);
        }];
    }
    
    UIButton* btn1 = _topBtns[1];
    if (model.nickname.length>0) {
        NSString* title = [NSString stringWithFormat:@"%@",model.nickname];
        [btn1 setTitle:title forState:0];
        [btn1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"M_sex_%ld",(long)model.sex]] forState:0];
        [btn1 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
        [btn1 mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bgView);
            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-120);
            make.height.equalTo(@20);
            make.width.equalTo(@300);
        }];
    }
//    [btn1 addTarget:self action:@selector(pushCRClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn2 = _topBtns[2];
    btn2.selected = [[NSNumber numberWithInteger:model.is_focus]boolValue];
    [btn2 setTitle:btn2.selected?@"取消关注":@"关注" forState:0];
    btn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn2 addTarget:self action:@selector(delayLikeClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgView);
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-90);
        make.height.equalTo(@18);
        make.width.equalTo(@90);
    }];
    btn2.backgroundColor = YBGeneralColor.themeColor;
    btn2.layer.masksToBounds = true;
    btn2.layer.cornerRadius = 18/2;
    btn2.hidden =  [[UserInfoManager GetNSUserDefaults].data.ID isEqualToString:model.ID];
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
    
//    [sender setImage:sender.isSelected ? [UIImage imageNamed:@"detail_like_selected"]:[UIImage imageNamed:@"detail_like_normal"] forState:UIControlStateNormal];
    
//    NSInteger l = self.likes;
//    if (sender.selected) {
//        l +=  1;
//    }else{
//        if (l > 0) {
//            l -=  1;
//        }
//    }
//    self.likes = l;
//    [sender setTitle:[NSString stringWithFormat:@"%ld",(long)self.likes] forState:UIControlStateNormal];
    [sender setTitle:sender.isSelected?@"取消关注":@"关注" forState:0];
    
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType60] andType:All andWith:@{@"focus":str,@"to_user_id":self.model.ID} success:^(NSDictionary *bdic) {
    //        NSDictionary* result = bdic[@"result"];
            if ([NSString getDataSuccessed:bdic]) {
                
                self.model.is_focus =sender.selected ? 1 :0;
//                self.model.likes = self.likes;
//                if (self.block) {
//                    self.block(self.layout.model);
//                }
                
            }
            else{
               
            }
        } error:^(NSError *error) {
            
        }];
}
- (void)alterButton:(DynamicsModel*)model{
    
   [self.bgView layoutIfNeeded];
   self.likes = model.loves;
    
   NSArray* subtitleArray =@[
       @{[NSString attributedStringWithString:[NSString stringWithFormat:@"%ld\n",(long)model.loves] stringColor:HEXCOLOR(0x000000) stringFont:kFontSize(13) subString:[NSString stringWithFormat:@"%@",@"获赞"] subStringColor:HEXCOLOR(0x000000) subStringFont:kFontSize(15) paragraphStyle:NSTextAlignmentCenter]:[[NSNumber numberWithInteger:model.is_love]boolValue]? [UIImage imageNamed:@"detail_like_selected"]:[UIImage imageNamed:@"detail_like_normal"]},
    @{[NSString attributedStringWithString:[NSString stringWithFormat:@"%ld\n",(long)model.attention] stringColor:HEXCOLOR(0x000000) stringFont:kFontSize(13) subString:[NSString stringWithFormat:@"%@",@"关注"] subStringColor:HEXCOLOR(0x000000) subStringFont:kFontSize(15) paragraphStyle:NSTextAlignmentCenter]:[UIImage imageNamed:@"detail_comment"]},
    @{[NSString attributedStringWithString:[NSString stringWithFormat:@"%ld\n",(long)model.fans] stringColor:HEXCOLOR(0x000000) stringFont:kFontSize(13) subString:[NSString stringWithFormat:@"%@",@"粉丝"] subStringColor:HEXCOLOR(0x000000) subStringFont:kFontSize(15) paragraphStyle:NSTextAlignmentCenter]:[UIImage imageNamed:@"M_hbic"] }
    ];
    for (int i = 0; i < subtitleArray.count; i++) {
        NSDictionary* dic = subtitleArray[i];
        UIButton* button = _funcBtns[i];
        [button setAttributedTitle:dic.allKeys[0] forState:UIControlStateNormal];
//        [button setImage:dic.allValues[0] forState:UIControlStateNormal];
//        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:8];
//        button.tag = [model.ID integerValue];
    }
    
    UIButton* btn0 = _funcBtns[0];
//    btn0.selected = [[NSNumber numberWithInteger:model.is_love]boolValue];
//    [btn0 addTarget:self action:@selector(delayLikeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn1 = _funcBtns[1];
//    [btn1 addTarget:self action:@selector(pushCRClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* btn2 = _funcBtns[2];
//    btn2.selected = [[NSNumber numberWithInteger:model.is_collect]boolValue];
//    [btn2 addTarget:self action:@selector(popUpClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton* btn3 = _funcBtns[3];
//    [btn3 addTarget:self action:@selector(pushShareVCClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)popUpClick:(UIButton*)sender{
    
}
- (void)startButtonClick{

}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
@end
