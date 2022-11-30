//
//  ZMCusCommentListReplyContentCell.m
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import "ZMCusCommentListReplyContentCell.h"
#import "NSString+Size.h"
@interface ZMCusCommentListReplyContentCell()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *designerImageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UIButton *contentLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIImageView *lineImageView;
@property (nonatomic, strong) UILabel *replyNameLab;
@property (nonatomic, strong) UILabel *replyContentLab;

@property (nonatomic, copy) ActionBlock block;
@end

@implementation ZMCusCommentListReplyContentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutUI];
    }
    return self;
}

- (void)layoutUI{

    
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        [_headImageView setImage:[UIImage imageNamed:@"mine_avator1"]];
        [self.contentView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.top.mas_equalTo(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = RGBHexColor(0x999999, 1);
        _timeLab.font = [UIFont systemFontOfSize:11];
        _timeLab.textAlignment = NSTextAlignmentLeft;
        _timeLab.numberOfLines = 0;
        _timeLab.backgroundColor = [UIColor clearColor];
        [_timeLab sizeToFit];
        [self.contentView addSubview:_timeLab];
//        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(-14);
//            make.centerY.mas_equalTo(_headImageView);
//            make.width.mas_offset(80);
//
//        }];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageView.mas_right).mas_offset(7);
//            make.width.mas_offset(180);
            make.right.mas_equalTo(-14);
            make.bottom.mas_equalTo(-10);
        }];
    }
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = RGBHexColor(0x333333, 1);
        _titleLab.font = [UIFont boldSystemFontOfSize:14];
        _titleLab.numberOfLines = 1;
        _titleLab.backgroundColor = [UIColor clearColor];
        [_titleLab sizeToFit];
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageView.mas_right).mas_offset(7);
            make.centerY.mas_equalTo(_headImageView);
            make.height.mas_offset(20);
            
        }];
    }
    if (!_designerImageView) {
        _designerImageView = [[UIImageView alloc] init];
        [_designerImageView setBackgroundColor:[UIColor redColor]];
        [self.contentView addSubview:_designerImageView];
        [_designerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLab.mas_right).mas_offset(7);
            make.centerY.mas_equalTo(_headImageView);
            make.size.mas_equalTo(CGSizeMake(31, 10));
        }];
    }
    
    if (!_contentLab) {
        _contentLab = [[UIButton alloc] init];
        [_contentLab setTitleColor:RGBHexColor(0x333333, 1) forState:0];
        
        _contentLab.titleLabel.font = [UIFont systemFontOfSize:14];
        _contentLab.titleLabel.numberOfLines = 0;
        _contentLab.backgroundColor = [UIColor clearColor];
//        [_contentLab sizeToFit];
        [self.contentView addSubview:_contentLab];
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLab);
            make.top.mas_equalTo(_titleLab.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(-14);
            
        }];
    }

    if (!_replyNameLab) {
        _replyNameLab = [[UILabel alloc] init];
        _replyNameLab.textColor = RGBA(102, 102, 102, 1);
        _replyNameLab.font = [UIFont systemFontOfSize:13];
        _replyNameLab.numberOfLines = 1;
        _replyNameLab.backgroundColor = [UIColor clearColor];
        [_replyNameLab sizeToFit];
        [self.contentView addSubview:_replyNameLab];
        [_replyNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentLab.mas_left).mas_offset(11);
            make.top.mas_equalTo(_contentLab.mas_bottom).mas_offset(14);
            make.right.mas_equalTo(-14);
            make.height.mas_offset(15);
            
        }];
    }
    if (!_replyContentLab) {
        _replyContentLab = [[UILabel alloc] init];
        _replyContentLab.textColor = RGBA(102, 102, 102, 1);
        _replyContentLab.font = [UIFont systemFontOfSize:13];
        _replyContentLab.numberOfLines = 0;
        _replyContentLab.backgroundColor = [UIColor clearColor];
        [_replyContentLab sizeToFit];
        [self.contentView addSubview:_replyContentLab];
        [_replyContentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentLab.mas_left).mas_offset(11);
            make.top.mas_equalTo(_replyNameLab.mas_bottom).mas_offset(3);
            make.right.mas_equalTo(-14);
//            make.bottom.mas_equalTo(-30);
            make.bottom.mas_equalTo(self.timeLab.mas_top).offset(-10);
            
        }];
    }
    if (!_lineImageView) {
        _lineImageView = [[UIImageView alloc] init];
        [_lineImageView setBackgroundColor:RGBA(228, 228, 228, 1)];
        [self.contentView addSubview:_lineImageView];
        [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLab.mas_left).mas_offset(-1);
            make.width.mas_offset(1);
            make.top.mas_equalTo(_contentLab.mas_bottom).mas_offset(16);
            make.height.mas_offset(0);
        }];
    }

    
    
}

