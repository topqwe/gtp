//  Created by WIQ on 2018/12/28.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import "PostAdsTypeCell.h"
#import "PostAdsModel.h"
@interface PostAdsTypeCell ()
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) NSMutableArray *leftLabs;
@property (nonatomic, strong) NSMutableArray *rightLabs;
@end

@implementation PostAdsTypeCell
- (void)drawRect:(CGRect)rect {
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillRect(context, rect);
    //上分割线，
    //    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    //    CGContextStrokeRect(context, CGRectMake(5, -1, rect.size.width - 10, 1));
    //下分割线
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CGContextSetStrokeColorWithColor(context,HEXCOLOR(0xf6f5fa).CGColor);
    CGContextStrokeRect(context,CGRectMake(0, rect.size.height-.5, rect.size.width- 0,2));
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self richEles];
    }
    return self;
}


- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.scrollEnabled = NO;
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(20, 24, 20, 24));
    }];
    //scrollView计算contentSize的时候，要先用一个containView填满整个scrollView，这样约束才能够准确计算
    // 这个containView是用来先填充整个scrollView的,到时候这个containView的size就是scrollView的contentSize
    UIView *containView = [UIView new];
    containView.backgroundColor = kWhiteColor;
    [scrollView addSubview:containView];
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(scrollView);
        make.width.equalTo(scrollView);
    }];
    
    UIView *lastView = nil;
    _leftLabs = [NSMutableArray array];
    _rightLabs = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        
        UIView *sub_view = [UIView new];
//        sub_view.backgroundColor = RANDOMRGBCOLOR;
        
        UILabel* leftLab = [[UILabel alloc]init];
        leftLab.text = @"A";
        leftLab.tag = i;
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.textColor = HEXCOLOR(0x94368);
        leftLab.font = kFontSize(15);
        [sub_view addSubview:leftLab];
        [_leftLabs addObject:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(sub_view).offset(20);
            make.top.equalTo(sub_view).offset(9.5);
            make.bottom.equalTo(sub_view).offset(-9.5);
        }];
        
        UILabel* rightLab = [[UILabel alloc]init];
        rightLab.text = @"B";
        rightLab.tag = i;
        leftLab.textAlignment = NSTextAlignmentRight;
        rightLab.textColor = HEXCOLOR(0x94368);
        rightLab.font = kFontSize(15);
        [sub_view addSubview:rightLab];
        [_rightLabs addObject:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(sub_view).offset(-20);
            make.top.equalTo(sub_view).offset(9.5);
            make.bottom.equalTo(sub_view).offset(-9.5);
        }];
        [containView addSubview:sub_view];
        
        sub_view.layer.cornerRadius = 4;
        sub_view.layer.borderWidth = 1;
        sub_view.layer.masksToBounds = YES;
        
        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.and.right.equalTo(containView);
            
            make.height.mas_equalTo(@(40));//*i
        
            if (lastView)
            {
                make.top.mas_equalTo(lastView.mas_bottom).offset(15);
                //上2个
                lastView.backgroundColor = HEXCOLOR(0xf2f1f6);
                lastView.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
            }else
            {
                make.top.mas_equalTo(containView.mas_top);
                
                
            }
            
        }];
        //最后一个
        sub_view.backgroundColor = kWhiteColor;
        sub_view.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
        lastView = sub_view;
        
    }
    // 最后更新containView
    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView.mas_bottom).offset(15);
    }];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
}


+(instancetype)cellWith:(UITableView*)tabelView{
    PostAdsTypeCell *cell = (PostAdsTypeCell *)[tabelView dequeueReusableCellWithIdentifier:@"PostAdsTypeCell"];
    if (!cell) {
        cell = [[PostAdsTypeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PostAdsTypeCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 190;
}

- (void)richElementsInCellWithModel:(NSArray*)model{
    
    UILabel* lab0 = _leftLabs[0];
    lab0.text = @"MIA种";
    UILabel* lab1 = _leftLabs[1];
    lab1.text = @"货MIA类型";
    UILabel* lab2 = _leftLabs[2];
    lab2.text = @"暨起";

    UILabel* rlab0 = _rightLabs[0];
    rlab0.text = [NSString stringWithFormat:@"%@",@"AB"];
    UILabel* rlab1 = _rightLabs[1];
    rlab1.text = [NSString stringWithFormat:@"%@",@"🎂MIA"];
    UILabel* rlab2 = _rightLabs[2];
    rlab2.text = [NSString stringWithFormat:@"%@",@"AB:🎂MIA = 1:1"];;
    
}

@end
