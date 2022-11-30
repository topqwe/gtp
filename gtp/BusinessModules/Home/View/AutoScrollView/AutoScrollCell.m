
#import "AutoScrollCell.h"
@interface AutoScrollCell ()
@property (nonatomic, strong) NSMutableArray *btns;

@property(nonatomic,strong)ZXWinnerScrollView* winnerList;
@property (nonatomic,strong)UIView *bgView;

@end

@implementation AutoScrollCell
- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    //下分割线
    //    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    CGContextSetStrokeColorWithColor(context,kClearColor.CGColor);
    CGContextStrokeRect(context,CGRectMake(0, rect.size.height-.5, rect.size.width- 0,2));
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.backgroundColor = kWhiteColor;
    self.contentView.backgroundColor = kWhiteColor;
    
    self.bgView = [[UIView alloc]init];
    self.bgView.backgroundColor = UIColor.blueColor;
    
        
    self.bgView.userInteractionEnabled = YES;
    [self.contentView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                
        make.leading.equalTo(self.contentView).offset(7);
        make.centerX.mas_equalTo(self.contentView);
        make.bottom.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView);
    }];
    self.bgView.layer.borderColor = [UIColor clearColor].CGColor;
    self.bgView.layer.masksToBounds= true;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.cornerRadius = 7;
    
    
    _btns = [NSMutableArray array];
    
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag =  i;
        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        
        button.titleLabel.numberOfLines = 2;
        button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        
        [self.bgView addSubview:button];
        [_btns addObject:button];
        
        button.backgroundColor = UIColor.systemBlueColor;
        
    }
    NSInteger pageSize = 2;
    
    [_btns mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:0 leadSpacing:0 tailSpacing:pageSize*25];
    
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(@0);
        make.trailing.equalTo(@0);
        make.height.mas_equalTo(25);
//        make.width.mas_equalTo(@18);
    }];
    
    self.winnerList = [[ZXWinnerScrollView  alloc]initWithOrigin:CGPointMake(0, 50) width:MAINSCREEN_WIDTH-14 pageSize:pageSize];
    self.winnerList.backgroundColor = kClearColor;
    [self.bgView addSubview:self.winnerList];
    
}

- (void)clickItem:(UIButton*)button{
   
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


+(instancetype)cellWith:(UITableView*)tabelView{
    AutoScrollCell *cell = (AutoScrollCell *)[tabelView dequeueReusableCellWithIdentifier:@"AutoScrollCell"];
    if (!cell) {
        cell = [[AutoScrollCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AutoScrollCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(id)model{
    return 4*25;
}

- (void)richElementsInCellWithModel:(id)model{
    NSArray* array = model;
    
    NSArray *assembleArr =@[];
    
    assembleArr = array.count>1?[array subarrayWithRange:NSMakeRange(0, 2)]:array;
    for (int i =0; i<_btns.count; i++){
        UIButton* button = _btns[i];
        [button setAttributedTitle:assembleArr[i] forState:0];
        if (i==0) {
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        }else{
            button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
    }
    NSArray *winnerArr = [array subarrayWithRange:NSMakeRange(2, array.count-2)];
    
    [self.winnerList reloadData:winnerArr];
}
@end
