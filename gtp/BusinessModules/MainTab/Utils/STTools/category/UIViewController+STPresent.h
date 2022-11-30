//
//  UIViewController+STPresent.h
//  SportHome
//
//  Created by stoneobs on 16/11/25.
//  Copyright © 2016年 stoneobs. All rights reserved.

#import <UIKit/UIKit.h>
typedef void(^ST_ALERT_BLOCK)(NSString * name);//alert 回调
typedef void (^ST_ACTION_BLOCK)(int tag); //actionsheet 回调
typedef void (^ST_IMAGE_PICKER_BLOCK) (UIImage * image); //图片选择回调
@interface UIViewController (STPresent)
<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate
>
// UIAlertController
- (void)st_showAlertTitle:(NSString*)title
               message:(NSString *)message
          andWithBlock:(ST_ALERT_BLOCK)finsh;
- (void)st_showAlertTitle:(NSString*)title
               message:(NSString *)message
             leftTitle:(NSString*)leftTitle
            rightTitle:(NSString*)rightTitle
                 block:(ST_ALERT_BLOCK)finsh;
- (void)st_showTextFiledAlertWithTitle:(NSString*)title
                            message:(NSString *)message
                          leftTitle:(NSString*)leftTitle
                         rightTitle:(NSString*)rightTitle
                       preperTextfiled:(void(^)(UITextField * textFiled))preperTextfiled
                              block:(void(^)(NSString*buttonTitle,NSString* textFiledText))finsh;

//actionSheet
- (void)st_showActionSheet:(NSArray<NSString*>*)strArray
           andWithBlock:(ST_ACTION_BLOCK)test;
//直接弹出图片选择控制器
- (void)st_showDefultImagePicker:(ST_IMAGE_PICKER_BLOCK)pickerBlock;
//直接拍照
- (void)st_showTakePhotoImagePicker:(ST_IMAGE_PICKER_BLOCK)pickerBlock;
//从照片获取
- (void)st_showchosePhotoImagePicker:(ST_IMAGE_PICKER_BLOCK)pickerBlock;
//完全自定义alert
- (void)st_showAlertWithTitle:(NSString*)title
                titleColor:(UIColor*)titleColor
                   message:(NSString*)message
              messageColor:(UIColor*)messageColor
                 leftTitle:(NSString*)leftTitle
            leftTitleColor:(UIColor*)leftTitleColor
                rightTitle:(NSString*)rightTitle
           rightTitleColor:(UIColor*)rightTitleColor
                    handle:(ST_ALERT_BLOCK)handle;
@end
