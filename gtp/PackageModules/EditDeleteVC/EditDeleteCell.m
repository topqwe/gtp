//
//  TableViewCell.m
//  pod_test
//
//  Created by YY_ZYQ on 2017/6/24.
//  Copyright © 2017年 YY_ZYQ. All rights reserved.
//

#import "EditDeleteCell.h"

@implementation EditDeleteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //处理选中背景色问题
        self.contentView.backgroundColor = [UIColor clearColor];
           UIView *backGroundView = [[UIView alloc]init];
           backGroundView.backgroundColor = [UIColor clearColor];
           self.selectedBackgroundView = backGroundView;
            
        [self.contentView addSubview:self.selectBtn];
    }
    return self;
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        self.selectBtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 0, 50, self.contentView.bounds.size.height)];
        _selectBtn.userInteractionEnabled = NO;
        [_selectBtn setImage:[UIImage imageNamed:@""] forState:0];
        //deselect
        [_selectBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateSelected];
        //select
        _selectBtn.backgroundColor = [UIColor clearColor];
        [_selectBtn setTitleColor:UIColor.blackColor forState:0];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _selectBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }
    return _selectBtn;
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
                self.selectBtn.backgroundColor = [UIColor clearColor];
                UIControl *control = [self.subviews lastObject];
                UIImageView * imgView = [[control subviews] objectAtIndex:0];
                imgView.image = [UIImage imageNamed:@"editDeleteDeselected"];
                
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
        self.selectBtn.backgroundColor = [UIColor clearColor];
        
        UIControl *control = [self.subviews lastObject];
        UIImageView * imgView = [[control subviews] objectAtIndex:0];
        imgView.image = [UIImage imageNamed:@"editDeleteDeselected"];
        if (self.isSelected) {
            imgView.image = [UIImage imageNamed:@"editDeleteSelected"];
        }else{
            imgView.image = [UIImage imageNamed:@"editDeleteDeselected"];
        }
          
        
      
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
//    [super setHighlighted:highlighted animated:animated];
//     if (self.isEditing && self.isHighlighted ) {
//         UIControl *control = [self.subviews lastObject];
//         UIImageView * imgView = [[control subviews] objectAtIndex:0];
//         imgView.image = [UIImage imageNamed:@"select"];
//     }
    return;
}



@end
