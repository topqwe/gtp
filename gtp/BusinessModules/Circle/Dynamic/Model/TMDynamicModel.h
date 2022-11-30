//
//  TMDynamicModel.h
//  Marriage
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TMDynamicImageModel,TMDynamicVideoModel;
/************动态模型******************/
@interface TMDynamicModel : NSObject
@property(nonatomic, strong) NSString                     *dy_id;/**<  */
@property(nonatomic, strong) NSString                     *video_id;/**<  */
@property(nonatomic, strong) NSString                     *type;/**<  */
@property(nonatomic, strong) NSArray<TMDynamicImageModel*>                     *images;/**<  */
@property(nonatomic, strong) TMDynamicVideoModel                   *video;/**<  */
@property(nonatomic, strong) NSString                     *content;/**<  */
@property(nonatomic, strong) NSString                     *time;/**<  */
@property(nonatomic, strong) NSString                     *love;/**<  */
@property(nonatomic, strong) NSString                     *comment_num;/**<  */
@property(nonatomic, strong) NSString                     *region_id;/**<  */
@property(nonatomic, strong) NSString                     *nickname;/**<  */
@property(nonatomic, strong) NSString                     *image;/**<  */

@property(nonatomic, strong) NSString                     *sex;/**<1男2女  */
@property(nonatomic, assign) bool                     islove;/**<  */
@property(nonatomic, strong) NSString                     *region;/**<  */
@property(nonatomic, strong) NSString                     *title;/** 首页图片 title*/

@property(nonatomic, assign) CGFloat                     cus_cellHeight;/**<  */
@property(nonatomic, assign) CGFloat                     cus_pictureCellHeight;/**< 图片模块的高度 */
@property(nonatomic, assign) CGFloat                     cus_voiceHeight;/**<  */

@property(nonatomic, strong) NSString                     *filepath;/**<  音乐文件 */
@property(nonatomic, strong) NSString                     *music_description;/**< 音乐/小说描述 */

@property(nonatomic, strong) NSString                     *service_num;/**< 服务  价格  */
@property(nonatomic, strong) NSString                     *cate_name;/**< 地区  */
@property(nonatomic, strong) NSString                     *age;/**< 年龄 */
@property(nonatomic, strong) NSString                     *concat;/**< 联系  方式  */

@property(nonatomic, strong) BVAdverModel                     *cus_adver;/**< 随机广告 */
@property(nonatomic, assign) CGFloat                     cus_imageHeight;/**< 广告高度 */
@end

@interface TMDynamicImageModel : NSObject
@property(nonatomic, strong) NSString                     *min;/**<  */
@property(nonatomic, strong) NSString                     *max;/**<  */
@end

@interface TMDynamicVideoModel : NSObject
@property(nonatomic, strong) NSString                     *link;/**<  */
@property(nonatomic, strong) NSString                     *image;/**<  */
@end
/*
 "id": 51,
 "video_id": null,
 "type": 1,
 "images": [{
 "max": "http:\/\/59.188.25.220\/\/uploads\/picture\/20190329\/5a13d89efd884088dc4a2ed817050ab0.jpg",
 "min": "http:\/\/59.188.25.220\/\/uploads\/picture\/20190329\/min_5a13d89efd884088dc4a2ed817050ab0.jpg"

 "content": "\u8f6c\u4e1a\u6559\u7528\u5957\uff0c\u5305\u6559\u5305\u4f1a",
 "time": "2019-03-29 11:41:16",
 "love": 0,
 "comment_num": 0,
 "region_id": 1,
 "nickname": "\u662f\u53ef\u4e50\u5440",
 "image": "http:\/\/59.188.25.220\/uploads\/picture\/20190323\/0691059a7cd1b71d009489ae21b3d1df.jpg",
 "sex": 2,
 "islove": 0,
 "region": "\u91cd\u5e86"
 */
