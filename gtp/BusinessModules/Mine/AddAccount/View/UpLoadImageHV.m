
#import "UpLoadImageHV.h"

@interface UpLoadImageHV ()<UITextFieldDelegate>
//@property (nonatomic, assign) TransactionAmountType type;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong)id requestParams;
@end

@implementation UpLoadImageHV

- (instancetype)initWithFrame:(CGRect)frame WithModel:(id)requestParams{
    self = [super initWithFrame:frame];
    if (self) {
        _requestParams = requestParams;
        [self publicTopPartView];
//        _type = [_requestParams.amountType intValue];
//        if (_type == TransactionAmountTypeLimit){
//            [self richElesInLimitView];
//        }else{
//            [self richElesInFixedView];
//        }
        
    }
    return self;
}

- (void)publicTopPartView{
    UIView * topline = [[UIView alloc]init];
    topline.backgroundColor = HEXCOLOR(0xf6f5fa);
    [self addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(5);
        make.left.right.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
    }];
    
    //title
    UILabel * titleLb = [[UILabel alloc] init];
    titleLb.text = @"上传您的收款二维码";
    titleLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.top.mas_equalTo(25);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerX.mas_equalTo(self);
    }];
    //上传图片大按钮
    UIButton* uploadImgBtn = [[UIButton alloc] init];
    [self addSubview:uploadImgBtn];
    [uploadImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(118);
        make.top.equalTo(titleLb.mas_bottom).offset(15);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.centerX.mas_equalTo(self);
    }];
    
    [uploadImgBtn.layer setCornerRadius:5];
    uploadImgBtn.layer.masksToBounds = YES;
    [uploadImgBtn.layer setBorderColor:[UIColor colorWithRed:216.0/256 green:216.0/256 blue:216.0/256 alpha:1].CGColor];
    [uploadImgBtn.layer setBorderWidth:1.0];
    uploadImgBtn.backgroundColor = [UIColor colorWithRed:247.0/256 green:248.0/256 blue:249.0/256 alpha:1];
    [uploadImgBtn addTarget:self action:@selector(uploadImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [uploadImgBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [uploadImgBtn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];
    uploadImgBtn.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    uploadImgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}
-(void)uploadImgBtnClick:(UIButton*)sender{
    if (self.block) {
        self.block(sender);
    }
}
- (void)actionBlock:(DataBlock)block{
    self.block = block;
}

- (instancetype)initWithFrame:(CGRect)frame WithNotYetVertifyModel:(id)requestParams{
    self = [super initWithFrame:frame];
    if (self) {
        _requestParams = requestParams;
        [self notYetVertifyPartView];
        
        
    }
    return self;
}

- (void)notYetVertifyPartView{
    
    UILabel * titleLb = [[UILabel alloc] init];
    titleLb.text = @"请上传手持身份证照片";
    titleLb.font = [UIFont systemFontOfSize:17];
    [self addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(24);
        make.top.mas_equalTo(18);
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.centerX.mas_equalTo(self);
    }];
    //上传图片大按钮
    UIButton* uploadImgBtn = [[UIButton alloc] init];
    [self addSubview:uploadImgBtn];
    [uploadImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(144);
        make.top.equalTo(titleLb.mas_bottom).offset(15);
        make.left.mas_equalTo(50);
        make.right.mas_equalTo(-50);
        make.centerX.mas_equalTo(self);
    }];
    
    [uploadImgBtn.layer setCornerRadius:5];
    uploadImgBtn.layer.masksToBounds = YES;
    [uploadImgBtn.layer setBorderColor:[UIColor colorWithRed:216.0/256 green:216.0/256 blue:216.0/256 alpha:1].CGColor];
    [uploadImgBtn.layer setBorderWidth:1.0];
    uploadImgBtn.backgroundColor = [UIColor colorWithRed:247.0/256 green:248.0/256 blue:249.0/256 alpha:1];
    [uploadImgBtn addTarget:self action:@selector(uploadImgBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [uploadImgBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [uploadImgBtn setImage:[UIImage imageNamed:@"handIdentity"] forState:UIControlStateNormal];
    uploadImgBtn.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
    uploadImgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
}
@end