+(instancetype)cellWith:(UITableView*)tabelView{
    ZMCusCommentListReplyContentCell *cell = (ZMCusCommentListReplyContentCell *)[tabelView dequeueReusableCellWithIdentifier:@"ZMCusCommentListReplyContentCell"];
    if (!cell) {
        cell = [[ZMCusCommentListReplyContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZMCusCommentListReplyContentCell"];
    }
    return cell;
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (void)clickItem:(UIButton*)btn{
//    if (btn.tag -100 == 0) {
//        [self disMissView];
//    }else{
//
//    }
    if (self.block) {
        self.block(@(100));
    }
    
}

// 判断点击的point是否在cell的Button之上
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL isInside = [super pointInside:point withEvent:event];
    for (UIView *subView in self.subviews.reverseObjectEnumerator) {
        // 获取Cell中的ContentView
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
            for (UIView *sSubView in subView.subviews.reverseObjectEnumerator) {
                // 获取ContentView中的Button子视图
                if ([sSubView isKindOfClass:[UIButton class]]) {
                    // point是否在子视图Button之上
                    BOOL isInSubBtnView = CGRectContainsPoint(sSubView.frame, point);
                    if (isInSubBtnView) {
                        return self.contentLab.userInteractionEnabled;
                    }
                }
            }
        }
    }
    return isInside;
}
- (void)configData:(id)data{
    
    self.timeLab.text = @"11分钟前\n32rfwegwegwe";
    [self.timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_offset(-20);
    }];
    
    self.titleLab.text = @"愤怒的小栗子";
    [self.contentLab setTitle:@"不错挺好的，现在开始还来得及。只不过从某种意上讲事情没有这么简单不错挺好的，现在开始还来得及。只不过从某种意上讲事情没有这么简单不错挺好的，现在开始还来得及。只不过从某种意上讲事情没有这么简单" forState:0];
    [self.contentLab addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
//    [_contentLab sizeToFit];
    CGFloat contentHeight0 =[self.contentLab.titleLabel.text heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:MAINSCREEN_WIDTH-28-18-12];
    [self.contentLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(15+contentHeight0);
    }];
    
    self.replyNameLab.text = @"@小栗子";
    self.replyContentLab.text = @"不错挺好的，现在开始还来得及。只不过从某种意上讲事情没有这么简单不错挺好的，现在开始还来得及。只不过从某种意上讲事情没有这么简单不错挺好的，现在开始还来得及。只不过从某种意上讲事情没有这么简单";
    CGFloat titleWidth = [self.titleLab.text widthWithFont:[UIFont boldSystemFontOfSize:14] constrainedToHeight:20]+5;
    if (titleWidth>100) {
        titleWidth = 100;
    }
    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(titleWidth);
    }];
    
    CGFloat contentHeight =[self.replyContentLab.text heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:MAINSCREEN_WIDTH-28-7-18-12];
    [self.lineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(15+contentHeight);
    }];

}

//-(CGFloat)getViewHeightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width{
//    if (text.length>0) {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
//        label.font = font;
//        label.numberOfLines = 0;
//        label.text = text;
//        [label sizeToFit];
//        return CGRectGetHeight(label.frame);
//    }
//    return 0;
//}

@end
