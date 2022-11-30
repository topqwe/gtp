
#import "HomeHV.h"
#import "LXTagsView.h"
@interface HomeHV ()
@property (nonatomic,copy) NSArray *arr;
@property (nonatomic ,strong)LXTagsView *tagsView;
@property (nonatomic,strong)NSMutableArray *btns;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic,strong)UIView *bgView;

@end
@implementation HomeHV

- (id)initWithFrame:(CGRect)frame InSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin{
    if (self == [super initWithFrame:frame]) {
        
        self.bgView = [[UIView alloc]init];
        self.bgView.backgroundColor = UIColor.whiteColor;
        self.bgView.userInteractionEnabled = YES;
        [superView addSubview:self.bgView];
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
            make.leading.equalTo(superView).offset(0);
            make.centerX.mas_equalTo(superView);
            make.top.mas_equalTo(topMargin);
            make.bottom.mas_equalTo(superView);
        }];
        
        [self.bgView layoutIfNeeded];
        
        self.tagsView =[[LXTagsView alloc]init];
        self.tagsView.s = SearchRecordSourceWords;
//        self.tagsView.layer.borderWidth = 10;
//        self.tagsView.layer.borderColor = [UIColor clearColor].CGColor;
        [self.bgView addSubview:self.tagsView];

        [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.bgView);
        }];
        
    }
        
    
    return self;
}

-(void)richElementsInCellWithModel:(id)model{
    self.arr = model;
    
    self.tagsView.dataA = model;
    self.tagsView.tagClick = ^(id tagTitle) {
        NSLog(@"cell打印---%@",tagTitle);
        if (self.block) {
            self.block(tagTitle);
        }
    };
    [self layoutIfNeeded];

}

- (void)startButtonClick{

}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
@end
