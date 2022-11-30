//
//  STTableEasyModel.h
//  GodHorses
//
//  Created by Mac on 2017/11/25.
//  Copyright © 2017年 stoneobs@icloud.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface STTableEasyModel : NSObject
@property(nonatomic, assign) CGFloat                     height;//默认44；

@property(nonatomic, strong) UIImage                     *image;

@property(nonatomic,strong)NSString                     *detailString;

@property(nonatomic,strong)NSString                     *textString;

@property (nonatomic)UITableViewCellAccessoryType       accessoryType;

@property(nonatomic,assign)bool                         isSlected;


@property(nonatomic,strong)NSIndexPath                  *indexPath;

@property(nonatomic,strong)UIView                       *accessoryView;

- (instancetype)initWithTextString:(NSString*)textString detailString:(NSString*)detailString;
- (instancetype)initWithTextString:(NSString*)textString imageName:(NSString*)imageName;

- (instancetype)initWithTextString:(NSString*)textString accessoryView:(UIView*)accessoryView;
- (instancetype)initWithTextString:(NSString*)textString
                      detailString:(NSString*)detailString
                     accessoryType:(UITableViewCellAccessoryType)accessoryType;
@end

@interface UITableViewCell(STTablyEaseModel)
- (void)setSt_tableEasyModel:(STTableEasyModel*)st_tableEasyModel;
@end
