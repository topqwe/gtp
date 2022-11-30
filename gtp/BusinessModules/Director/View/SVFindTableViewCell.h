//
//  SVFindTableViewCell.h
//  sixnineVideo
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 猪八戒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/************发现cell******************/
@interface SVFindTableViewCell : UITableViewCell
@property(nonatomic, strong) STButton                     *likeButton;/**< 喜欢 */
@property(nonatomic, strong) STButton                     *colButton;/**< 收藏 */
@property(nonatomic, strong) STButton                     *shareButton;/**< 分享 */
@property(nonatomic, strong) ZFPlayerView                     *playerView;/**< <##> */
@property(nonatomic, strong) BVVideoEasyModel                     *model;/**< <##> */
@property(nonatomic, strong) ZFPlayerModel                     *playerModel;/**< <##> */
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
