//
//  TMDynamicModel.m
//  Marriage
//
//  Created by Mac on 2018/4/23.
//  Copyright © 2018年 stoneobs@icloud.com. All rights reserved.
//

#import "TMDynamicModel.h"

@implementation TMDynamicModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"dy_id":@"id",@"music_description":@"description"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"images":@"TMDynamicImageModel",
//             @"video":@"TMDynamicVideoModel"
             
             };
}
- (CGFloat)cus_cellHeight{
    if (!_cus_cellHeight) {
        CGFloat lableWith = UIScreenWidth - 10 - 60 - 10;
        _cus_cellHeight = [self.content st_heigthWithwidth:lableWith font:13] + 48 + 10;
        
    }
    return _cus_cellHeight;
}
- (CGFloat)cus_pictureCellHeight{
    if (!_cus_pictureCellHeight) {
        CGFloat lableWith = UIScreenWidth - 40 - 60;
        _cus_pictureCellHeight = [self.title st_heigthWithwidth:lableWith font:13] + 20;
        
    }
    return _cus_pictureCellHeight;
}
@end

@implementation TMDynamicImageModel
@end
@implementation TMDynamicVideoModel
@end
