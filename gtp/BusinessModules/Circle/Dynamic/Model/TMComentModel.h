//
//  TMComentModel.h
//  BannerVideo
//
//  Created by apple on 2019/3/29.
//  Copyright © 2019 stoneobs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TMComentModel : NSObject
@property(nonatomic, strong) NSString                     *com_id;/**<  */
@property(nonatomic, strong) NSString                     *user_id;/**<  */
@property(nonatomic, strong) NSString                     *content;/**<  */
@property(nonatomic, strong) NSString                     *date;/**<  */
@property(nonatomic, strong) NSString                     *nickname;/**<  */
@property(nonatomic, strong) NSString                     *image;/**<  */
@property(nonatomic, strong) NSString                     *sex;/**<  */
@property(nonatomic, assign) bool                     islove;/**<  */
@property(nonatomic, assign) CGFloat                     cus_cellHeight;/**<  */
@end
/*
 "id": 34,
 "user_id": 10,
 "content": "\u723d\u5566",
 "date": "03\u670828\u65e5",
 "nickname": "\u751c\u5fc3\u5b9d\u8d1d",
 "image": "http:\/\/59.188.25.220\/uploads\/picture\/20190323\/771753b56f29c00a20120c11f5d9f14a.jpg",
 "sex": 2,
 "islove": 1
 */
NS_ASSUME_NONNULL_END
