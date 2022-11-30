
#import "FilterSuspensionV.h"
#import "TTTagView.h"
@interface FilterSuspensionV ()
@property (nonatomic,copy) NSArray *arr;

@property (nonatomic,strong)NSMutableArray *btns;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic,strong)UIView *bgView;

@end
@implementation FilterSuspensionV

- (id)initWithFrame:(CGRect)frame InSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin{
    if (self == [super initWithFrame:frame]) {
        
        self.bgView = [[UIView alloc]init];
        
        self.bgView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        self.bgView.userInteractionEnabled = YES;
        [superView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
            make.leading.equalTo(superView).offset(0);
            make.centerX.mas_equalTo(superView);
            make.top.mas_equalTo(topMargin);
//            make.bottom.mas_equalTo(superView);
            
            make.height.mas_equalTo(50);
        }];
        
        [self.bgView layoutIfNeeded];
        
        
    }
        
    
    return self;
}
- (void)contentOffShow:(BOOL)isShow{
    self.bgView.hidden = !isShow;
}
-(void)richElementsInCellWithModel:(id)model{
    self.arr = model;
    if (self.arr.count==0) {
        return;
    }
//    kWeakSelf(self);
    
    _btns = [NSMutableArray array];
    if ([_bgView viewWithTag:99]) {
        UIView* v= [_bgView viewWithTag:99];
        [v removeFromSuperview];
    }
    
    TTTagView* tagView3 = [[TTTagView alloc] init];
    tagView3.numberOfLines = 1;
    tagView3.tag = 99;
//    self.tagView3.allowsSelection = NO;
//    self.tagView3.selected = YES;
    
    tagView3.tagSelectedBorderColor = [UIColor clearColor];
    tagView3.tagSelectedBackgroundColor = YBGeneralColor.themeColor;
    tagView3.tagBorderColor = [UIColor clearColor];
    tagView3.tagBackgroundColor = [UIColor clearColor];
    tagView3.tagSelectedTextColor = HEXCOLOR(0xffffff);
    tagView3.tagTextColor = HEXCOLOR(0x000000);
    [self.bgView addSubview:tagView3];
    
    [_btns addObject:tagView3];
    NSMutableArray* arr = [NSMutableArray array];
    for (HomeItem*it  in self.arr) {
        [arr addObject:it.name];
    }
    tagView3.tagsArray = self.arr;
    tagView3.defaultSelectTags = tagView3.tagsArray;
    tagView3.userInteractionEnabled = NO;
    

    [tagView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(10);
        make.centerX.equalTo(self.bgView);
    //        make.trailing.equalTo(@-50);
    //        make.height.mas_equalTo(60);

    }];
    
    [self layoutIfNeeded];

}

- (void)startButtonClick{

}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
@end
