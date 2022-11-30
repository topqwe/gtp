//
//  CalendaDaysCell.m
//  CalendarDemo
//
//  Created by shuai pan on 2017/1/20.
//  Copyright © 2017年 BSL. All rights reserved.
//

#import "CalendaDaysCell.h"
#import "CalendarModel.h"

@interface CalendaDaysCell(){
    
}
@property (nonatomic ,strong)UIView *signView;
@property (nonatomic ,strong)UILabel *inter_Calendar;
@property (nonatomic ,strong)UILabel *china_Calendar;

@property (nonatomic ,assign)BOOL signDay;

@end
@implementation CalendaDaysCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.showChinaCalendar = NO;
        [self bsl_controls];
        
    }
    return self;
}
//标记当天
- (void)signCurrentDay:(DayModel *)dayModel{
    self.signDay = NO;
    if (dayModel.isNowDay) {
        self.signDay = YES;
    }
}
- (void)setDayModel:(DayModel *)dayModel{
    _dayModel = dayModel;
    if (!_dayModel) return;
    self.inter_Calendar.text = [NSString stringWithFormat:@"%ld",_dayModel.day];
    self.china_Calendar.text = [self chinaCalendarWithMonth:_dayModel]? :@"";
    if (![NSString isEmpty:self.china_Calendar.text]&&
        ![self.china_Calendar.text isEqualToString:@"-0\n+0"]) {
        self.showChinaCalendar = YES;
    }
    [self setLayout];
    
    if (_dayModel.isInMonth) {
        //是本月的日期
        self.userInteractionEnabled = YES;
        self.inter_Calendar.textColor = [UIColor blackColor];
        self.inter_Calendar.backgroundColor = [UIColor clearColor];
        self.china_Calendar.textColor = [UIColor blackColor];
        self.china_Calendar.backgroundColor = [UIColor clearColor];
    }
    else{
        //不是本月的日期
        self.userInteractionEnabled = NO;
        self.inter_Calendar.textColor = [UIColor lightGrayColor];
        self.inter_Calendar.backgroundColor = [UIColor clearColor];
        self.china_Calendar.textColor = [UIColor lightGrayColor];
        self.china_Calendar.backgroundColor = [UIColor clearColor];
    }
    
}


- (void)bsl_controls{
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
  
    [self addSubview:self.signView];

    [self addSubview:self.china_Calendar];
    [self addSubview:self.inter_Calendar];
    
}
- (void)setLayout{
//    [super layoutSubviews];
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);

    self.signView.center = CGPointMake(w/2, h/2);
    CGFloat signView_w = w > h ? h:w;
    self.signView.bounds = CGRectMake(0, 0, signView_w*0.9, signView_w*0.9);
    self.signView.layer.cornerRadius = CGRectGetWidth(self.signView.bounds)/2;

    if (!self.showChinaCalendar) {
        self.china_Calendar.frame = CGRectZero;
        self.inter_Calendar.frame = CGRectMake(0, 0, w, h);
    }else{
        self.inter_Calendar.frame = CGRectMake(0, 3, w, 14);
        self.china_Calendar.frame = CGRectMake(0, CGRectGetMaxY(self.inter_Calendar.frame), w, 30);
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
}

//标记当天
- (void)setSignDay:(BOOL)signDay{
    _signDay = signDay;
    self.signView.backgroundColor = [UIColor clearColor];

    if (_signDay) {
        self.inter_Calendar.textColor = [UIColor whiteColor];
        self.china_Calendar.textColor = [UIColor whiteColor];
        self.signView.backgroundColor = YBGeneralColor.themeColor;
    }

}


#pragma mark ChineseCalendar

