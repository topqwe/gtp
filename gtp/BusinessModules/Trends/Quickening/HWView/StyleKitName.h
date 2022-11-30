//
//  StyleKitName.h
//  TagUtilViews
//
//  Created by WIQChen on 16/8/29.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@class PCGradient;

@interface StyleKitName : NSObject

// Colors
+ (UIColor*)gradient2Color;
+ (UIColor*)gradient3Color;

// Gradients
+ (PCGradient*)gradient2;
+ (PCGradient*)gradient3;

//// In trial version of PaintCode, the code generation is limited to one canvas

// Drawing Methods
+ (void)drawGroupYue1Canvas;

@end



@interface PCGradient : NSObject
@property(nonatomic, readonly) CGGradientRef CGGradient;
- (CGGradientRef)CGGradient NS_RETURNS_INNER_POINTER;

+ (instancetype)gradientWithColors: (NSArray*)colors locations: (const CGFloat*)locations;
+ (instancetype)gradientWithStartingColor: (UIColor*)startingColor endingColor: (UIColor*)endingColor;

@end



@interface UIColor (PaintCodeAdditions)

- (UIColor*)blendedColorWithFraction: (CGFloat)fraction ofColor: (UIColor*)color;

@end

