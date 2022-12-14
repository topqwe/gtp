//
//  TTTableViewCell.m
//  TTTagView_Example
//
//  Created by 王家强 on 2020/6/30.
//  Copyright © 2020 icofans. All rights reserved.
//

#import "TTTableViewCell.h"
#import "TTTagView.h"
#import <Masonry/Masonry.h>

@interface TTTableViewCell ()

@property (nonatomic,strong) TTTagView *tagView;

@end

@implementation TTTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.tagView = [[TTTagView alloc] init];
        [self.contentView addSubview:self.tagView];
        
        // 在tagview中获取不到真实的宽度,未找到原因
        CGRect frame = self.contentView.frame;
        frame.size.width = [UIScreen mainScreen].bounds.size.width;
        self.contentView.frame = frame;
        
        [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(16);
            make.bottom.right.mas_equalTo(-16);
        }];
    }
    return self;
}

- (void)setCellInfo:(NSArray *)tags
{
    self.tagView.tagsArray = tags;
    self.tagView.defaultSelectTags = @[self.tagView.tagsArray.firstObject];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
