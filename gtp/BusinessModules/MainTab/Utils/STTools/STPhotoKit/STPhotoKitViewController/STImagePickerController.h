//
//  STImagePickerController.h
//  STTools
//
//  Created by stoneobs on 16/10/9.
//  Copyright © 2016年 stoneobs. All rights reserved.
//**********************这是可以多选的imagepicker***************************
//说明，如果想让相册展示中文 info.plist 添加  Localization native development region   China

#import "STNavigationController.h"
#import "STPhotoModel.h"
#import "UIView+STPhotoKitTool.h"
#define STPHOTOKIT_FINSH_CHOSED_NOTIFICATION @"STPhotoKitFinshChosed" 
typedef void(^STImagePickerControllerFinshed)(NSArray<STPhotoModel*> *array);

@interface STImagePickerController : UINavigationController

/**
 导航栏颜色
 */
@property(nonatomic,strong)UIColor            *navagationBarTintColor;

/**
 显示原图按钮
 */
@property(nonatomic,assign)BOOL               showOriginImageButton;

/**
 取消，确定按钮等主题色
 */
@property(nonatomic,strong)UIColor            *themeColor;

/**
 显示渐变色，具体表现在STPhotoCollectionViewController中
 */
@property(nonatomic,assign)BOOL               showGradual;


@property(nonatomic,assign)NSInteger           maxImageChosed;//最大可选择图片

//hud 在window 上加，这里用block 让用户自己决定Hud的显示，并且存在这种情况：加入图片一共最多选择10张，先选择了8张，继续选择，提示hud 就会出错，所以给用户自定义实现
@property(nonatomic,copy)void(^didChosedMaxImages)(NSInteger maxImageChosed) ;

//不曾封装delegate，回调中是含有STPhotoModel模型的数组，如果需要获取原图，可以根据model 中的asset 来获取，
- (instancetype)initWithDefultRootVCHandle:(STImagePickerControllerFinshed)handle;
@end
