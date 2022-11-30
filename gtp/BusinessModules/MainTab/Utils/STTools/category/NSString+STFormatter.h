//
//  NSString+Format.h
//  STTools
//
//  Created by stoneobs on 16/10/8.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  这是字符串格式判断，比如需要判断是否中文，是否纯数字，正则表达式，动态算高度，等

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (STFormatter)

//时间字符串 转换
- (NSString*)st_stringByFormatString:(NSString *)formatStr;
- (NSString*)st_timeWithString:(NSString*)formatStr;
//字典 JSON 互转
+ (NSString*)st_dictionaryToJson:(NSDictionary *)dic;
+ (NSDictionary*)st_dictionaryWithJsonString:(NSString *)jsonString;
//随机生成中文字符
+ (NSMutableString*)st_randomCreatChinese:(NSInteger)count;
/**
 *  驼峰转下划线（loveYou -> love_you）
 */
- (NSString *)st_underlineFromCamel;
/**
 *  下划线转驼峰（love_you -> loveYou）
 */
- (NSString *)st_camelFromUnderline;
/**
 * 首字母变大写
 */
- (NSString *)st_firstCharUpper;
/**
 * 首字母变小写
 */
- (NSString *)st_firstCharLower;
/**
 *  返回字符串高度，规定宽，规定字体大小
 */
- (CGFloat)st_heigthWithwidth:(CGFloat)width font:(CGFloat)font;
- (CGFloat)st_widthWithheight:(CGFloat)height font:(CGFloat)font;
//lable 自动更新高度和宽度
+ (void)lableAutoAdjustWitdhWithLabel:(UILabel*)lable;
+ (void)lableAutoAdjustheightWithLabel:(UILabel*)lable;
/**
 转拼音
 */
- (NSString *)st_transformToChinese;
//过滤emoji
- (NSString *)st_disable_emojiSrting;
//183****1887
- (NSString*)st_safetyPhone;
//st***@icloud.com
- (NSString*)st_safetyEmail;
//安全账号 中间*号代替 3****f
- (NSString*)st_saveString;
// 判断是否为电话号码
- (BOOL)st_isValidatePhoneNumber;
//判断3～20位数字
- (BOOL)st_isValidateTelephoneNumber;
// 判断是否为邮箱
- (BOOL)st_isValidateEmail;
// 判断是否为url
- (BOOL)st_isValidateUrl;
//是否 8-16 数字和字符串密码
- (BOOL)st_isValidatePwd;
//空字符串
- (BOOL)st_isBlank;
//是否中文
- (BOOL)st_isChinese;
//是否合法身份证
- (BOOL)st_verifyIDCardNumber;
//是否纯数字
- (BOOL)st_isPureNumandCharacters;
//是否含特殊字符
- (BOOL)st_isIncludeSpecialCharacters;
/**
 获取邮件用户的字符截取规则
 1.若只包含汉字，显示最后一个字；只包含字母，显示第一个字母（不论大小写，均显示大写）
 2.混合组成的话，有汉字显示汉字最后一个，没有汉字显示第一个英文字母（不论大小写，均显示大写）
 3.只包含数字或特殊字符，则显示默认头像（默认头像UI补充）
 */
- (NSString *)st_getMailNameDefaultChar;
/**
 将字符串装换成富文本格式

 @param keyword 关键字
 @param optins 配置属性
 @return 富文本字符串对象
 */
- (NSAttributedString*)st_convertAttributeStringWithKeyWord:(NSString *)keyword
                                               attributes:(NSDictionary *)optins;
/**
 将字符串装换成富文本格式

 @param keywords 关键字数组
 @param options 配置属性数组
 @return 富文本字符串对象
 */
- (NSAttributedString *)st_convertAttributeStringWithKeyWords:(NSArray *)keywords
                                                attributes:(NSArray<NSDictionary *> *)options;
/**
 获取首字母

 @return return value description
 */
- (NSString *)st_getPinYinLetter;

//合适的imageURl
- (NSString*)sv_safeImageUrl;
@end
