//
//  PageViewController.h
//  TestTabTitle
//
//  Created by WIQ on 2018/12/20.
//  Copyright © 2018年 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PageListView;
@interface PageVC : UIViewController
- (void)actionBlock:(TableViewDataBlock)block;
@property (nonatomic,copy)NSString *tag;
- (void)pageListView:(PageListView *)view requestListWithPage:(NSInteger)page;
@end
