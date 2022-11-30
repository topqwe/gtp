
#import "MyShareCell.h"
@interface MyShareCell ()
@property (nonatomic ,strong) UIButton *selectImgBtn;
@property (nonatomic ,strong) UIButton *nameBtn;
@property (nonatomic ,strong) UIButton *titleBtn;
@property (nonatomic ,strong) UIButton *contentBtn;
@end

@implementation  MyShareCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //处理选中背景色问题
       self.contentView.backgroundColor = [UIColor clearColor];
       UIView *backGroundView = [[UIView alloc]init];
       backGroundView.backgroundColor = [UIColor clearColor];
       self.selectedBackgroundView = backGroundView;
            
        [self richEles];
    }
    return self;
}

- (void)richEles{
    
    _selectImgBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.selectImgBtn];
//    _selectImgBtn.frame = CGRectMake(10, 10, MAINSCREEN_WIDTH/2-20, 150-2*10);
    [_selectImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.top.left.equalTo(self.contentView).offset(10);
        make.width.height.mas_equalTo(65);
    }];
    _selectImgBtn.layer.masksToBounds = true;
    _selectImgBtn.layer.cornerRadius = 65/2;
    _selectImgBtn.userInteractionEnabled = NO;
//    _selectBtn.backgroundColor = [UIColor blueColor];r
    [_selectImgBtn setTitleColor:UIColor.blackColor forState:0];
    _selectImgBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _selectImgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _nameBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.nameBtn];
//    _nameBtn.frame = CGRectMake(CGRectGetMaxX(self.selectImgBtn.frame)+10, 10, MAINSCREEN_WIDTH -CGRectGetMaxX(self.selectImgBtn.frame)-20, 50);
    [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@50);
        make.width.equalTo(@180);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
//    _nameBtn.layer.masksToBounds = true;
//    _nameBtn.layer.cornerRadius = 8;
    _nameBtn.userInteractionEnabled = NO;
    _nameBtn.titleLabel.numberOfLines = 1;
    _nameBtn.backgroundColor = [UIColor clearColor];
    [_nameBtn setTitleColor:HEXCOLOR(0x8FAEB7) forState:0];
    _nameBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    _nameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _nameBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _titleBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.titleBtn];
//    _titleBtn.frame = CGRectMake(_nameBtn.frame.origin.x, [[self class]cellHeightWithModel]-6*10, _nameBtn.frame.size.width, 50);
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectImgBtn.mas_right).offset(10);
        make.height.equalTo(@50);
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.nameBtn.mas_left);
    }];
//    _titleBtn.layer.masksToBounds = true;
//    _titleBtn.layer.cornerRadius = 8;
    _titleBtn.userInteractionEnabled = NO;
    _titleBtn.titleLabel.numberOfLines = 1;
    _titleBtn.backgroundColor = [UIColor clearColor];
    
    _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _titleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    _contentBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.contentBtn];
//    _titleBtn.frame = CGRectMake(_nameBtn.frame.origin.x, [[self class]cellHeightWithModel]-6*10, _nameBtn.frame.size.width, 50);
//    _titleBtn.layer.masksToBounds = true;
//    _titleBtn.layer.cornerRadius = 8;
    _contentBtn.userInteractionEnabled = NO;
    _contentBtn.titleLabel.numberOfLines = 1;
    _contentBtn.backgroundColor = [UIColor clearColor];
    
    _contentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _contentBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
}

+(instancetype)cellWith:(UITableView*)tabelView{
    MyShareCell *cell = (MyShareCell *)[tabelView dequeueReusableCellWithIdentifier:@"MyShareCell"];
    if (!cell) {
        cell = [[MyShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyShareCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 85;
}

- (void)richElementsInCellWithModel:(HomeItem*)model{
    [_titleBtn setTitleColor:HEXCOLOR(0x8FAEB7) forState:0];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [_titleBtn setTitle:model.nickname forState:0];
    _titleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    [_nameBtn setTitle:model.date forState:0];
    
    [_selectImgBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mine_avator%li",(long)model.avatar]] forState:0];
    [_selectImgBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)richElementsInLevelListCellWithModel:(HomeItem*)model{
    [_titleBtn setAttributedTitle:[NSString attributedStringWithString:[NSString stringWithFormat:@"%@ ",model.name] stringColor:HEXCOLOR(0x000000) stringFont:[UIFont boldSystemFontOfSize:18] subString:[NSString stringWithFormat:@"%@ 元",model.amount] subStringColor:HEXCOLOR(0xFF0000) subStringFont:kFontSize(18) paragraphStyle:NSTextAlignmentLeft] forState:UIControlStateNormal];
    _titleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.top.left.equalTo(self.contentView).offset(10);
        make.height.mas_equalTo(50);
        make.right.equalTo(self.nameBtn.mas_left);
    }];
    _nameBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [_nameBtn setTitle:model.updated_at forState:0];
    
//    [_selectImgBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mine_avator%li",(long)model.avatar]] forState:0];
//    [_selectImgBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

- (void)richElementsInMsgHomeListCellWithModel:(HomeItem*)model{
    _titleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [_titleBtn setTitleColor:HEXCOLOR(0x000000) forState:0];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [_titleBtn setTitle:model.to_user_nickname forState:0];
    _titleBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [_titleBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
        make.top.equalTo(self.selectImgBtn.mas_top).offset(5);
        make.left.equalTo(self.selectImgBtn.mas_right).offset(10);
        make.height.equalTo(@50);
//        make.right.equalTo(self.nameBtn.mas_left);
    }];
    
    _nameBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    [_nameBtn setTitleColor:HEXCOLOR(0x000000) forState:0];
    [_nameBtn setTitle:model.created_at forState:0];
    [_nameBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectImgBtn.mas_top).offset(5);
        make.height.equalTo(@50);
//        make.width.equalTo(@180);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    [_selectImgBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mine_avator%li",(long)model.avatar]] forState:0];
    [_selectImgBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
    
    [_contentBtn setTitleColor:HEXCOLOR(0x000000) forState:0];
    _contentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _contentBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    if ([model.content containsString:@"http"]&&
        ([model.content containsString:@".png"]||
         [model.content containsString:@".jpg"])) {
        [_contentBtn setTitle:[NSString stringWithFormat:@"%@",@"[图片]"] forState:0];
    }else{
        [_contentBtn setTitle:[NSString stringWithFormat:@"%@",model.content] forState:0];
    }
    
    [_contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.selectImgBtn.mas_bottom).offset(0);
        make.left.equalTo(self.selectImgBtn.mas_right).offset(10);
        make.height.equalTo(@50);
    }];
}
@end
