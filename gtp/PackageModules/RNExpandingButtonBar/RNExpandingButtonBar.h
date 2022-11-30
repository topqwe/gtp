//
//  RNExpandingButtonBar.h
//  ExpandingBar
//
//  Created by mamawang on 14-6-5.
//  Copyright (c) 2014年 mama. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol RNExpandingButtonBarDelegate;

@interface RNExpandingButtonBar : UIView
{
    NSObject <RNExpandingButtonBarDelegate> *_delegate;
    
    /* ---------------------------------------------------------
     * All of the buttons that are animated by pressing the main button.
     * -------------------------------------------------------*/
    NSArray *_buttons;
    
    /* ---------------------------------------------------------
     * Main button that is shown when no other buttons are displayed.
     * -------------------------------------------------------*/
    UIButton *_button;
    
    /* ---------------------------------------------------------
     * Button that is shown after pressed. Fades in.
     * -------------------------------------------------------*/
    UIButton *_toggledButton;
    
    /* ---------------------------------------------------------
     * Public. Time for each button to animate into view in seconds.
     * -------------------------------------------------------*/
    float _animationTime;
    
    /* ---------------------------------------------------------
     * Public. Time for the fade transition when toggling the main button.
     * -------------------------------------------------------*/
    float _fadeTime;
    
    /* ---------------------------------------------------------
     * Public. The padding in between buttons.
     * -------------------------------------------------------*/
    float _padding;
    
    /* ---------------------------------------------------------
     * Public. Both used in the bouncing effect.
     * Far is how far past the final point to bounce.
     * Near is how much to come in on the bounce.
     * -------------------------------------------------------*/
    float _far;
    float _near;
    
    /* ---------------------------------------------------------
     * Public. Time between each button's animation.
     * -------------------------------------------------------*/
    float _delay;
    
    /* ---------------------------------------------------------
     * Public. Whether or not to apply spinning animation.
     * -------------------------------------------------------*/
    BOOL _spin;
    
    /* ---------------------------------------------------------
     * Public. Whether or not to explode the button when touched.
     * -------------------------------------------------------*/
    BOOL _explode;
    
    /* ---------------------------------------------------------
     * Public. Toggle the horizontal animation.
     * -------------------------------------------------------*/
    BOOL _horizontal;
    
    /* ---------------------------------------------------------
     * Public. Whether to animate the buttons in and out.
     * -------------------------------------------------------*/
    BOOL _animated;
    
    BOOL _toggled;
}

@property (nonatomic, strong) NSArray *buttons;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *toggledButton;
@property (nonatomic, strong) NSObject <RNExpandingButtonBarDelegate> *delegate;

- (id) initWithImage:(UIImage*)image
       selectedImage:(UIImage*)selectedImage
        toggledImage:(UIImage*)toggledImage
toggledSelectedImage:(UIImage*)toggledSelectedImage
expandingButtonInfos:(NSArray*)expandingButtonInfos
expandingButtonFrame:(CGRect)expandingButtonFrame
              center:(CGPoint)center;

- (void) setDefaults;

- (void) showButtons;
- (void) hideButtons;
- (void) showButtonsAnimated:(BOOL)animated;
- (void) hideButtonsAnimated:(BOOL)animated;

- (void) toggleMainButton;
- (void) onButton:(id)sender;
- (void) onToggledButton:(id)sender;

- (int) getXoffset:(UIView*)view;
- (int) getYoffset:(UIView*)view;

- (void) explode:(id)sender;

- (void) setAnimationTime:(float)time;
- (void) setFadeTime:(float)time;
- (void) setPadding:(float)padding;
- (void) setSpin:(BOOL)b;
- (void) setHorizontal:(BOOL)b;
- (void) setFar:(float)num;
- (void) setNear:(float)num;
- (void) setDelay:(float)num;
- (void) setExplode:(BOOL)b;
- (void)actionBlock:(ActionBlock)block;
@end

@protocol RNExpandingButtonBarDelegate <NSObject>

- (void) expandingBarWillAppear:(RNExpandingButtonBar*)bar;
- (void) expandingBarDidAppear:(RNExpandingButtonBar *)bar;
- (void) expandingBarWillDisappear:(RNExpandingButtonBar *)bar;
- (void) expandingBarDidDisappear:(RNExpandingButtonBar *)bar;

@end
