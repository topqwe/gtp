//
//  TableViewCell.m
//  pod_test
//
//  Created by YY_ZYQ on 2017/6/24.
//  Copyright © 2017年 YY_ZYQ. All rights reserved.
//

#import "SearchCell.h"
#import "LXTagsView.h"
@interface SearchCell ()
@property (nonatomic ,strong)LXTagsView *tagsView;
@property (nonatomic ,strong) UIButton *selectImgBtn;
@property (nonatomic ,strong) UIButton *nameBtn;
@property (nonatomic ,strong) UIButton *titleBtn;
@property (nonatomic, copy) ActionBlock block;
@end

@implementation  SearchCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        //处理选中背景色问题
       self.contentView.backgroundColor = [UIColor clearColor];
//        UIView *backGroundView = [[UIView alloc]init];
//       backGroundView.backgroundColor = [UIColor clearColor];
//       self.selectedBackgroundView = backGroundView;
            
        [self richEles];
    }
    return self;
}

- (void)richEles{
    self.tagsView =[[LXTagsView alloc]init];
    self.tagsView.s = SearchRecordSourceTags;
    self.tagsView.layer.borderWidth = 10;
    self.tagsView.layer.borderColor = [UIColor clearColor].CGColor;
    [self.contentView addSubview:self.tagsView];

    [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.contentView);
    }];
}

+(instancetype)cellWith:(UITableView*)tabelView{
    SearchCell *cell = (SearchCell *)[tabelView dequeueReusableCellWithIdentifier:@"SearchCell"];
    if (!cell) {
        cell = [[SearchCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SearchCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NSArray*)model{
    
    return 90;
}

- (void)richElementsInCellWithModel:(NSArray*)model{
    self.tagsView.dataA = model;
    self.tagsView.tagClick = ^(id tagTitle) {
        NSLog(@"cell打印---%@",tagTitle);
        if (self.block) {
            self.block(tagTitle);
        }
    };
    [self.contentView layoutIfNeeded];
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
@end
