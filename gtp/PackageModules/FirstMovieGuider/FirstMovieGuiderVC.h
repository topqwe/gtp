//
//  WSMovieController.h
//  StartMovie
//
//  Created by iMac on 16/8/29.
//  Copyright © 2016年 sinfotek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstMovieGuiderVC : UIViewController
- (void)actionBlock:(ActionBlock)block;
@property(nonatomic,strong)NSURL *movieURL;

@end
