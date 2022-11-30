//
//  TableViewCell.m
//  pod_test
//
//  Created by YY_ZYQ on 2017/6/24.
//  Copyright © 2017年 YY_ZYQ. All rights reserved.
//

#import "EditRecordCell.h"
@interface EditRecordCell ()
@property (nonatomic ,strong) UIButton *selectImgBtn;
@property (nonatomic ,strong) UIButton *nameBtn;
@property (nonatomic ,strong) UIButton *titleBtn;
@end

@implementation EditRecordCell

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
        make.width.mas_equalTo(MAINSCREEN_WIDTH/2-20);
    }];
    _selectImgBtn.layer.masksToBounds = true;
    _selectImgBtn.layer.cornerRadius = 8;
    _selectImgBtn.userInteractionEnabled = NO;
//    _selectBtn.backgroundColor = [UIColor blueColor];r
    [_selectImgBtn setTitleColor:UIColor.blackColor forState:0];
    _selectImgBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _selectImgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _nameBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.nameBtn];
//    _nameBtn.frame = CGRectMake(CGRectGetMaxX(self.selectImgBtn.frame)+10, 10, MAINSCREEN_WIDTH -CGRectGetMaxX(self.selectImgBtn.frame)-20, 50);
    [_nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectImgBtn.mas_right).offset(10);
        make.height.equalTo(@50);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
//    _nameBtn.layer.masksToBounds = true;
//    _nameBtn.layer.cornerRadius = 8;
    _nameBtn.userInteractionEnabled = NO;
    _nameBtn.titleLabel.numberOfLines = 2;
    _nameBtn.backgroundColor = [UIColor clearColor];
    [_nameBtn setTitleColor:UIColor.blackColor forState:0];
    _nameBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _nameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _nameBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    _nameBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    _titleBtn = [[UIButton alloc] init];
    [self.contentView addSubview:self.titleBtn];
//    _titleBtn.frame = CGRectMake(_nameBtn.frame.origin.x, [[self class]cellHeightWithModel]-6*10, _nameBtn.frame.size.width, 50);
    [_titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameBtn.mas_left);
        make.height.equalTo(@50);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.right.equalTo(self.nameBtn.mas_right);
    }];
//    _titleBtn.layer.masksToBounds = true;
//    _titleBtn.layer.cornerRadius = 8;
    _titleBtn.userInteractionEnabled = NO;
    _titleBtn.titleLabel.numberOfLines = 1;
    _titleBtn.backgroundColor = [UIColor clearColor];
    [_titleBtn setTitleColor:UIColor.lightGrayColor forState:0];
    _titleBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    _titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _titleBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    
    
}

+(instancetype)cellWith:(UITableView*)tabelView{
    EditRecordCell *cell = (EditRecordCell *)[tabelView dequeueReusableCellWithIdentifier:@"EditRecordCell"];
    if (!cell) {
        cell = [[EditRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EditRecordCell"];
    }
    cell.tintColor = YBGeneralColor.themeColor;
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 150;
}

- (void)richElementsInCellWithModel:(HomeItem*)model{
    [_nameBtn setTitle:model.name forState:0];
    _titleBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_titleBtn setTitle:model.updated_at forState:0];
    
    [_selectImgBtn sd_setImageWithURL:[NSURL URLWithString:model.cover_img] forState:0 placeholderImage:kIMG(@"M_SQUARE_PLACEDHOLDER_IMG")];;
    [_selectImgBtn.imageView setContentMode:UIViewContentModeScaleAspectFill];
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
        
        if (editing)//编辑状态
        {
            if (self.editingStyle == (UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete)){ //编辑多选状态
                self.contentView.backgroundColor = [UIColor clearColor];
                self.backgroundColor = [UIColor clearColor];
                self.textLabel.backgroundColor = [UIColor clearColor];
                self.detailTextLabel.backgroundColor = [UIColor clearColor];
                self.selectImgBtn.backgroundColor = [UIColor clearColor];
                UIControl *control = [self.subviews lastObject];
                if (![[[control subviews] objectAtIndex:0] isKindOfClass:[UIImageView class]]) {
                    return;
                }
                UIImageView * imgView = [[control subviews] objectAtIndex:0];
                imgView.image = [UIImage imageNamed:@"editRecordDeselected"];
                
            }
        }else {  //非编辑模式下检查是否有打勾图片，有的话删除
//            UIControl *control = [self.subviews lastObject];
//            UIImageView * imgView = [[control subviews] objectAtIndex:0];
//            imgView.image = [UIImage imageNamed:@"select"];
            
        }

}
//处理选中背景色问题
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (!self.editing) {
        return;
    }
    [super setSelected:selected animated:animated];
    
    if (self.editing) {
        
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.backgroundColor = [UIColor clearColor];
        self.selectImgBtn.backgroundColor = [UIColor clearColor];
        return;
        UIControl *control = [self.subviews lastObject];
        if ([[control subviews][0] isKindOfClass:[UIImageView class]]) {
            UIImageView * imgView = [[control subviews] objectAtIndex:0];
            imgView.image = [UIImage imageNamed:@"editRecordDeselected"];//40*40
            if (self.isSelected) {
                imgView.image = [UIImage imageNamed:@"editRecordSelected"];
            }else{
                imgView.image = [UIImage imageNamed:@"editRecordDeselected"];
            }
        }
        
          
        
      
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
//    [super setHighlighted:highlighted animated:animated];
//     if (self.isEditing && self.isHighlighted ) {
//         UIControl *control = [self.subviews lastObject];
//         UIImageView * imgView = [[control subviews] objectAtIndex:0];
//         imgView.image = [UIImage imageNamed:@"editRecordSelected"];
//     }
    return;
}



@end
