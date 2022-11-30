//
//  BaseCell.h
//


#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell
@property (nonatomic, strong) UIImageView *arrowIv;
@property (nonatomic, strong) UIColor *separatorLineColor;

@property (nonatomic, assign, getter=isHideSeparatorLine) BOOL hideSeparatorLine;
+(instancetype)cellWith:(UITableView*)tabelView;
@end
