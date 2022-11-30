//
//  PieModel.h


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PieModel : NSObject
@property (nonatomic,copy)NSString *title;
@property (nonatomic,copy)NSString *descript;
@property (nonatomic,assign)CGFloat count;
@property (nonatomic,assign)CGFloat percent;
@property (nonatomic,strong)UIColor *color;
@end
