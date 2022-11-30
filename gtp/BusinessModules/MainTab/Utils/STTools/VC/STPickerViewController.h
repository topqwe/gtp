//
//  STPickerVIewController.h
//  SportClub
//
//  Created by stoneobs on 16/8/10.
//  Copyright © 2016年 stoneobs. All rights reserved.
// 说明：此vc用来做弹出Pickerview的一个模态控制器，默认有时间和地区选择器,可以传入数组，定义picker，用此控制器，请使用模态，push 的会出错


#import <UIKit/UIKit.h>
typedef void (^STPickerViewControllerAREPICKER)(NSString *finshString,NSString * area,NSString * city,NSString * provence);
typedef void (^STPickerViewControllerDATEPICKER)(NSDate * date);
typedef void (^STPickerViewControllerCusPicker)(NSArray<NSString*> * stringArray);
#define STPickerViewFrameDidChange @"STPickerViewFrameDidChange"
#define STPickerViewFrameDidEndChange @"STPickerViewFrameDidEndChange"
@interface STPickerViewController : UIViewController
@property (nonatomic) UIDatePickerMode      datePickerMode;//默认是dateicker时候有效，否则无效

@property (nonatomic, strong) NSDate        *displayDate;

@property (nonatomic, strong) NSDate        *minimumDate; // datepikcer 有效，否则忽略

@property (nonatomic, strong) NSDate        *maximumDate;

@property (nonatomic, strong) UIColor         *confimTitleColor;//确定的颜色
@property(nonatomic,assign)BOOL  isNoTimeZone;//是否 +8 时间



/**
 *  是否开启弹性动画,默认yes
 */
@property(nonatomic)BOOL isSpringAnimation;
/**
 *  是否显示确定和取消按钮
 */
@property(nonatomic)BOOL isShowConfirm;
/**
 *  弹出框的高度，默认260
 */
@property(nonatomic)CGFloat  bottomHeight;
/**
 *  初始化时间选择器,
 */
-(instancetype)initWithDefualtDatePickerWithHandle:(STPickerViewControllerDATEPICKER)handle;
/**
 *  初始化默认地区选择器
 */
-(instancetype)initWithDefualtAreaPickerWithHandle:(STPickerViewControllerAREPICKER)handle;
// 初始化picker，自定义数据
-(instancetype)initWithPickerArray:(NSArray<NSArray<NSString*>*> *)dataSouce andWithHandle:(STPickerViewControllerCusPicker)handle;


@end

