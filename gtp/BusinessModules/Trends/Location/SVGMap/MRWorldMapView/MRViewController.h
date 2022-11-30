// MRViewController.h

@import UIKit;

#import "MRWorldMapView.h"


@interface MRViewController : UIViewController <UIScrollViewDelegate, MRWorldMapViewDelegate>

@property (nonatomic, weak) IBOutlet MRWorldMapView *worldMapView;
@property (nonatomic, weak) IBOutlet UIView *contentView;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UILabel *label;

@end
