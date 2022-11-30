//  HHL
//
//  Created by WIQ on 2018/12/23.
//  Copyright © 2018 WIQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PostAdsFV : UIView

@property (nonatomic, strong) UILabel* titleLab;
@property (nonatomic, strong) UILabel* priceLab;
@property (nonatomic, strong) UIButton* noExpressFeeImage;

- (void)actionBlock:(ActionBlock)block;
- (void)richElementsInHeaderWithModel:(NSDictionary*)data;
- (instancetype)initWithFrame:(CGRect)frame WithModel:(NSArray*)titleArray;
@end
