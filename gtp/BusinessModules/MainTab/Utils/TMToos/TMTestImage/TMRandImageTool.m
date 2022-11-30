//
//  TMRandImageTool.m
//  WeddingTime
//
//  Created by Mac on 2018/6/15.
//  Copyright © 2018年 stoneobs.qq.com. All rights reserved.
//

#import "TMRandImageTool.h"
#define TMTestImageBundleName @"TMTestImageBundle.bundle/TMTestImage"



#define goodBannerHead @"banner_shop_"  //商品头部
#define sceneBannerHead @"banner_scene_" //风景头部
#define roundHead @"round_"       //圆图片头部
#define itemHead @"item_"        //头像头部
#define normallHead @"normal_"        //一般头像(cell中)头部
#define liveGirlHead @"livegirl_"        //直播美女图片头部


#define goodBannerCount 30  //商品图片数量
#define sceneBannerCount 35 //风景图片数量
#define roundCount 17       //圆图片图片数量
#define itemCount 31        //头像图片数量
#define normallCount  45        //一般cell中图片数量
#define liveGirlCount  60        //美女 图片 总数
@implementation TMRandImageTool
+ (UIImage *)bundleImageWithImageName:(NSString *)imageName{
    NSArray * array = [imageName componentsSeparatedByString:@"_"];
    NSArray * dealArray = [array subarrayWithRange:NSMakeRange(0, array.count - 1)];
    NSString * realImageName = TMTestImageBundleName;
    for (NSString * name in dealArray) {
        realImageName = [NSString stringWithFormat:@"%@/%@",realImageName,name];
    }
    realImageName = [NSString stringWithFormat:@"%@/%@",realImageName,imageName];                                                                          
    UIImage * image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:realImageName] ofType:@"png"]];
    if (!image) {
        image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:realImageName] ofType:@"jpg"]];
    }
    if (!image) {
        return [UIImage new];
    }
    return image;
}
#pragma mark --商品banner
/**< //所有商品banner */
+ (NSArray*)allGoodBannerArray{
    NSMutableArray * allArray = [NSMutableArray new];
    for (NSInteger i = 1; i <= goodBannerCount; i ++) {
        NSString * imageName = [NSString stringWithFormat:@"%@%@",goodBannerHead,@(i)];
        [allArray addObject:imageName];
    }
    return allArray.copy;
}
/**< 商品banner 随机count张 */
+ (NSArray*)goodBannerWithCount:(NSInteger)count{
    NSInteger maxCount = goodBannerCount - 1;
    NSMutableArray * bannerArray = [NSMutableArray new];
    for (NSInteger i = 1 ; i <= count ; i ++) {
        NSInteger randIntger =  arc4random()%maxCount  + 1;
        NSString * imageName = [NSString stringWithFormat:@"%@%@",goodBannerHead,@(randIntger)];
        [bannerArray addObject:imageName];
    }
    return bannerArray.copy;
}
/**< 随机商品banner */
+ (NSArray*)randGoodBanner{
    NSInteger maxCount = goodBannerCount - 1;
    NSInteger randIntger =  arc4random()%maxCount  + 1;
    NSArray * array = [self.class goodBannerWithCount:randIntger];
    return array;
}
/**< 随机一张商品banner */
+ (NSString*)randOneGoodBanner{
    NSInteger maxCount = goodBannerCount - 1;
    NSInteger randIntger =  arc4random()%maxCount  + 1;
    NSString * imageName = [NSString stringWithFormat:@"%@%@",goodBannerHead,@(randIntger)];
    return imageName;
}

#pragma mark --风景banner
/**< //所有风景banner */
+ (NSArray*)allSceneBannerArray{
    NSMutableArray * allArray = [NSMutableArray new];
    for (NSInteger i = 1; i <= sceneBannerCount; i ++) {
        NSString * imageName = [NSString stringWithFormat:@"%@%@",sceneBannerHead,@(i)];
        [allArray addObject:imageName];
    }
    return allArray.copy;
}
/**< 风景banner 随机count张 */
+ (NSArray*)sceneBannerWithCount:(NSInteger)count{
    NSInteger maxCount = sceneBannerCount - 1;
    NSMutableArray * bannerArray = [NSMutableArray new];
    for (NSInteger i = 1 ; i <= count ; i ++) {
        NSInteger randIntger =  arc4random()%maxCount  + 1;
        NSString * imageName = [NSString stringWithFormat:@"%@%@",sceneBannerHead,@(randIntger)];
        [bannerArray addObject:imageName];
    }
    return bannerArray.copy;
}
/**< 随机scene banner */
+ (NSArray*)sceneGoodBanner{
    NSInteger maxCount = sceneBannerCount - 1;
    NSInteger randIntger =  arc4random()%maxCount  + 1;
    NSArray * array = [self.class goodBannerWithCount:randIntger];
    return array;
}
/**< 随机一张风景banner */
+ (NSString*)randOneSceneBanner{
    NSInteger maxCount = sceneBannerCount - 1;
    NSInteger randIntger =  arc4random()%maxCount  + 1;
    NSString * imageName = [NSString stringWithFormat:@"%@%@",sceneBannerHead,@(randIntger)];
    return imageName;
}