- (NSString *)chinaCalendarWithMonth:(DayModel*)model{
    NSString *dateString = [NSString stringWithFormat:@"%ld-%ld-%ld",model.year,model.month,model.day];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //dateFormatter.dateFormat = @"YYYY年MM月dd日";
    [dateFormatter setDateFormat:@"YY-MM-dd"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    
    if (!date) return nil;
    NSString* ymdPointString = [NSString dataStringWithFormatString:[NSString ymdSeparatedByPointFormatString] setDate:date];
    
    NSArray* tags = [UserInfoManager GetNSUserDefaults].tagArrs;
        
    //    if(!_sections||_sections.count==0)return;
    NSArray* dayTotalarray = [[AccountingModel new]getAccountingAssembledData:tags selectedType:AccountingSelectedTypeDayBalanceTotalStated withDistinction:AccountingDistinctionTypeDayAllStated withDistinctionTime:ymdPointString withDistinctionBalanceSource:@""];
    NSString* dateS = dayTotalarray[0][kDate];
    NSString* dayBalance = @"";
    if (dateS.hash == ymdPointString.hash) {
        dayBalance = [NSString stringWithFormat:@"-%@\n+%@",dayTotalarray[0][kTit],dayTotalarray[0][kSubTit]];
    }
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    if ([dayTotalarray[0][kTit]floatValue]> [dayTotalarray[0][kSubTit]floatValue]) {
        self.contentView.backgroundColor = HEXCOLOR(0xe22323);
    }else if ([dayTotalarray[0][kTit]floatValue]< [dayTotalarray[0][kSubTit]floatValue]){
        self.contentView.backgroundColor = HEXCOLOR(0x21c244);
    }else if ([dayTotalarray[0][kTit]floatValue] == [dayTotalarray[0][kSubTit]floatValue]&&[dayTotalarray[0][kTit]floatValue]>0){
        self.contentView.backgroundColor = HEXCOLOR(0xf59b22);
    }
    
    
    return dayBalance;
    
//    NSArray *chineseMonths=[NSArray arrayWithObjects:
//                            @"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",
//                            @"九月", @"十月", @"冬月", @"腊月", nil];
//    NSArray *chineseDays=[NSArray arrayWithObjects:
//                          @"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",
//                          @"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"廿十",
//                          @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十",  nil];
//    
//    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
//    
//    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
//    
//    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:date];
//    
//    //    NSString *y_str = [chineseYears objectAtIndex:localeComp.year-1];
//    NSString *m_str = [chineseMonths objectAtIndex:localeComp.month-1];
//    NSString *d_str = [chineseDays objectAtIndex:localeComp.day-1];
//    
//    // The default return date (2, 5,...), when today is the first show in that month (February, may...).
//    NSString *chineseCal_str = d_str;
//    if([chineseMonths containsObject:m_str] && [d_str isEqualToString:@"初一"]) {
//        chineseCal_str = m_str;
//        if ([m_str isEqualToString:@"正月"] && [d_str isEqualToString:@"初一"]) {
//            chineseCal_str = @"春节";
//        }else{
//            chineseCal_str = @"初一";
//        }
//    }
//    else if ([m_str isEqualToString:@"正月"] && [d_str isEqualToString:@"十五"]) {
//        chineseCal_str = @"🐶宵节";
//    }
//    else if ([m_str isEqualToString:@"五月"] && [d_str isEqualToString:@"初五"]) {
//        chineseCal_str = @"端午节";
//    }
//    else if ([m_str isEqualToString:@"八月"] && [d_str isEqualToString:@"十五"]) {
//        chineseCal_str = @"中秋节";
//    }
//    else if ([m_str isEqualToString:@"九月"] && [d_str isEqualToString:@"初九"]) {
//        chineseCal_str = @"重阳节";
//    }
//    else if ([m_str isEqualToString:@"腊月"] && [d_str isEqualToString:@"初八"]) {
//        chineseCal_str = @"腊八节";
//    }
//    else if ([m_str isEqualToString:@"腊月"] && [d_str isEqualToString:@"廿三"]) {
//        chineseCal_str = @"小年";
//    }
//    else if ([m_str isEqualToString:@"腊月"] && [d_str isEqualToString:@"三十"]) {
//        chineseCal_str = @"除夕";
//    }
//    // Extensions: display the holidays
//    NSDictionary *Holidays = @{@"01-01":@"🐶旦",
//                               @"02-14":@"情人节",
//                               @"03-08":@"妇女节",
//                               @"03-12":@"植树节",
//                               @"05-01":@"劳动节",
//                               @"05-04":@"青年节",
//                               @"06-01":@"儿童节",
//                               @"07-01":@"建党节",
//                               @"08-01":@"建军节",
//                               @"09-10":@"教师节",
//                               @"10-01":@"国庆节",
//                               @"12-24":@"平安夜",
//                               @"12-25":@"圣诞节"};
//    
//    NSDateFormatter *dateFormatt= [[NSDateFormatter alloc] init];
//    dateFormatt.dateFormat = @"YY-MM-dd";
//    NSString *nowStr = [dateFormatt stringFromDate:date];
//    
//    NSArray *array = [Holidays allKeys];
//    if([array containsObject:nowStr]) {
//        chineseCal_str = [Holidays objectForKey:nowStr];
//    }
//    return chineseCal_str;
}



- (UILabel*)inter_Calendar{
    if (!_inter_Calendar) {
        _inter_Calendar = [[UILabel alloc]initWithFrame:CGRectZero];
        _inter_Calendar.textColor = [UIColor blackColor];
        _inter_Calendar.textAlignment = NSTextAlignmentCenter;
        _inter_Calendar.font = [UIFont systemFontOfSize:14];
    }
    return _inter_Calendar;
}


- (UILabel *)china_Calendar{
    if (!_china_Calendar) {
        _china_Calendar = [[UILabel alloc]initWithFrame:CGRectZero];
        _china_Calendar.numberOfLines = 0;
        _china_Calendar.textColor = [UIColor blackColor];
        _china_Calendar.textAlignment = NSTextAlignmentCenter;
        _china_Calendar.font = [UIFont systemFontOfSize:9];
    }
    return _china_Calendar;
}

- (UIView *)signView{
    if (!_signView) {
        _signView = [[UIView alloc]initWithFrame:CGRectZero];
        _signView.backgroundColor = [UIColor clearColor];
        _signView.clipsToBounds  =YES;
    }
    return _signView;
}

@end
