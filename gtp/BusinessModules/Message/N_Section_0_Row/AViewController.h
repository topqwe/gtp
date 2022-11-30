//
//  AViewController.h
//  SegmentController
//
//  Created by mamawang on 14-6-6.
//  Copyright (c) 2014年 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MMKnow=0,
    ShoppingList=1,
    AngleBox=2,
    GenderMaker=3,
    PregnantWeightGuider=4,
    BCListExplain=5,
    BabyWeightCounter=6,
 }TreasureCaseType;
@interface AViewController : UIViewController
@property(nonatomic,assign)BOOL isOpenNotification;
@end
