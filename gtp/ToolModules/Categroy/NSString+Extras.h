//
//  NSString+YBCodec.h
//  YBArchitectureDemo
//
//  Created by 杨波 on 2018/11/20.
//  Copyright © 2018 杨波. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extras)
- (CGSize)singleLineSizeWithAttributeText:(UIFont *)font ;
//固定宽度计算多行文本高度，支持包含emoji表情符的计算。开头空格、自定义插入的文本图片不纳入计算范围、
- (CGSize)multiLineSizeWithAttributeText:(CGFloat)width font:(UIFont *)font ;

//计算单行文本宽度和高度，返回值与UIFont.lineHeight一致，支持开头空格计算。包含emoji表情符的文本行高返回值有较大偏差。
- (CGSize)singleLineSizeWithText:(UIFont *)font;
- (NSString *)md5;
- (NSURL *)urlScheme:(NSString *)scheme;
+ (NSString *)formatCount:(NSInteger)count;
+(NSDictionary *)readJson2DicWithFileName:(NSString *)fileName;

+ (NSString *)currentTime;

+ (NSString*)arrayToJson:(NSArray *)arrJson;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (NSString*) replaceUnicode:(NSString*)TransformUnicodeString;
//传NSData 得16进制字符串
+ (NSString *)convertDataToHexStr:(NSData *)data;
+  (NSString *)stringFromHexString:(NSString *)hexString;
- (NSString *)newStringInBase64FromString;
/**
 *  转换为Base64编码
 */
 - (NSString *)base64EncodedString;

 /**
 *  将Base64编码还原
 */
 - (NSString *)base64DecodedString;
//将十六进制的字符串转换成NSString则可使用如下方式:
+ (NSString *)convertHexStrToString:(NSString *)str;

+ (NSInteger)compareYMDHMSDate:(NSString*)aYMDHMSDate withDate:(NSString*)bYMDHMSDate;
+ (NSString *)getCurrentTimeYMDHMS;
+(NSString*)getCurrentTimestamp;
+ (NSString *)currentDataStringWithFormatString:(NSString *)format;
+ (NSString *)getSumStringByArray:(NSArray *)array;
+ (NSNumber *)getNormalSumNumberByArray:(NSArray *)array;
+ (NSNumber *)getPropertTotalNumberByArray:(NSArray *)array;
+ (NSNumber *)getPropertAmountNumberByArray:(NSArray *)array;
- (NSString *)yb_encodingUTF8;

- (NSString *)yb_MD5;

+(BOOL)isChinese:(NSString*)str;

- (BOOL)match:(NSString *)express;

+ (BOOL)isPureInt:(NSString *)string;
+ (BOOL)isEmpty:(NSString *)text;
+ (id)isValueNSStringWith:(NSString *)str;
+ (BOOL)getDataSuccessed:(NSDictionary *)dic;
+(BOOL)getLNDataSuccessed:(NSDictionary *)dic;

+ (NSString *)transToHMSSeparatedByUnitFormatSecond:(NSInteger)second;
+ (NSString *)transToHMSSeparatedByColonFormatSecond:(NSInteger)second;


+ (NSString *)currentDateComparePastDate:(NSDate *)pDate;
+ (NSString *)currentDateCompareFutureDate:(NSDate *)fDate;

+ (NSString *)mdSeparatedByPointFormatString;
+ (NSString *)mdSeparatedByHyphenFormatString;
+ (NSString *)mdSeparatedBySlashFormatString;
+ (NSString *)mdSeparatedByUnitFormatString;

+ (NSString *)ymSeparatedByPointFormatString;
+ (NSString *)ymSeparatedByHyphenFormatString;
+ (NSString *)ymSeparatedBySlashFormatString;
+ (NSString *)ymSeparatedByUnitFormatString;

+ (NSString *)ymdSeparatedByPointFormatString;
+ (NSString *)ymdSeparatedByHyphenFormatString;
+ (NSString *)ymdSeparatedBySlashFormatString;
+ (NSString *)ymdSeparatedByUnitFormatString;

+ (NSString *)dateStrWithString:(NSString *)string formatString:(NSString *)formatString;

+ (NSString *)dataStringWithFormatString:(NSString *)formatString setDate:(NSDate *)setDate;

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont subString:(NSString *)subString subStringColor:(UIColor*)subStringcolor subStringFont:(UIFont*)subStringFont numInSubColor:(UIColor*)numInSubColor numInSubFont:(UIFont*)numInSubFont;
+ (NSMutableAttributedString*)attributedShadowWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont;
//中划线
+ (NSMutableAttributedString *)attributedStringWithStrikethroughStyle:(NSMutableAttributedString *)origalAttribtStr;
//下划线
+ (NSMutableAttributedString *)attributedStringWithUnderlineStyle:(NSMutableAttributedString *)origalAttribtStr;
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont attachImage:(UIImage*)image subString:(NSString *)subString subStringColor:(UIColor*)subStringcolor subStringFont:(UIFont*)subStringFont paragraphStyle:(NSTextAlignment)alignment;

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont subString:(NSString *)subString subStringColor:(UIColor*)subStringcolor subStringFont:(UIFont*)subStringFont paragraphStyle:(NSTextAlignment)alignment;

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor stringFont:(UIFont*)sFont subString:(NSString *)subString subStringColor:(UIColor*)subStringcolor subStringFont:(UIFont*)subStringFont;

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor image:(UIImage *)image;

+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)string stringColor:(UIColor*)scolor image:(UIImage *)image isImgPositionOnlyLeft:(BOOL)isOnlyLeft;

+ (CGFloat)getAttributeContentHeightWithAttributeString:(NSAttributedString*)atributedString withFontSize:(float)fontSize boundingRectWithWidth:(CGFloat)width;
+ (CGFloat)getContentHeightWithParagraphStyleLineSpacing:(CGFloat)lineSpacing fontWithString:(NSString*)fontWithString fontOfSize:(CGFloat)fontOfSize boundingRectWithWidth:(CGFloat)width;

+(CGFloat)getTextWidth:(NSString *)string withFontSize:(UIFont *)font withHeight:(CGFloat)height;

+(CGFloat)calculateTextWidth:(NSString *)string withFontSize:(float)fontSize withWidth:(float)width;
+(CGFloat)calculateAttributeTextWidth:(NSAttributedString *)atributedString withFontSize:(float)fontSize withWidth:(float)width;
+(NSString *)convertToJsonData:(NSDictionary *)dict;
/**
 *  返回字符串所占用的尺寸
 *
 *  @param font    字体
 *  @param maxSize 最大尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

@end

NS_ASSUME_NONNULL_END
