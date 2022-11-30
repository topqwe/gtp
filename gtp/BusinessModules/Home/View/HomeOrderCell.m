//
//  SPCell.m
//  PPOYang
//
//  Created by WIQ on 2017/7/25.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "HomeOrderCell.h"
#import "HomeModel.h"

@interface HomeOrderCell ()
@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) UILabel *accLab;

@end

@implementation HomeOrderCell{
    NSTimer   *_timer;
    NSInteger _second;
}
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
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerRun:) userInfo:nil repeats:YES];
        //将定时器加入NSRunLoop，保证滑动表时，UI依然刷新
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
        
        [self richEles];
    }
    return self;
}



- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    _accLab = [[UILabel alloc]init];
    [self.contentView addSubview:_accLab];
    _accLab.textAlignment = NSTextAlignmentLeft;
    _accLab.numberOfLines = 0;
    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(11);
        make.leading.equalTo(self.contentView).offset(30);
//        make.trailing.equalTo(self.contentView).offset(-30);
        make.centerX.equalTo(self.contentView);
//        make.height.equalTo(@20);
    }];

    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

+(instancetype)cellWith:(UITableView*)tabelView{
    HomeOrderCell *cell = (HomeOrderCell *)[tabelView dequeueReusableCellWithIdentifier:@"HomeOrderCell"];
    if (!cell) {
        cell = [[HomeOrderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeOrderCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(NSInteger)second{
    CGFloat stringHeight = [NSString getAttributeContentHeightWithAttributeString:[HomeOrderCell mergeAttributedStringWithSecond:second] withFontSize:16 boundingRectWithWidth:MAINSCREEN_WIDTH-60];
    return 22+stringHeight;
}

- (void)richElementsInCellWithModel:(NSInteger)second{
    _second = second;
    
    [self setAccLabWithSecond:_second];
}
+ (NSMutableAttributedString *)aliasLabAttributedStringWithData:(NSString*)string{
    return  [NSString attributedStringWithString:[NSString stringWithFormat:@"\n%@",@"WIQ"] stringColor:HEXCOLOR(0x000000) stringFont:kFontSize(13) subString:[NSString stringWithFormat:@"好的了%@%@，🐟想 >>",@"",@"AB"] subStringColor:HEXCOLOR(0x777777) subStringFont:kFontSize(13) numInSubColor:HEXCOLOR(0x000000) numInSubFont:kFontSize(13)];
}

+ (NSMutableAttributedString *)accLabAttributedStringWithSecond:(NSInteger)second{
   return  [NSString attributedStringWithString:[NSString stringWithFormat:@"%@倒计时：",@"2018-12-14 11:11:01"] stringColor:HEXCOLOR(0x9b9b9b) stringFont:kFontSize(13) subString:second > 0?[NSString transToHMSSeparatedByColonFormatSecond:second]:@"00:00:00" subStringColor:HEXCOLOR(0xeb831d) subStringFont:kFontSize(13)];
}

+ (NSMutableAttributedString *)mergeAttributedStringWithSecond:(NSInteger)second{
    NSMutableAttributedString *attributedStr= [HomeOrderCell accLabAttributedStringWithSecond:second];
    NSMutableAttributedString *subAttributedStr= [HomeOrderCell aliasLabAttributedStringWithData:nil];
    [attributedStr appendAttributedString:subAttributedStr];
    return attributedStr;
}

- (void)setAccLabWithSecond:(NSInteger)second{
    _accLab.attributedText = [HomeOrderCell mergeAttributedStringWithSecond:second];
}

- (void)timerRun:(NSTimer *)timer{
    [self setAccLabWithSecond:_second];
    if (_second > 0)_second -= 1;
}

//重写父类方法，保证定时器被销毁
- (void)removeFromSuperview {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [super removeFromSuperview];
}

- (void)dealloc {
    
}

@end
