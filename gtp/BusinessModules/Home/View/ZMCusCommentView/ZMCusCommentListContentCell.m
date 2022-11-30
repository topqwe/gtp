//
//  ZMCusCommentListContentCell.m
//  ZM
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 Kennith. All rights reserved.
//

#import "ZMCusCommentListContentCell.h"
#import "NSString+Size.h"
@interface ZMCusCommentListContentCell()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *designerImageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIButton *timeLab;

@property (nonatomic, copy) ActionBlock block;

@property (nonatomic, strong) HomeItem* item;
@end

@implementation ZMCusCommentListContentCell
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
            make.top.mas_equalTo(14);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    if (!_timeLab) {
        _timeLab = [[UIButton alloc] init];
        
//        [_timeLab setTitleColor:RGBHexColor(0x999999, 1) forState:0];
//        _timeLab.titleLabel.font = [UIFont systemFontOfSize:11];
//        _timeLab.titleLabel.textAlignment = NSTextAlignmentLeft;
        _timeLab.titleLabel.numberOfLines = 0;
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
        _designerImageView.hidden = YES;
        _designerImageView.layer.masksToBounds = YES;
        
        _designerImageView.layer.cornerRadius = 3;
        [self.contentView addSubview:_designerImageView];
        [_designerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLab.mas_right).mas_offset(7);
            make.centerY.mas_equalTo(_headImageView);
            make.size.mas_equalTo(CGSizeMake(31, 10));
        }];
    }
    
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
//        _contentLab.textColor = RGBHexColor(0x333333, 1);
//        _contentLab.font = [UIFont systemFontOfSize:14];
        _contentLab.numberOfLines = 0;
        _contentLab.backgroundColor = [UIColor clearColor];
        [_contentLab sizeToFit];
        [self.contentView addSubview:_contentLab];
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLab);
            make.top.mas_equalTo(_titleLab.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(-14);
            make.bottom.mas_equalTo(self.timeLab.mas_top).offset(-10);
            
        }];
    }
    
}
+(instancetype)cellWith:(UITableView*)tabelView{
    ZMCusCommentListContentCell *cell = (ZMCusCommentListContentCell *)[tabelView dequeueReusableCellWithIdentifier:@"ZMCusCommentListContentCell"];
    if (!cell) {
        cell = [[ZMCusCommentListContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ZMCusCommentListContentCell"];
    }
    return cell;
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
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
                        return self.timeLab.userInteractionEnabled;
                    }
                }
            }
        }
    }
    return isInside;
}

- (void)clickItem:(UIButton*)btn{
//    if (btn.tag -100 == 0) {
//        [self disMissView];
//    }else{
//
//    }
    if (self.block) {
        self.block(self.item);
    }
    
}

- (void)configData:(HomeItem*)data withSource:(NSInteger)s{
    self.item = data;
    
    self.timeLab.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (data.replies>0 && s == 0) {
        [self.timeLab setAttributedTitle:
         
         [NSString attributedStringWithString:[NSString stringWithFormat:@"%@\n",data.reply_at] stringColor:HEXCOLOR(0x8FAEB7) stringFont:[UIFont systemFontOfSize:13] subString:[NSString stringWithFormat:@"%li条回复",(long)data.replies] subStringColor:YBGeneralColor.themeColor subStringFont:kFontSize(15) paragraphStyle:NSTextAlignmentLeft]
                forState:UIControlStateNormal
        ];
        
//        [self.timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_offset(-20);
//        }];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageView.mas_right).mas_offset(7);
//            make.width.mas_offset(180);
            make.right.mas_equalTo(-14);
            make.bottom.mas_offset(-10);
        }];
        self.timeLab.userInteractionEnabled = true;
        [self.timeLab addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [self.timeLab setAttributedTitle:
         
         [NSString attributedStringWithString:[NSString stringWithFormat:@"%@\n",data.reply_at] stringColor:HEXCOLOR(0x8FAEB7) stringFont:[UIFont systemFontOfSize:13] subString:[NSString stringWithFormat:@"%@",@""] subStringColor:YBGeneralColor.themeColor subStringFont:kFontSize(15) paragraphStyle:NSTextAlignmentLeft]
                forState:UIControlStateNormal
        ];
        
//        [self.timeLab mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_offset(-10);
//        }];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_headImageView.mas_right).mas_offset(7);
//            make.width.mas_offset(180);
            make.right.mas_equalTo(-14);
            make.bottom.mas_offset(-10);
        }];
        self.timeLab.userInteractionEnabled = false;
    }
    
    
    if (data.replied_nickname.length>0 && s==1) {
//        self.contentLab.text = [NSString stringWithFormat:@"%@",data.content];
        [self.contentLab setAttributedText:
                
                [NSString attributedStringWithString:[NSString stringWithFormat:@"@%@ ",data.replied_nickname] stringColor:YBGeneralColor.themeColor stringFont:[UIFont systemFontOfSize:14] subString:[NSString stringWithFormat:@"%@",data.content] subStringColor:HEXCOLOR(0x707070) subStringFont:kFontSize(14) paragraphStyle:NSTextAlignmentLeft]
         ];
    }else{
        [self.contentLab setAttributedText:
                
                [NSString attributedStringWithString:[NSString stringWithFormat:@"%@\n",data.content] stringColor:HEXCOLOR(0x707070) stringFont:[UIFont systemFontOfSize:14] subString:[NSString stringWithFormat:@"%@",@""] subStringColor:YBGeneralColor.themeColor subStringFont:kFontSize(14) paragraphStyle:NSTextAlignmentLeft]
         ];
    }
    
    
    self.titleLab.text = [NSString stringWithFormat:@"%@",data.nickname];
    [self.headImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"mine_avator%li",(long)data.avatar]] ];
    
//    CGFloat titleWidth = [self.titleLab.text widthWithFont:[UIFont boldSystemFontOfSize:14] constrainedToHeight:20]+5;
//    if (titleWidth>100) {
//        titleWidth = 100;
//    }
//    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_offset(titleWidth);
//    }];
    
}
@end
