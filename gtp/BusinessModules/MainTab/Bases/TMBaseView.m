//
//  TMBaseView.m
//  blanket
//
//  Created by Mac on 2017/12/4.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import "TMBaseView.h"

@implementation TMBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configSubView];
        
    }
    return self;
}
#pragma mark --subView
- (void)configSubView{
    
}

@end
