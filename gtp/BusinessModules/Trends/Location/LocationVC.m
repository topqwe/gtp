//
//  MasterEViewController.m
//  TestDemo
//
//  Created by WIQChen on 16/3/1.
//  Copyright © 2016年 WIQChen. All rights reserved.
//

#import "LocationVC.h"
#import "MasterETVCell.h"

#import "SelectCityListVC.h"

#import "CLGeocoderVC.h"
#import "CoreLocationVC.h"
#import "MKAnnotationVC.h"
@interface LocationVC ()
@property(nonatomic,strong) UITableView* eTableView;
@property(nonatomic,strong) NSMutableArray* dataArray;

@end

@implementation LocationVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    LocationVC *vc = [[LocationVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.eTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleTopMargin;
    self.eTableView.dataSource=self;
    self.eTableView.delegate=self;
 self.eTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //    if ([self.eTableView respondsToSelector:@selector(setSeparatorInset:)]) {
    //        [self.eTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    //    }
    self.eTableView.backgroundColor = kWhiteColor;
    
    //去掉多余cell
    self.tableView.tableFooterView = [[UIView alloc]init];


    [self.view addSubview:self.eTableView];
    
    self.dataArray = [@[@"CLGeocoder",@"CoreLocation",@"MKCalloutAnnotation"]mutableCopy];
    [self locateCurrentAddress];
}

#pragma mark--NaivBar Item Layout
-(void)locateCurrentAddress{
    NSString* city = GetUserDefaultWithKey(kLocationCity);
    if (city.length>0) {
        [self.navigationItem addCustomRightButton:self withImage:nil andTitle:city];
    }else{
        [self.navigationItem addCustomRightButton:self withImage:nil andTitle:@"定位"];
        [[CoreLocationManager shareLocation]getCity:^(NSString *cityString) {
            if (cityString!=nil&&cityString.length>0) {
                ////标记已经成功定位当前位置
                SetUserBoolKeyWithObject(kIsGetCurrentCity, YES);
                SetUserDefaultKeyWithObject(kLocationCity, cityString);
                UserDefaultSynchronize;
                [self.navigationItem addCustomRightButton:self withImage:nil andTitle:cityString];
            }
        } error:^(NSError *error) {
            
            [self.navigationItem addCustomRightButton:self withImage:nil andTitle:@"定位"];
        }];
    }
}
#pragma mark--NaivBar Item Target
- (void)rightButtonEvent{
    SelectCityListVC* selectCityVC = [[SelectCityListVC alloc] init];
    selectCityVC.didSelectCity = ^(NSString *city) {
        
        [self.navigationItem addCustomRightButton:self withImage:nil andTitle:city];
        //            [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //                UIButton* leftBtn = (UIButton*)[obj.customView viewWithTag:91];
        //                [leftBtn setTitle:city forState:UIControlStateNormal];
        //            }];
    };
    
//    UIViewController+YBGeneral存在
//    selectCityVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:selectCityVC animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MasterETVCell* cell = [MasterETVCell itsCellWithTableView:tableView];
    [cell richElementsInCellWithListData:self.dataArray[indexPath.row]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return [self heightForBasicCellAtIndexPath:indexPath];
    return 40;
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static MasterETVCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"MasterETVCell"];
    });
    
//    [sizingCell presentItem];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f;
    // Add 1.0f for the cell separator height
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (indexPath.row) {
        case 0:
        {
            CLGeocoderVC* geoCoderVC = [[CLGeocoderVC alloc]init];
            [self.navigationController pushViewController:geoCoderVC animated:NO];
        }
            break;
        case 1:
        {
            
            CoreLocationVC* clVC = [[CoreLocationVC alloc]init];
            [self.navigationController pushViewController:clVC animated:NO];
        }
            break;
        case 2:
        {
            MKAnnotationVC* annotationVC = [[MKAnnotationVC alloc]init];
            [self.navigationController pushViewController:annotationVC animated:NO];
        }
            break;
            
        default:
            break;
    }
   
}


@end
