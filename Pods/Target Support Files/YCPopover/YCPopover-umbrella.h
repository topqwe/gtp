#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "UIViewController+YCPopover.h"
#import "YCPopoverAnimator.h"
#import "YCPopoverMacro.h"
#import "YCPresentationController.h"

FOUNDATION_EXPORT double YCPopoverVersionNumber;
FOUNDATION_EXPORT const unsigned char YCPopoverVersionString[];

