
#import <UIKit/UIKit.h>

#pragma mark - ZCSlotMachine Delegate
@class ZCSlotMachine;

@protocol ZCSlotMachineDelegate <NSObject>

@optional
- (void)slotMachineWillStartSliding:(ZCSlotMachine *)slotMachine;
- (void)slotMachineDidEndSliding:(ZCSlotMachine *)slotMachine;

@end

@protocol ZCSlotMachineDataSource <NSObject>

@required
- (NSUInteger)numberOfSlotsInSlotMachine:(ZCSlotMachine *)slotMachine;
- (NSArray *)iconsForSlotsInSlotMachine:(ZCSlotMachine *)slotMachine;

@optional

- (CGFloat)slotWidthInSlotMachine:(ZCSlotMachine *)slotMachine;
- (CGFloat)slotSpacingInSlotMachine:(ZCSlotMachine *)slotMachine;

@end

NS_ASSUME_NONNULL_BEGIN

@interface ZCSlotMachine : UIView

// UI 属性
@property (nonatomic)UIEdgeInsets contentInset;
@property (nonatomic, strong)UIImage *backgroundImage;
@property (nonatomic, strong)UIImage *coverImage;

// Data 属性
@property (nonatomic, strong)NSArray *slotResults;

// 动画
// 时间控制
@property (nonatomic)CGFloat singleUnitDuration;

@property(nonatomic,weak)id <ZCSlotMachineDelegate> delegate;
@property(nonatomic,weak)id <ZCSlotMachineDataSource> dataSource;

- (void)startSliding;

@end

NS_ASSUME_NONNULL_END
