//
//  STPhotoUrlImageBrowerController.h
//  STNewTools
//
//  Created by stoneobs on 17/3/9.
//  Copyright © 2017年 stoneobs. All rights reserved.
//  常见网络图片浏览器

#import <UIKit/UIKit.h>
#import "STUrlPhotoModel.h"
#import "STUrlBrowserCollectionViewCell.h"
@class STPhotoUrlImageBrowerController;

@protocol STPhotoUrlImageBrowerControllerDelegate <NSObject>
@required
//滑动到某个位置,返回当前cell中的imageview/button
@required;
//imageView.contentMode = UIViewContentModeScaleAspectFill;
- (UIView*)STPhotoSystemBrowserControllerDidScrollToIndexpath:(NSIndexPath*)indexPath model:(STUrlPhotoModel*)model;

@optional;
//将要dismiss 此时访问了原图 可以更换model
- (void)willDismissFromSTPhotoSystemBrowserControllerCurrentIndexPath:(NSIndexPath*)currentIndexPath currentModel:(STUrlPhotoModel*)currentModel;
//已经成功dismiss 此时访问了原图 可以更换model
- (void)didDismissFromSTPhotoSystemBrowserControllerCurrentIndexPath:(NSIndexPath*)currentIndexPath currentModel:(STUrlPhotoModel*)currentModel;

//长按了某个cell
- (void)didLongPressTheCell:(STUrlBrowserCollectionViewCell*)cell  fromVC:(STPhotoUrlImageBrowerController*)vc  currentIndexPath:(NSIndexPath*)indexPath currentModel:(STUrlPhotoModel*)model;

//点击了右上角按钮，用户可以自定义出相应的操作
@optional
- (void)rightBarActionFromController:(STPhotoUrlImageBrowerController*)controller currentIndexPath:(NSIndexPath *)curentIndexpath;
@end
@interface STPhotoUrlImageBrowerController : UIViewController
@property(nonatomic,strong)UIColor                                          *themeColor;//主题色
@property(nonatomic,strong)UICollectionView                     *collectionView;
@property(nonatomic,assign)BOOL                                             shouldHideTopView;//是否隐藏顶部工具栏

@property(nonatomic,assign)BOOL                                             shouldHideBottomView;
@property(nonatomic,weak)  id <STPhotoUrlImageBrowerControllerDelegate>      STPhotoUrlImageBrowerControllerdelegate;

- (instancetype)initWithArray:(NSArray<STUrlPhotoModel*>*)dataSouce curentIndex:(NSInteger)curentIndex;

- (void)reloadData;//重载数据
@end
