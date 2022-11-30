//
//  SelectCityListVC.h
//  PPOYang
//
//  Created by WIQ on 2017/4/1.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kLocationCity     @"kLocation_City"     //定位城市
#define kIsGetCurrentCity @"kIsGetCurrentCity" 
@interface SelectCitySearchBar : UIImageView

@property(nonatomic,strong)UITextField *searchField;

@end


@interface SelectCityListVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property(nonatomic,strong)SelectCitySearchBar *searchBar;
@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong) NSMutableDictionary *cities;
@property (nonatomic, strong) NSMutableArray *keys; //城市首字母
@property (nonatomic, assign) id delegateSelectCity;
@property (nonatomic, strong) NSMutableArray *arrayCitys;   //城市数据
@property (nonatomic, strong) NSMutableDictionary *citiesForSearch;
@property (nonatomic, strong) NSMutableArray *arrayHotCity;
@property (nonatomic,strong)NSString *currentLocationCity;  //当前城市

@property (copy, nonatomic) void(^didSelectCity)(NSString * city);
@property(nonatomic,assign)BOOL isFirst;


@end
