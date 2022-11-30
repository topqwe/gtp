//
//  NSString+YBCodec.m
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/20.
//  Copyright © 2018 杨波. All rights reserved.
//

#import "NSString+Extras.h"
#import <CommonCrypto/CommonDigest.h>
#import <iconv.h>
@implementation NSString (Extras)
//计算单行文本行高、支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围
- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font {
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineSpacingAdjustment, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(DBL_MAX, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    return size;
}

//固定宽度计算多行文本高度，支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围、
- (CGSize)multiLineSizeWithAttributeText:(CGFloat)width font:(UIFont *)font {
    CTFontRef cfFont = CTFontCreateWithName((CFStringRef) font.fontName, font.pointSize, NULL);
    CGFloat leading = font.lineHeight - font.ascender + font.descender;
    CTParagraphStyleSetting paragraphSettings[1] = { kCTParagraphStyleSpecifierLineBreakMode, sizeof (CGFloat), &leading };
    
    CTParagraphStyleRef  paragraphStyle = CTParagraphStyleCreate(paragraphSettings, 1);
    CFRange textRange = CFRangeMake(0, self.length);
    
    //  Create an empty mutable string big enough to hold our test
    CFMutableAttributedStringRef string = CFAttributedStringCreateMutable(kCFAllocatorDefault, self.length);
    
    //  Inject our text into it
    CFAttributedStringReplaceString(string, CFRangeMake(0, 0), (CFStringRef) self);
    
    //  Apply our font and line spacing attributes over the span
    CFAttributedStringSetAttribute(string, textRange, kCTFontAttributeName, cfFont);
    CFAttributedStringSetAttribute(string, textRange, kCTParagraphStyleAttributeName, paragraphStyle);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(string);
    
    CGSize size = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSizeMake(width, DBL_MAX), nil);
    
    CFRelease(paragraphStyle);
    CFRelease(string);
    CFRelease(cfFont);
    CFRelease(framesetter);
    
    return size;
}

//计算单行文本宽度和高度，返回值与UIFont.lineHeight一致，支持开头空格计算。包含emoji表情符的文本行高返回值有较大偏差。
- (CGSize)singleLineSizeWithText:(UIFont *)font{
    return [self sizeWithAttributes:@{NSFontAttributeName:font}];
}

- (NSString *) md5 {
    const char *str = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( str, (CC_LONG)strlen(str), digest );
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return output;
}

- (NSURL *)urlScheme:(NSString *)scheme {
    NSURLComponents *components = [[NSURLComponents alloc] initWithURL:[NSURL URLWithString:self] resolvingAgainstBaseURL:NO];
    components.scheme = scheme;
    return [components URL];
}

+ (NSString *)formatCount:(NSInteger)count {
    if(count < 10000) {
        return [NSString stringWithFormat:@"%ld",(long)count];
    }else {
        return [NSString stringWithFormat:@"%.1fw",count/10000.0f];
    }
}
+(NSDictionary *)readJson2DicWithFileName:(NSString *)fileName {
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    return dic;
}

