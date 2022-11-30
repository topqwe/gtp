//
//  BottomView.m
//  pod_test
//
//  Created by YY_ZYQ on 2017/6/23.
//  Copyright © 2017年 YY_ZYQ. All rights reserved.
//

#import "EditDeleteBV.h"

@implementation EditDeleteBV

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.allBtn];
        [self addSubview:self.readBtn];
        [self addSubview:self.deleteBtn];
    }
    return self;
}

- (UIButton *)allBtn{
    if (!_allBtn) {
        self.allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _allBtn.frame = CGRectMake(10, 0, 90, self.bounds.size.height);
        _allBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_allBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_allBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_allBtn setImage:[UIImage imageNamed:@"editDeleteDeselected"] forState:0];
        //deselect
        [_allBtn setImage:[UIImage imageNamed:@"editDeleteSelected"] forState:UIControlStateSelected];
        //select
    }
    return _allBtn;
}


- (UIButton *)readBtn{
    if (!_readBtn) {
        self.readBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _readBtn.frame = CGRectMake((self.bounds.size.width - 70)/2, 0, 70, self.bounds.size.height);
        _readBtn.titleLabel.font = [UIFont systemFontOfSize:14];//标记已读
        [_readBtn setTitle:@"" forState:UIControlStateNormal];
        [_readBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _readBtn;
}

- (UIButton *)deleteBtn{
    if (!_deleteBtn) {
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.frame = CGRectMake(self.bounds.size.width - 50, 0, 40, self.bounds.size.height);
        _deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return _deleteBtn;
}

@end
