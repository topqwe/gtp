//
//  PHLockClick.h
//  TagUtilViews
//
//  Created by WIQChen on 16/8/23.
//  Copyright © 2016年 WIQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PHLockClick : NSObject
@property (nonatomic,assign) BOOL lock;
@property (nonatomic,assign) NSInteger senderTag;
@property (nonatomic,strong) PHLockClick *lastLock;
@end