+ (NSString *)currentTime {
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval time = [date timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", time * 1000];
    return timeString;
}
//数组转json格式字符串：
+ (NSString*)arrayToJson:(NSArray *)arrJson
{
    if (![arrJson isKindOfClass:[NSArray class]] || ![NSJSONSerialization isValidJSONObject:arrJson]) {

            return nil;

        }
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:arrJson options:0 error:nil];

        NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

        return strJson;
}
//字典转json格式字符串：
+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
//json格式字符串转字典：

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
        
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *err;
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        
        return nil;
        
    }
    
    return dic;
    
}
//unicode转汉字
//例如服务器给我们的原始字符串\\u6b63\\u5728\\u52a0\\u70ed\\uff0c\\u5f53
+ (NSString*) replaceUnicode:(NSString*)TransformUnicodeString{
NSString*tepStr1 = [TransformUnicodeString stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
NSString*tepStr2 = [tepStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
NSString*tepStr3 = [[@"\""  stringByAppendingString:tepStr2]stringByAppendingString:@"\""];
NSData*tepData = [tepStr3  dataUsingEncoding:NSUTF8StringEncoding];
NSString*axiba = [NSPropertyListSerialization    propertyListWithData:tepData options:NSPropertyListMutableContainers format:NULL error:NULL];
return  [axiba    stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (NSString *)newStringInBase64FromString
{
 NSData *theData = [NSData dataWithBytes:[self UTF8String] length:[self length]];

 return [theData newStringInBase64FromData];
}
- (NSString *)base64EncodedString;
{
    NSData *data = [self dataUsingEncoding: NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

- (NSString *)base64DecodedString
{
    NSData *data = [[NSData alloc]initWithBase64EncodedString:self options:NSUTF8StringEncoding];
    return [[NSString alloc]initWithData:data encoding: NSUTF8StringEncoding];
}
//传NSData 得16进制字符串
+ (NSString *)convertDataToHexStr:(NSData *)data
{
    if (!data || [data length] == 0) {
        return @"";
    }
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[data length]];
    
    [data enumerateByteRangesUsingBlock:^(const void *bytes, NSRange byteRange, BOOL *stop) {
        unsigned char *dataBytes = (unsigned char*)bytes;
        for (NSInteger i = 0; i < byteRange.length; i++) {
            NSString *hexStr = [NSString stringWithFormat:@"%x", (dataBytes[i]) & 0xff];
            if ([hexStr length] == 2) {
                [string appendString:hexStr];
            } else {
                [string appendFormat:@"0%@", hexStr];
            }
        }
    }];
    return string;
}
//将十六进制的字符串转换成NSString则可使用如下方式:
+  (NSString *)stringFromHexString:(NSString *)hexString {
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
    unsigned int anInt;
    NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
    NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
    [scanner scanHexInt:&anInt];
    myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    NSLog(@"字符串%@",unicodeString);
    return unicodeString;
    }
//比较两个日期的大小  日期格式为2017-02-24 08：46：20
+ (NSInteger)compareYMDHMSDate:(NSString*)aYMDHMSDate withDate:(NSString*)bYMDHMSDate
{
    NSInteger aa = 0;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];

    dta = [dateformater dateFromString:aYMDHMSDate];
    dtb = [dateformater dateFromString:bYMDHMSDate];
    NSComparisonResult result = [dta compare:dtb];
        if (result == NSOrderedSame)
    {
    //        相等
        aa= 0;
    }else if (result == NSOrderedAscending)
    {
    //bDate比aDate大
        aa= 1;
    }else if (result == NSOrderedDescending)
    {
    //bDate比aDate小
        aa= -1;
}

return aa;
}
+ (NSString *)getCurrentTimeYMDHMS{
    
    //2017-04-24 08:57:29
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateTime=[formatter stringFromDate:[NSDate date]];
//    dateTime = @"2021-09-15 18:29:17";
//    NSDate *date = [formatter dateFromString:dateTime];
//    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
//    NSString *dateString = [formatter stringFromDate:date];
//    NSLog(@"datastring  = %@",dateString);
    return dateTime;
}
+(NSString*)getCurrentTimestamp{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString*timeString = [NSString stringWithFormat:@"%0.f", a];//转为字符型
    return timeString;
}
+(BOOL)isChinese:(NSString*)str{
    for(int i=0; i< [str length];i++){
            int a = [str characterAtIndex:i];
            if( a > 0x4e00 && a < 0x9fff)
            {
                return YES;
            }
        }
        return NO;
//    for(int i =0; i < str.length; i++){
//        int a =[str characterAtIndex:i];
//        if(a >127) {
//
//            return YES;
//
//        }
//
//
//    }
//    return NO;
}
+ (NSString *)getSumStringByArray:(NSArray *)array
//[string or num]
{
    CGFloat sum = [[array valueForKeyPath:@"@sum.floatValue"] floatValue];
//    CGFloat avg = [[array valueForKeyPath:@"@avg.floatValue"] floatValue];
//    CGFloat max =[[array valueForKeyPath:@"@max.floatValue"] floatValue];
//    CGFloat min =[[array valueForKeyPath:@"@min.floatValue"] floatValue];
//    NSLog(@"%fn%fn%fn%f",sum,avg,max,min);
    return [NSString stringWithFormat:@"%.2f",sum];
}
+ (NSNumber *)getNormalSumNumberByArray:(NSArray *)array
//[string or num]
{
    CGFloat sum = [[array valueForKeyPath:@"@sum.floatValue"] floatValue];
//    CGFloat avg = [[array valueForKeyPath:@"@avg.floatValue"] floatValue];
//    CGFloat max =[[array valueForKeyPath:@"@max.floatValue"] floatValue];
//    CGFloat min =[[array valueForKeyPath:@"@min.floatValue"] floatValue];
//    NSLog(@"%fn%fn%fn%f",sum,avg,max,min);
    return @([[NSString stringWithFormat:@"%.2f",sum] floatValue]);
}

+ (NSNumber *)getPropertTotalNumberByArray:(NSArray *)array
//[string or num]
{
    CGFloat sum = [[array valueForKeyPath:@"@sum.kTotal"] floatValue];
//    CGFloat avg = [[array valueForKeyPath:@"@avg.floatValue"] floatValue];
//    CGFloat max =[[array valueForKeyPath:@"@max.floatValue"] floatValue];
//    CGFloat min =[[array valueForKeyPath:@"@min.floatValue"] floatValue];
//    NSLog(@"%fn%fn%fn%f",sum,avg,max,min);
    return @([[NSString stringWithFormat:@"%.2f",sum] floatValue]);
}

+ (NSNumber *)getPropertAmountNumberByArray:(NSArray *)array
//[string or num]
{
    CGFloat sum = [[array valueForKeyPath:@"@sum.kAmount"] floatValue];
//    CGFloat avg = [[array valueForKeyPath:@"@avg.floatValue"] floatValue];
//    CGFloat max =[[array valueForKeyPath:@"@max.floatValue"] floatValue];
//    CGFloat min =[[array valueForKeyPath:@"@min.floatValue"] floatValue];
//    NSLog(@"%fn%fn%fn%f",sum,avg,max,min);
    return @([[NSString stringWithFormat:@"%.2f",sum] floatValue]);
}

- (NSString *)yb_encodingUTF8 {
    NSString *result = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self, NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
    return result;
}

- (NSString *)yb_MD5 {
    const char* str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for(int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02X",result[i]];
    }
    
    NSString *finalStr = [ret lowercaseString];
    return finalStr;
}

- (BOOL)match:(NSString *)express {
    return YES;
}

+ (BOOL)isPureInt:(NSString *)string {
    NSScanner *scan = [NSScanner scannerWithString:string];
    int value;
    return [scan scanInt:&value] && [scan isAtEnd];
}
+(BOOL)isEmpty:(NSString *)text
{
    if ([[NSString isValueNSStringWith:text] isEqualToString:@""] ||
        [NSString isValueNSStringWith:text] == nil)
    {
        return true;
    }
    return false;
}

+(id)isValueNSStringWith:(NSString *)str{
    NSString *resultStr = nil;
    str =[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([str isEqual:[NSNull null]]
        ||[NSString stringWithFormat:@"%@",str]==nil
        ||[NSString stringWithFormat:@"%@",str].length==0
        ||[[NSString stringWithFormat:@"%@",str] isEqual:@"(null)"]
        ||[[NSString stringWithFormat:@"%@",str] isEqual:@"null"]
        ||[str stringByReplacingOccurrencesOfString:@" " withString:@""].length == 0
        ) {
        resultStr = @"";
    }else{
        resultStr = [NSString stringWithFormat:@"%@",str];
    }
    return resultStr;
}
+(BOOL)getLNDataSuccessed:(NSDictionary *)dic
{
    if ([NSObject isNSDictionaryClass:dic]) {
        int successed = [dic intForKey:@"code"];
        if (successed == 1) {
            return YES;
        } else {
            return NO;
        }
    } else {
        //        (@"后台返回数据有错误：%s",dic.description.UTF8String);
        return NO;
    }
}
+(BOOL)getDataSuccessed:(NSDictionary *)dic
{
    if ([NSObject isNSDictionaryClass:dic]) {
        int successed = [dic intForKey:@"state"];
        if (successed == 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
//        (@"后台返回数据有错误：%s",dic.description.UTF8String);
        return NO;
    }
}
+ (NSString *)transToHMSSeparatedByUnitFormatSecond:(NSInteger)second{
    NSString *time;
    if (second < 60) {
        time = [NSString stringWithFormat:@"%02ld秒",(long)second];
    }
    else {
        if (second < 3600) {
            time = [NSString stringWithFormat:@"%02ld分%02ld秒",second/60,second%60];
        }
        else {
            time = [NSString stringWithFormat:@"%02ld时%02ld分%02ld秒",second/3600,(second%3600)/60,(second%3600)%60];
        }
    }
    return time;
}

+ (NSString *)transToHMSSeparatedByColonFormatSecond:(NSInteger)second{
    NSString *time;
    if (second < 60) {
        time = [NSString stringWithFormat:@"00:00:%02ld",(long)second];
    }
    else {
        if (second < 3600) {
            time = [NSString stringWithFormat:@"00:%02ld:%02ld",second/60,second%60];
        }
        else {
            time = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",second/3600,(second%3600)/60,(second%3600)%60];
        }
    }
    return time;
}

+ (NSString *)currentDateComparePastDate:(NSDate *)pDate{
    //NSTimeInterval
    NSInteger second = (NSInteger)[[NSDate date] timeIntervalSinceDate:pDate];
    
    NSString *time = [NSString transToHMSSeparatedByUnitFormatSecond:second];
    return time;
}

+ (NSString *)currentDateCompareFutureDate:(NSDate *)fDate{
    //NSTimeInterval
    NSInteger second = (NSInteger)[fDate timeIntervalSinceDate:[NSDate date]];
    
    NSString *time = [NSString transToHMSSeparatedByUnitFormatSecond:second];
    return time;
}


+ (NSString *)mdSeparatedByPointFormatString{
    return @"MM.dd";
}

+ (NSString *)mdSeparatedByHyphenFormatString{
    return @"MM-dd";
}

+ (NSString *)mdSeparatedBySlashFormatString{
     return @"MM/dd";
}

+ (NSString *)mdSeparatedByUnitFormatString{
    return @"MM月dd日";
}

+ (NSString *)ymSeparatedByPointFormatString{
    return @"yyyy.MM";
}

+ (NSString *)ymSeparatedByHyphenFormatString{
    return @"yyyy-MM";
}

+ (NSString *)ymSeparatedBySlashFormatString{
     return @"yyyy/MM";
}

+ (NSString *)ymSeparatedByUnitFormatString{
    return @"yyyy年MM月";
}

+ (NSString *)ymdSeparatedByPointFormatString{
    return @"yyyy.MM.dd";
}

+ (NSString *)ymdSeparatedByHyphenFormatString{
    return @"yyyy-MM-dd";
}

+ (NSString *)ymdSeparatedBySlashFormatString{
     return @"yyyy/MM/dd";
}

+ (NSString *)ymdSeparatedByUnitFormatString{
    return @"yyyy年MM月dd日";
}

+ (NSString *)currentDataStringWithFormatString:(NSString *)formatString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    
    NSString *retStr = [formatter stringFromDate:[NSDate date]];
    
    return retStr;
}

+ (NSString *)dataStringWithFormatString:(NSString *)formatString setDate:(NSDate *)setDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:formatString];
    
    NSString *retStr = [formatter stringFromDate:setDate];
    
    return retStr;
}

+ (NSString *)dateStrWithString:(NSString *)string formatString:(NSString *)formatString{
//    NSString *string0 = @"2016-7-16 ";
//
//    // 日期格式化类
//
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//
//    // 设置日期格式 为了转换成功
//
//    format.dateFormat = @"yyyy-MM-dd";
//
//    // NSString * -> NSDate *
//
//    NSDate *data = [format dateFromString:string0];
//
//    NSString *newString = [format stringFromDate:data];
    
//
    NSDateFormatter *format = [[NSDateFormatter alloc] init];

    format.dateFormat = formatString;


    NSDate *data = [format dateFromString:string];

    NSString *newString = [format stringFromDate:data];
    
    return newString;
}


#pragma mark -绘制AttributeString与NSTextAttachment不同大小颜色
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont subString:(NSString *)subString subStringColor:(UIColor*)subStringcolor subStringFont:(UIFont*)subStringFont numInSubColor:(UIColor*)numInSubColor numInSubFont:(UIFont*)numInSubFont
{
   NSMutableDictionary *txtDict = [NSMutableDictionary dictionary];
   NSMutableParagraphStyle *aParagraphStyle = [[NSMutableParagraphStyle alloc] init];
//       aParagraphStyle.lineSpacing = 10;// 字体的行间距
//       aParagraphStyle.firstLineHeadIndent = 30.0f;//首行缩进
   aParagraphStyle.paragraphSpacing = 5;
   aParagraphStyle.alignment = NSTextAlignmentCenter;
   [aParagraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
   [txtDict setObject:aParagraphStyle forKey:NSParagraphStyleAttributeName];
//     [attStr addAttribute:NSBaselineOffsetAttributeName value:@(0.36 * (a - b)) range:NSMakeRange(2, attStr.length - 2)]; //vertical
    
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", string]];
    NSDictionary * attributes = @{ NSFontAttributeName:sFont,NSForegroundColorAttributeName:scolor};
    [txtDict addEntriesFromDictionary:attributes];
    
    [attributedStr setAttributes:txtDict range:NSMakeRange(0,attributedStr.length)];
    
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"([0-9]\\d*\\.?\\d*)" options:0 error:NULL];//)个
    
    NSArray<NSTextCheckingResult *> *ranges = [regular matchesInString:subString options:0 range:NSMakeRange(0, [subString length])];
    

    
    NSDictionary * subAttributes = @{NSFontAttributeName:subStringFont,NSForegroundColorAttributeName:subStringcolor};
    
    [txtDict addEntriesFromDictionary:subAttributes];
    
    NSMutableAttributedString *subAttributedStr = [[NSMutableAttributedString alloc] initWithString:subString attributes:txtDict];
    
    for (int i = 0; i < ranges.count; i++) {
        [subAttributedStr setAttributes:@{NSForegroundColorAttributeName : numInSubColor,NSFontAttributeName:numInSubFont} range:ranges[i].range];
    }
    
    [attributedStr appendAttributedString:subAttributedStr];
    
    
    return attributedStr;
}

+ (NSMutableAttributedString*)attributedShadowWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont{
    NSMutableAttributedString *attributedString=[[NSMutableAttributedString alloc]initWithString:string];

    NSMutableDictionary *txtDict = [NSMutableDictionary dictionary];
    
    NSShadow *shadow = [[NSShadow alloc]init];

    shadow.shadowBlurRadius = 1.0;

    shadow.shadowOffset = CGSizeMake(1, 1);

    shadow.shadowColor = [UIColor lightGrayColor];

    NSDictionary * attributes = @{ NSFontAttributeName:sFont,NSForegroundColorAttributeName:scolor};
    [txtDict addEntriesFromDictionary:attributes];
    
    [attributedString setAttributes:txtDict range:NSMakeRange(0,attributedString.length)];
    
    [attributedString addAttribute:NSShadowAttributeName

    value:shadow

    range:NSMakeRange(0, attributedString.length)];

    return attributedString;
}
//中划线
+ (NSMutableAttributedString *)attributedStringWithStrikethroughStyle:(NSMutableAttributedString *)origalAttribtStr{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
      NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithAttributedString:origalAttribtStr];
    [attribtStr addAttributes:attribtDic range:NSMakeRange(0,origalAttribtStr.length)];
    return attribtStr;
}
//下划线
+ (NSMutableAttributedString *)attributedStringWithUnderlineStyle:(NSMutableAttributedString *)origalAttribtStr{
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
      NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithAttributedString:origalAttribtStr];
    [attribtStr addAttributes:attribtDic range:NSMakeRange(0,origalAttribtStr.length)];
    return attribtStr;
}
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont attachImage:(UIImage*)image subString:(NSString *)subString subStringColor:(UIColor*)subStringcolor subStringFont:(UIFont*)subStringFont paragraphStyle:(NSTextAlignment)alignment
{
    NSMutableDictionary *txtDict = [NSMutableDictionary dictionary];
   NSMutableParagraphStyle *aParagraphStyle = [[NSMutableParagraphStyle alloc] init];
//       aParagraphStyle.lineSpacing = 10;// 字体的行间距
//       aParagraphStyle.firstLineHeadIndent = 30.0f;//首行缩进
   aParagraphStyle.paragraphSpacing = .5;
   aParagraphStyle.alignment = alignment;
   [aParagraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
   [txtDict setObject:aParagraphStyle forKey:NSParagraphStyleAttributeName];
//     [attStr addAttribute:NSBaselineOffsetAttributeName value:@(0.36 * (a - b)) range:NSMakeRange(2, attStr.length - 2)]; //vertical
        
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", string]];
    NSDictionary * attributes = @{ NSFontAttributeName:sFont,NSForegroundColorAttributeName:scolor};
    [txtDict addEntriesFromDictionary:attributes];
    
    [attributedStr setAttributes:txtDict range:NSMakeRange(0,attributedStr.length)];
    
    NSTextAttachment *attachment=[[NSTextAttachment alloc] init];
    attachment.image = image;
    attachment.bounds=CGRectMake(0, -3, image.size.width, image.size.height);
    NSAttributedString *imageStr=[NSAttributedString attributedStringWithAttachment:attachment];
    
    
    [attributedStr appendAttributedString:imageStr];
    
    
    NSMutableAttributedString *subAttributedStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", subString]];
    NSDictionary * subAttributes = @{NSFontAttributeName:subStringFont,NSForegroundColorAttributeName:subStringcolor};
    [txtDict addEntriesFromDictionary:subAttributes];
    
    [subAttributedStr setAttributes:txtDict range:NSMakeRange(0,subAttributedStr.length)];
    
    [attributedStr appendAttributedString:subAttributedStr];
    
    
    return attributedStr;
}
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont subString:(NSString *)subString subStringColor:(UIColor*)subStringcolor subStringFont:(UIFont*)subStringFont paragraphStyle:(NSTextAlignment)alignment
{
    NSMutableDictionary *txtDict = [NSMutableDictionary dictionary];
   NSMutableParagraphStyle *aParagraphStyle = [[NSMutableParagraphStyle alloc] init];
//       aParagraphStyle.lineSpacing = 10;// 字体的行间距
//       aParagraphStyle.firstLineHeadIndent = 30.0f;//首行缩进
   aParagraphStyle.paragraphSpacing = .5;
   aParagraphStyle.alignment = alignment;
   [aParagraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
   [txtDict setObject:aParagraphStyle forKey:NSParagraphStyleAttributeName];
//     [attStr addAttribute:NSBaselineOffsetAttributeName value:@(0.36 * (a - b)) range:NSMakeRange(2, attStr.length - 2)]; //vertical
        
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", string]];
    NSDictionary * attributes = @{ NSFontAttributeName:sFont,NSForegroundColorAttributeName:scolor};
    [txtDict addEntriesFromDictionary:attributes];
    
    [attributedStr setAttributes:txtDict range:NSMakeRange(0,attributedStr.length)];
    
    
    NSMutableAttributedString *subAttributedStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", subString]];
    NSDictionary * subAttributes = @{NSFontAttributeName:subStringFont,NSForegroundColorAttributeName:subStringcolor};
    [txtDict addEntriesFromDictionary:subAttributes];
    
    [subAttributedStr setAttributes:txtDict range:NSMakeRange(0,subAttributedStr.length)];
    
    [attributedStr appendAttributedString:subAttributedStr];
    
    
    return attributedStr;
}

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont subString:(NSString *)subString subStringColor:(UIColor*)subStringcolor subStringFont:(UIFont*)subStringFont
{
    NSMutableDictionary *txtDict = [NSMutableDictionary dictionary];
   NSMutableParagraphStyle *aParagraphStyle = [[NSMutableParagraphStyle alloc] init];
//       aParagraphStyle.lineSpacing = 10;// 字体的行间距
//       aParagraphStyle.firstLineHeadIndent = 30.0f;//首行缩进
   aParagraphStyle.paragraphSpacing = 5;
   aParagraphStyle.alignment = NSTextAlignmentCenter;
   [aParagraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
   [txtDict setObject:aParagraphStyle forKey:NSParagraphStyleAttributeName];
//     [attStr addAttribute:NSBaselineOffsetAttributeName value:@(0.36 * (a - b)) range:NSMakeRange(2, attStr.length - 2)]; //vertical
        
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", string]];
    NSDictionary * attributes = @{ NSFontAttributeName:sFont,NSForegroundColorAttributeName:scolor};
    [txtDict addEntriesFromDictionary:attributes];
    
    [attributedStr setAttributes:txtDict range:NSMakeRange(0,attributedStr.length)];
    
    
    NSMutableAttributedString *subAttributedStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", subString]];
    NSDictionary * subAttributes = @{NSFontAttributeName:subStringFont,NSForegroundColorAttributeName:subStringcolor};
//    [txtDict addEntriesFromDictionary:subAttributes];
    
    [subAttributedStr setAttributes:subAttributes range:NSMakeRange(0,subAttributedStr.length)];
    
    [attributedStr appendAttributedString:subAttributedStr];
    
    
    return attributedStr;
}

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor image:(UIImage *)image
{
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@ ", string]];
    NSDictionary * attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:scolor};
    [attributedStr setAttributes:attributes range:NSMakeRange(0,attributedStr.length)];
    
    
    NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attachment.image=image;
    attachment.bounds=CGRectMake(0,-8 , image.size.width, image.size.height);
    NSAttributedString *imageStr=[NSAttributedString attributedStringWithAttachment:attachment];
    
    
    
    [attributedStr insertAttributedString:imageStr atIndex:0];
    
    
    return attributedStr;
}
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor image:(UIImage *)image isImgPositionOnlyLeft:(BOOL)isOnlyLeft
{
    NSMutableAttributedString *attributedStr=[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  %@  ", string]];
    NSDictionary * attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:scolor};
    [attributedStr setAttributes:attributes range:NSMakeRange(0,attributedStr.length)];
    
    
    NSTextAttachment *attachment=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attachment.image=image;
    attachment.bounds=CGRectMake(0,-8 , image.size.width, image.size.height);
    NSAttributedString *imageStr=[NSAttributedString attributedStringWithAttachment:attachment];
    
    NSTextAttachment *attachment0=[[NSTextAttachment alloc] initWithData:nil ofType:nil];
    UIImage *image0 = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationUpMirrored];
    attachment0.image=isOnlyLeft?image:image0;
    attachment0.bounds=CGRectMake(0,isOnlyLeft?-2:3, image.size.width, image.size.height);
    NSAttributedString *imageStr0=[NSAttributedString attributedStringWithAttachment:attachment0];
    
    [attributedStr insertAttributedString:imageStr0 atIndex:0];
    
    if(!isOnlyLeft)[attributedStr insertAttributedString:imageStr atIndex:attributedStr.length];
    
    return attributedStr;
}
#pragma mark -限宽计算AttributeString与String的高度
+ (CGFloat)getAttributeContentHeightWithAttributeString:(NSAttributedString*)atributedString withFontSize:(float)fontSize boundingRectWithWidth:(CGFloat)width{
    float height = 0;
    CGSize lableSize = CGSizeZero;
//    if(IS_IOS7)
    if ([atributedString respondsToSelector:@selector(boundingRectWithSize:options:context:)]){
        CGSize sizeTemp = [atributedString boundingRectWithSize: CGSizeMake(width, MAXFLOAT)
                                                        options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           
                                                        context: nil].size;
        lableSize = CGSizeMake(ceilf(sizeTemp.width), ceilf(sizeTemp.height));
    }
    height = lableSize.height;
    return height;
}
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}
+ (CGFloat)getContentHeightWithParagraphStyleLineSpacing:(CGFloat)lineSpacing fontWithString:(NSString*)fontWithString fontOfSize:(CGFloat)fontOfSize boundingRectWithWidth:(CGFloat)width {
    float height = 0;
    CGSize lableSize = CGSizeZero;
//    if(IS_IOS7)
    if([fontWithString respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        paragraphStyle.lineSpacing = lineSpacing;
        CGSize sizeTemp = [fontWithString boundingRectWithSize: CGSizeMake(width, MAXFLOAT)
                                                       options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                    attributes: @{NSFontAttributeName:
                                                                      [UIFont systemFontOfSize:fontOfSize],
                                                                  NSParagraphStyleAttributeName:
                                                                      paragraphStyle}
                                                       context: nil].size;
        lableSize = CGSizeMake(ceilf(sizeTemp.width), ceilf(sizeTemp.height));
    }
    
    
    height = lableSize.height;
    return height;
}

#pragma mark -限高计算AttributeString与String的宽度
+(CGFloat)getTextWidth:(NSString *)string withFontSize:(UIFont *)font withHeight:(CGFloat)height
{
    float width = 0;
    CGSize lableSize = CGSizeZero;
    if([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:font forKey: NSFontAttributeName];
        CGSize sizeTemp = [string boundingRectWithSize: CGSizeMake(MAXFLOAT, height)
                                               options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes: stringAttributes
                                               context: nil].size;
        lableSize = CGSizeMake(ceilf(sizeTemp.width), ceilf(sizeTemp.height));
    }
    width = lableSize.width;
    return width;
}

#pragma mark -限宽计算AttributeString与String的宽度
+(CGFloat)calculateTextWidth:(NSString *)string withFontSize:(float)fontSize withWidth:(float)width
{
    float resultWidth = 0;
    CGSize lableSize = CGSizeZero;
    if([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:fontSize] forKey: NSFontAttributeName];
        CGSize sizeTemp = [string boundingRectWithSize: CGSizeMake(width, MAXFLOAT)
                                               options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes: stringAttributes
                                               context: nil].size;
        lableSize = CGSizeMake(ceilf(sizeTemp.width), ceilf(sizeTemp.height));
    }
    
    resultWidth = lableSize.width;
    return resultWidth;
}

+(CGFloat)calculateAttributeTextWidth:(NSAttributedString *)atributedString withFontSize:(float)fontSize withWidth:(float)width
{
    float resultWidth = 0;
    CGSize lableSize = CGSizeZero;
    if([atributedString respondsToSelector:@selector(boundingRectWithSize:options:context:)]) {
        
        //        [atributedString setAttributes:@{ NSFontAttributeName:kFontSize(fontSize)} range:NSMakeRange(0,atributedString.length)];
        
        CGSize sizeTemp = [atributedString boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                        context:nil].size;
        
        
        
        //                           boundingRectWithSize: CGSizeMake(width, MAXFLOAT)
        //                                               options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
        //                                            attributes: stringAttributes
        //                                               context: nil].size;//string
        lableSize = CGSizeMake(ceilf(sizeTemp.width), ceilf(sizeTemp.height));
    }
    
    resultWidth = lableSize.width;
    return resultWidth;
}
// 字典转json字符串方法//==[dic mj_JSONString]
+(NSString *)convertToJsonData:(NSDictionary *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

@end
