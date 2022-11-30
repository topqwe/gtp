//
//  PageViewController.h
//  TestTabTitle
//
//  Created by WIQ on 2018/12/20.
//  Copyright © 2018年 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersPageVC : UIViewController
- (void)actionBlock:(TwoDataBlock)block;
@property (nonatomic,copy)NSString *tag;
@end
