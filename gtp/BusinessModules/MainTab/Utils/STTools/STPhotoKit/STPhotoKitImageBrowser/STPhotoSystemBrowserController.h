//
//  STPhotoBrowserController.h
//  STTools
//
//  Created by stoneobs on 16/10/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  照片浏览 ，系统级别的，模态到这个控制器,并且关闭动画

#import "UIViewController+STNavigationTools.h"
#import "STPhotoModel.h"
#import "STImagePickerController.h"
@protocol STPhotoSystemBrowserControllerDlegate <NSObject>
@required
//滑动到某个位置,返回图片的view
//imageView.contentMode = UIViewContentModeScaleAspectFill;
- (UIView *)STPhotoSystemBrowserControllerDidScrollToIndexpath:(NSIndexPath*)indexPath model:(STPhotoModel*)model;
//这个方法里面可以合适的刷新数据
- (void)didClicTheChosedButtonAtIndexPath:(NSIndexPath*)indexPath currentModel:(STPhotoModel*)currentModel;
//点击了确认按钮,可以手动退出控制器
- (void)didClicTheConfimButtonCurrentIndexPath:(NSIndexPath*)currentIndexPath  currentModel:(STPhotoModel*)currentModel;

//已经成功dismiss 此时访问了原图 可以更换model
- (void)didDismissFromSTPhotoSystemBrowserControllerCurrentIndexPath:(NSIndexPath*)currentIndexPath currentModel:(STPhotoModel*)currentModel;
@end


@interface STPhotoSystemBrowserController : UIViewController
@property(nonatomic,strong)UIColor                                      *themeColor;//主题色，取消，确认颜色

@property(nonatomic,strong)NSMutableArray<STPhotoModel*>                *chosedArray;//被选中的数组

@property(nonatomic,assign)BOOL                                         showBottomView;//是否显示下方view，默认yes

@property(nonatomic,weak)STImagePickerController                        *weakNav;

@property(nonatomic,weak)  id <STPhotoSystemBrowserControllerDlegate>   STPhotoSystemBrowserControllerdlegate;


- (instancetype)initWithArray:(NSArray<STPhotoModel*>*)dataSouce curentIndex:(NSInteger)curentIndex;

@end
