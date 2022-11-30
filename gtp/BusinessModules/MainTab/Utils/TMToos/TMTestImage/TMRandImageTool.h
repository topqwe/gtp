//
//  TMRandImageTool.h
//  WeddingTime
//
//  Created by Mac on 2018/6/15.
//  Copyright © 2018年 stoneobs.qq.com. All rights reserved.
//

#import <Foundation/Foundation.h>
/************随机图片管理类******************/
@interface TMRandImageTool : NSObject
//测试图片加载用这个方法，减少内存
+ (UIImage*)bundleImageWithImageName:(NSString*)imageName;
#pragma mark --商品banner
+ (NSArray*)allGoodBannerArray;/**< //所有商品banner */
+ (NSArray*)goodBannerWithCount:(NSInteger)count;/**< 商品banner 随机count张 */
+ (NSArray*)randGoodBanner;/**< 随机商品banner */
+ (NSString*)randOneGoodBanner;/**< 随机一张商品banner !*/

#pragma mark --风景banner
+ (NSArray*)allSceneBannerArray;/**< //所有风景banner */
+ (NSArray*)sceneBannerWithCount:(NSInteger)count;/**< 风景banner 随机count张 */
+ (NSArray*)sceneGoodBanner;/**< 随机scene banner */
+ (NSString*)randOneSceneBanner;/**< 随机一张风景banner !*/

+ (NSArray*)randGoodAndSceneBannerWithCount:(NSInteger)count;/**< 随机商品和风景 count banner */
+ (NSString*)randOneGoodAndSceneBanner;/**< 随机一张 风景和商品banner图片! */

+ (NSString*)randOneIconImageName;/**< 随机一张头像图片! */
+ (NSArray*)randIconImageNameWithCount:(NSInteger)count;;/**< 随机多少张头像图片! */

+ (NSString*)randNormalImage;/**< 随机一张500 * 375 图片 */
+ (NSArray*)randNormalImageWithCount:(NSInteger)count;/**< 随机多少张500 * 375 图片 */


+ (NSString*)randRoundImage;/**< 随机一张圆形 图片 ！*/

+ (NSArray<UIImage*>*)imageArrayWithRandArray:(NSArray*)randArray;/**< 将随机的图片名字数组 生成 图片对象数组 */


+ (NSString*)randLiveGirlImage;/**< 随机一张直播美女图片 */
+ (NSArray*)randLiveGirlImageWithCount:(NSInteger)count;/**< 随机多少张直播美女 图片 */

@end
