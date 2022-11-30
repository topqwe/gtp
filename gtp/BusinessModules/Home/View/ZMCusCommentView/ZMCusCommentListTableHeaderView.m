//
//  ZMCusCommentListTableHeaderView.m
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import "ZMCusCommentListTableHeaderView.h"
@interface ZMCusCommentListTableHeaderView ()
@property (nonatomic, strong) UIButton *closeBtn;
@end;
@implementation ZMCusCommentListTableHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = RGBHexColor(0xffffff, 1);
        [self layoutUI];
        
    }
    return self;
}
- (void)layoutUI{
    if (!_closeBtn) {
        UIImage *image = [UIImage imageNamed:@"M_X"];
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:image forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(clostBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_closeBtn];
        [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.top.mas_equalTo(27);
            make.size.mas_equalTo(CGSizeMake(12, 12));
        }];
    }

    if (!_titleLabel) {
        _titleLabel = [[UIButton alloc] init];
        _titleLabel.titleLabel.font = [UIFont systemFontOfSize:17];
        [_titleLabel setTitleColor:HEXCOLOR(0x8FAEB7) forState:0];
        _titleLabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_titleLabel setTitle:@"大家都在讨论" forState:0];
        _titleLabel.titleLabel.numberOfLines = 1;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_titleLabel sizeToFit];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.top.mas_equalTo(25);
            make.right.mas_equalTo(_closeBtn.mas_left).mas_offset(-14);
        }];
        [_titleLabel addTarget:self action:@selector(titleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    
    

    
}
- (void)titleBtnAction{
    
    if (self.titleBtnBlock) {
        self.titleBtnBlock();
    }
    
}
- (void)clostBtnAction{
    
    if (self.closeBtnBlock) {
        self.closeBtnBlock();
    }
    
}
@end
