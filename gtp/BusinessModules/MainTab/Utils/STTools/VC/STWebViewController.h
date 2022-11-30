//
//  STWebViewController.h
//  SportHome
//
//  Created by stoneobs on 16/12/14.
//  Copyright © 2016年 stoneobs. All rights reserved.
//  一般webview

#import <UIKit/UIKit.h>

@interface STWebViewController : UIViewController
@property(nonatomic ,strong) UIColor          *progressBackgroundColor;
@property(nonatomic, strong) UIColor          *progressTintColor;
@property(nonatomic, strong) NSString         *forceTitle;//webView 代理完成之后 强制改变title
- (instancetype)initWithUrl:(NSString*)url;
- (instancetype)initWithLocalUrl:(NSString*)path;
- (instancetype)initWithH5String:(NSString*)h5String;
@end
