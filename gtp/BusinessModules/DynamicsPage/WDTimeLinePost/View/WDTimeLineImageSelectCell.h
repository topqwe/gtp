//
//  WDTimeLineImageSelectCell.h
//  TimeLine
//
//  Created by Unique on 2019/10/30.
//  Copyright © 2019 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <HXPhotoPicker/NSArray+HXExtension.h>
NS_ASSUME_NONNULL_BEGIN

@class WDTimeLineImageSelectCell;

@protocol WDTimeLineImageSelectCellDelegate <NSObject>
- (void)imageSelectCell:(WDTimeLineImageSelectCell *)cell didChangePhotoAssets:(NSArray<PHAsset *> *)photoAssets didChangeVideoAssets:(NSArray<PHAsset *> *)videoAssets;

- (void)imageSelectCell:(WDTimeLineImageSelectCell *)cell didChangePhotos:(NSArray<HXPhotoModel *> *)photos didChangeVideos:(NSArray<HXPhotoModel *> *)videos;


@end

@interface WDTimeLineImageSelectCell : UITableViewCell
@property (nonatomic, weak) id <WDTimeLineImageSelectCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
