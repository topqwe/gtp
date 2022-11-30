//
//  LBCommentTableViewCell.h
//  LangBa
//
//  Created by Mac on 2017/12/21.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMComentModel.h"
/************评论cell******************/
@interface TMDynamicCommentTableViewCell : UITableViewCell
@property(nonatomic, strong) TMComentModel                     *model;/**< <##> */
@property(nonatomic, strong) STButton                     *goodButton;/**< 点赞 */
+ (CGFloat)cellHeight;
@end
