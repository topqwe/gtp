//
//  TableViewCell.m
//  pod_test
//
//  Created by YY_ZYQ on 2017/6/24.
//  Copyright © 2017年 YY_ZYQ. All rights reserved.
//

#import "StyleScCell1.h"
#define kGridCellHeight   80
#define bottomMargin  45
@interface StyleScCell1 ()
@property (nonatomic ,strong)UIImageView *imgView;
@property (nonatomic ,strong)UIScrollView *scrollView;
@property (nonatomic ,strong) UIButton *selectImgBtn;
@property (nonatomic ,strong) UIButton *nameBtn;
@property (nonatomic ,strong) UIButton *titleBtn;
@property (nonatomic, copy) ActionBlock block;
@property(nonatomic, strong)NSMutableArray *data;
@property (nonatomic ,strong) UIImageView* line0;
@end

@implementation  StyleScCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //处理选中背景色问题
        
        self.backgroundColor = kWhiteColor;
        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];
            
        [self richEles];
    }
    return self;
}

- (void)richEles{
    if (_imgView) {
        [_imgView removeFromSuperview];
        _imgView = nil;
    }
    
    if(_scrollView)
    {
        [_scrollView removeAllSubViews];
        [_scrollView removeFromSuperview];
        _scrollView = nil;
    }
    
    _imgView = [UIImageView new];
    [self.contentView addSubview:_imgView];
    _imgView.backgroundColor = UIColor.clearColor;
    
    
    
    
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.bounces = YES;
    _scrollView.pagingEnabled = NO; // 滑到一半自动收缩
    _scrollView.showsVerticalScrollIndicator = NO; //垂直滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;//水平滚动条
    [self.contentView addSubview:_scrollView];
    
    
    UIImageView* line0 = [[UIImageView alloc]init];
    self.line0 = line0;
    [self.contentView addSubview:line0];
    line0.backgroundColor = kClearColor;
    
    
}