#pragma mark --Private Method
/**< 所有风景和商品banner */
+ (NSArray*)allBanner{
    NSMutableArray * allArray = NSMutableArray.new;
    NSArray * goodArray = [self.class allGoodBannerArray];
    NSArray * secenArray = [self.class allSceneBannerArray];
    [allArray addObjectsFromArray:goodArray];
    [allArray addObjectsFromArray:secenArray];
    return allArray.copy;
}
#pragma mark --其他
/**< 随机商品和风景 count banner */
+ (NSArray*)randGoodAndSceneBannerWithCount:(NSInteger)count{
    NSArray * allBanner = [self.class allBanner];
    NSInteger maxCount = allBanner.count - 1;
    NSMutableArray * finshArray = NSMutableArray.new;
    for (NSInteger i = 0; i <count; i ++) {
        NSInteger randIntger =  arc4random()%maxCount;
        [finshArray addObject:allBanner[randIntger]];
    }
    return finshArray.copy;
}

/**< 随机一张 风景和商品banner图片 */
+ (NSString*)randOneGoodAndSceneBanner{
    return [self.class randGoodAndSceneBannerWithCount:1].firstObject;
}
/**< 随机一张头像图片 */
+ (NSString*)randOneIconImageName{
    NSInteger maxCount = itemCount - 1;
    NSInteger randIntger =  arc4random()%maxCount  + 1;
    NSString * imageName = [NSString stringWithFormat:@"%@%@",itemHead,@(randIntger)];
    return imageName;
}
+  (NSArray *)randIconImageNameWithCount:(NSInteger)count{
    NSMutableArray * array = [NSMutableArray new];
    for (NSInteger i = 0; i <count; i ++) {
        NSInteger maxCount = itemCount - 1;
        NSInteger randIntger =  arc4random()%maxCount  + 1;
        NSString * imageName = [NSString stringWithFormat:@"%@%@",itemHead,@(randIntger)];
        [array addObject:imageName];
    }
    return array.copy;
    
}
/**< 随机一张圆形 图片 */
+ (NSString*)randRoundImage{
    NSInteger maxCount = roundCount - 1;
    NSInteger randIntger =  arc4random()%maxCount  + 1;
    NSString * imageName = [NSString stringWithFormat:@"%@%@",roundHead,@(randIntger)];
    return imageName;
}
/**< 随机一张常规 500 * 375图片 */
+ (NSString*)randNormalImage{
    NSInteger maxCount = normallCount - 1;
    NSInteger randIntger =  arc4random()%maxCount  + 1;
    NSString * imageName = [NSString stringWithFormat:@"%@%@",normallHead,@(randIntger)];
    return imageName;
}
+ (NSArray *)randNormalImageWithCount:(NSInteger)count{
    NSMutableArray * array = [NSMutableArray new];
    for (NSInteger i = 0; i <count; i ++) {
        NSInteger maxCount = normallCount - 1;
        NSInteger randIntger =  arc4random()%maxCount  + 1;
        NSString * imageName = [NSString stringWithFormat:@"%@%@",normallHead,@(randIntger)];
        [array addObject:imageName];
    }
    return array.copy;
}
+ (NSArray<UIImage *> *)imageArrayWithRandArray:(NSArray *)randArray{
    NSMutableArray * imageArray = [NSMutableArray new];
    for (NSString * name in randArray) {
        UIImage * image = [self bundleImageWithImageName:name];
        [imageArray addObject:image];
    }
    return imageArray.copy;
}
/**< 随机一张直播美女图片 */
+ (NSString*)randLiveGirlImage{
    NSInteger maxCount = liveGirlCount - 1;
    NSInteger randIntger =  arc4random()%maxCount  + 1;
    NSString * imageName = [NSString stringWithFormat:@"%@%@",liveGirlHead,@(randIntger)];
    return imageName;
}
/**< 随机多少张直播美女 图片 */
+ (NSArray*)randLiveGirlImageWithCount:(NSInteger)count{
    NSMutableArray * array = [NSMutableArray new];
    for (NSInteger i = 0; i <count; i ++) {
        NSInteger maxCount = liveGirlCount - 1;
        NSInteger randIntger =  arc4random()%maxCount  + 1;
        NSString * imageName = [NSString stringWithFormat:@"%@%@",liveGirlHead,@(randIntger)];
        [array addObject:imageName];
    }
    return array.copy;
    
}
@end
