//
//  UIResponder+STFeedbackGenerator.m
//  togetherPlay
//
//  Created by Mac on 2019/1/10.
//  Copyright © 2019 stoneobs.qq.com. All rights reserved.
//

#import "UIResponder+STFeedbackGenerator.h"

@implementation UIResponder (STFeedbackGenerator)

- (void)st_showNotificationFeedback:(UINotificationFeedbackType)type{
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
            [generator prepare];
            [generator notificationOccurred:type];
        });
    } else {
        // Fallback on earlier versions
    }
    
    
}
- (void)st_showImpactFeedbackGenerator:(UIImpactFeedbackStyle)style{
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:style];
            [generator prepare];
            [generator impactOccurred];
        });

    } else {
        // Fallback on earlier versions
    }
}
- (void)st_showSelectionFeedbackGenerator{
    
    if (@available(iOS 10.0, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UISelectionFeedbackGenerator *generator = [[UISelectionFeedbackGenerator alloc] init];
            [generator prepare];
            [generator selectionChanged];
        });

    } else {
        // Fallback on earlier versions
    }
    
}
@end