+(instancetype)cellWith:(UITableView*)tabelView{
    StyleScCell1 *cell = (StyleScCell1 *)[tabelView dequeueReusableCellWithIdentifier:@"StyleScCell1"];
    if (!cell) {
        cell = [[StyleScCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"StyleScCell1"];
    }
    return cell;
}

+(CGFloat)cellHeightWithModel:(NSDictionary*)model{
    //VM累计出总的数据，V不在累计
    //更新GridCell高度
    NSArray* arr = model.allValues[0];
    if (arr.count==0||arr.count==1) {
        return  0.1f;
    }
    
    
    IndexSectionUIStyle style = [model.allKeys[0] integerValue];
    switch (style) {
        case IndexSectionUIStyleOne:
            return 130+bottomMargin;
            break;
        case IndexSectionUIStyleTwo:
            return 160+bottomMargin;
            break;
        case IndexSectionUIStyleThree:
            return 110+bottomMargin;//80
            break;
        default:
            return kGridCellHeight;
            break;
    }
    return kGridCellHeight;
}

- (void)richElementsInCellWithModel:(NSDictionary*)model{
    _data = [NSMutableArray array];
    [_data addObjectsFromArray: model.allValues[0]];
    if (_data.count==0) {
        return;
    }
    IndexSectionUIStyle style = [model.allKeys[0] integerValue];
    CGRect sframe = CGRectZero;
    switch (style) {
            
        case IndexSectionUIStyleOne:
        {
            sframe = CGRectMake(10, 0, (130*88)/50, [[self class] cellHeightWithModel:model]- bottomMargin);
            self.line0.backgroundColor = HEXCOLOR(0x8FAEB7);
            [self.imgView setImage:nil];
        }
            break;
        case IndexSectionUIStyleTwo:
        {
            sframe = CGRectMake(10, 0, (160*123)/69, [[self class] cellHeightWithModel:model]- bottomMargin);
            self.line0.backgroundColor = kClearColor;
            [self.imgView setImage:kIMG(@"M_StyleScCell1Bg")];
        }
            break;
        case IndexSectionUIStyleThree:
        {
            sframe = CGRectMake(10, 0, (110*65)/37, [[self class] cellHeightWithModel:model]- bottomMargin);
            self.line0.backgroundColor = HEXCOLOR(0x8FAEB7);
            [self.imgView setImage:nil];
        }
            break;
            
        default:
        {
            
        }
            break;
    }
    
    self.imgView.frame = CGRectMake(0, sframe.size.height+bottomMargin-33, MAINSCREEN_WIDTH, 33);//sframe.size.height+ bottomMargin
    
    self.line0.frame = CGRectMake(10, sframe.size.height+ bottomMargin-0.5, MAINSCREEN_WIDTH-20, 0.5);
    
    self.scrollView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, sframe.size.height+ bottomMargin);//多出titBut高度
    
    self.scrollView.contentSize = CGSizeMake((sframe.size.width+sframe.origin.x) * _data.count+10, sframe.size.height+bottomMargin);//最右+10
    
    NSMutableArray *viewArrs = [[NSMutableArray alloc]init];
    [self.scrollView removeAllSubViews];
    for(int i = 0; i < _data.count; i++){
        HomeItem *fourPalaceData = [_data objectAtIndex:i];
//        UIView *view = [[UIView alloc] init];
//        [self.scrollView addSubview:view];
//        [view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self.scrollView);
//        }];
        
        UIButton *sectionHBtn = [[UIButton alloc] init];
        sectionHBtn.adjustsImageWhenHighlighted = NO;
        sectionHBtn.titleLabel.font = kFontSize(18);
        [sectionHBtn setTitleColor:HEXCOLOR(0x717171) forState:0];
        sectionHBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        sectionHBtn.backgroundColor = UIColor.clearColor;
//        [icon setContentMode:UIViewContentModeScaleAspectFill];
//        [icon setClipsToBounds:YES];
        [sectionHBtn sd_setImageWithURL:[NSURL URLWithString:fourPalaceData.cover_img] forState:0 placeholderImage:kIMG(@"M_SQUARE_PLACEDHOLDER_IMG")];
        [sectionHBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        
//        [icon setTitle:[NSString stringWithFormat:@"%@",fourPalaceData.name] forState:0];
//        [icon  layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleTop imageTitleSpace:8];
        
        sectionHBtn.tag = i+100000;
        [sectionHBtn addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
        UIView* view = [UIView new];
        view.frame = CGRectMake(sframe.size.width * i+10*(i+1),  sframe.origin.y,sframe.size.width,sframe.size.height);
        
        [self.scrollView addSubview:view];
        [viewArrs addObject:sectionHBtn];
        sectionHBtn.frame =
//        view.bounds;
        CGRectMake(view.bounds.origin.x,  view.bounds.origin.y,view.bounds.size.width,view.bounds.size.height-1);
        [view addSubview:sectionHBtn];
        
        [view setCornerRadius:10 withShadow:YES withShadowWithColor:UIColor.lightGrayColor andRadius:2 andOffset:CGSizeMake(0,3) andOpacity:0.3];
        sectionHBtn.layer.cornerRadius = 10;
        sectionHBtn.layer.masksToBounds = true;

        UIButton *titBut = [[UIButton alloc]init];
        titBut.userInteractionEnabled = NO;
        titBut.tag = 8001;
        [titBut setBackgroundColor:kClearColor];
        [self.scrollView addSubview:titBut];
        titBut.frame = CGRectMake(sframe.size.width * i+10*(i+1),  CGRectGetMaxY(sframe)+10,sframe.size.width,15);
        titBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        titBut.titleLabel.font = kFontSize(15);
        [titBut setTitleColor:HEXCOLOR(0x717171) forState:0];
        [titBut setBackgroundImage:[UIImage new] forState:0];
        titBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        [titBut setTitle:[NSString stringWithFormat:@"%@",fourPalaceData.name] forState:0];
        
        UIButton *levBut = [[UIButton alloc]init];
        levBut.userInteractionEnabled = NO;
        levBut.tag = 8002;
        [levBut setBackgroundColor:kClearColor];
        [sectionHBtn addSubview:levBut];
        [levBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(18);
            make.width.mas_equalTo(42);
        }];
        levBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        levBut.titleLabel.font = kFontSize(13);
        [levBut setTitleColor:HEXCOLOR(0xffffff) forState:0];
        levBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        UIButton *timeBut = [[UIButton alloc]init];
        timeBut.userInteractionEnabled = NO;
        timeBut.tag = 8003;
        [sectionHBtn addSubview:timeBut];
        [timeBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(sectionHBtn.mas_bottom).offset(-7);
            make.right.mas_equalTo(sectionHBtn.mas_right).offset(-10);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(60);
//            make.width.mas_equalTo(MAINSCREEN_WIDTH/3);
//            make.centerX.mas_equalTo(cell.contentView);
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
        [sectionHBtn addSubview:viewsBut];
        [viewsBut mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(sectionHBtn.mas_bottom).offset(-7);
            make.left.mas_equalTo(sectionHBtn.mas_left).offset(10);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(60);
        }];
        viewsBut.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        viewsBut.titleLabel.font = kFontSize(11);
        [viewsBut setTitleColor:HEXCOLOR(0xffffff) forState:0];
        
        viewsBut.layer.masksToBounds = true;
        viewsBut.layer.cornerRadius = 15/2;
        viewsBut.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        
        
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

        
        
        [timeBut setTitle:[NSString stringWithFormat:@"%@",fourPalaceData.duration] forState:0];
        [timeBut setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        
        
        [viewsBut setImage:kIMG(@"m_eye") forState:0];
        [viewsBut setTitle:[NSString stringWithFormat:@"%@",fourPalaceData.views] forState:0];
        [viewsBut layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:4];
        
        [viewsBut setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.4]];
        
        

    }
    
//    [self.contentView layoutIfNeeded];
}

- (void)itemClick:(UIButton*)sender {
    HomeItem *fourPalaceData = _data[sender.tag-100000];
    if (self.block) {
        self.block(fourPalaceData);
    }
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
@end
