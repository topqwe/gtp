//
//  ZFPlayerControlView.h
//
// Copyright (c) 2016年 任子丰 ( http://github.com/renzifeng )
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"
#import "STButton.h"
//#import "ZFPlayer.h"

@interface ZFPlayerControlView : UIView
- (void)updateForeverShow:(BOOL)foreverShow;
@property (nonatomic, assign) BOOL                foreverShow;
/** 开始播放按钮 */
@property (nonatomic, strong) UIButton                *startBtn;
/** 重播按钮 */
@property (nonatomic, strong) UIButton                *repeatBtn;
/** 返回按钮*/
@property (nonatomic, strong) UIButton                *backBtn;
/** 全屏按钮 */
@property (nonatomic, strong) UIButton                *fullScreenBtn;
@property(nonatomic, strong) STButton                     *st_frontButton;/**< 前15s */
@property(nonatomic, strong) STButton                     *st_backButton;/**< 后15s */
@property(nonatomic, strong) STButton                     *st_typeButton;/**< 类型 */
@property(nonatomic, strong) STButton                     *st_shareButton;/**< 类型 */
/** 当前播放时长label */
@property (nonatomic, strong) UILabel                 *currentTimeLabel;
/** 视频总时长label */
@property (nonatomic, strong) UILabel                 *totalTimeLabel;
/** 缓冲进度条 */
@property (nonatomic, strong) UIProgressView          *progressView;
/** 滑杆 */
@property (nonatomic, strong) ASValueTrackingSlider   *videoSlider;
/** 控制层消失时候在底部显示的播放进度progress */
@property (nonatomic, strong) UIProgressView          *bottomProgressView;
@end
