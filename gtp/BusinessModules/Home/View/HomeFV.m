
#import "HomeFV.h"

@interface HomeFV ()
@property (nonatomic,copy) NSArray *arr;

@property (nonatomic,strong)NSMutableArray *btns;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic,strong)UIView *bgView;

@end
@implementation HomeFV

- (id)initWithFrame:(CGRect)frame InSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin{
    if (self == [super initWithFrame:frame]) {
        
        self.bgView = [[UIView alloc]init];
//        self.bgView.backgroundColor = kWhiteColor;
        self.bgView.userInteractionEnabled = YES;
        [superView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
            make.leading.equalTo(superView).offset(30);
            make.centerX.mas_equalTo(superView);
            make.bottom.mas_equalTo(topMargin);
            make.top.mas_equalTo(superView);
        }];
        
        
        
        
        [self.bgView layoutIfNeeded];
        
    }
        
    
    return self;
}

-(void)richElementsInCellWithModel:(id)model{
    self.arr = model;
    if (self.arr.count==0) {
        return;;
    }
    
    _btns = [NSMutableArray array];
    
    for (int i = 0; i < self.arr.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.numberOfLines = 2;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        //            [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.bgView addSubview:button];
        [_btns addObject:button];
//        [button setAttributedTitle:self.turnArr[i] forState:0];
        
    }
    
    [_btns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.mas_equalTo((50/self.arr.count));
//        make.width.mas_equalTo(@18);
    }];
    
    

}

- (void)startButtonClick{

}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
@end
