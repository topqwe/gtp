//
//  SelectCityListVC.h
//  PPOYang
//
//  Created by WIQ on 2017/4/1.
//  Copyright © 2017年 PPO. All rights reserved.
//

#import "SelectCityListVC.h"
#import "pinyin.h"

@implementation SelectCitySearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        
        self.image = [UIImage imageNamed:@"citybg"];
        
        UIImageView *searchBg = [[UIImageView alloc] initWithFrame:CGRectMake(8, 8, MAINSCREEN_WIDTH - 16, 34)];
        searchBg.userInteractionEnabled = YES;
        searchBg.image = [[UIImage imageNamed:@"cityfindinput"] stretchableImageWithLeftCapWidth:20 topCapHeight:34];
        [self addSubview:searchBg];
        
        UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 19, 20)];
        searchIcon.image = [UIImage imageNamed:@"cityfindicon"];
        [searchBg addSubview:searchIcon];
        
        _searchField = [[UITextField alloc] initWithFrame:CGRectMake(44, 5, MAINSCREEN_WIDTH - 70, 24)];
        _searchField.backgroundColor = kClearColor;
        _searchField.font = kFontSize(15);
        _searchField.textColor = RGBSAMECOLOR(3);
        _searchField.returnKeyType = UIReturnKeySearch;
        [searchBg addSubview:_searchField];
    }
    return self;
}

@end

@interface SelectCityListVC ()

@end

@implementation SelectCityListVC

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.rightBarButtonItem = nil;
    // Do any additional setup after loading the view.
    self.arrayHotCity = [NSMutableArray arrayWithObjects:@"广州市",@"北京市",@"天津市",@"西安市",@"重庆市",@"沈阳市",@"青岛市",@"济南市",@"深圳市",@"长沙市",@"无锡市", nil];
    self.arrayCitys = [NSMutableArray array];
    
    ////解决城市定位失败处理，模拟器会一直锁屏问题
    [self.navigationItem addNavTitle:@"选择城市" withTitleColor:kWhiteColor];
    
    self.view.backgroundColor = kWhiteColor;
    
    _searchBar = [[SelectCitySearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 51)];
    [_searchBar.searchField setFrame:CGRectMake(44, 5, _searchBar.frame.size.width-44-34, 24)];
    _searchBar.searchField.delegate = self;
    _searchBar.searchField.placeholder = @"输入城市名或首字母";
    [self.view addSubview:_searchBar];
    
    [_searchBar.searchField addTarget:self action:@selector(textFieldEditChanged:) forControlEvents:UIControlEventEditingChanged];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchBar.frame), self.view.width, self.view.height-CGRectGetMaxY(_searchBar.frame)) style:UITableViewStylePlain];
    _tableView.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
    _tableView.backgroundColor = kClearColor;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self getCitiesData];
}

#pragma mark - 获取城市数据
-(void)getCitiesData
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"CITY_FILE" ofType:nil];
    NSData *cityData = [NSData dataWithContentsOfFile:filePath];
    
    NSDictionary *dic = [cityData jsonValue];
    NSArray *data = [dic arrayForKey:@"data"];
    [_arrayCitys addObjectsFromArray:data];
    [self constructDataSource];
}

-(void)constructDataSource
{
    self.keys = [NSMutableArray array];
    //构造城市列表数据
    self.citiesForSearch =[NSMutableDictionary dictionary];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"citydict"
                                                   ofType:@"plist"];
    self.cities = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    [self.keys addObjectsFromArray:[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)]];
    
    //添加热门城市
    NSString *strHot = @"常";
    [self.keys insertObject:strHot atIndex:0];
    [self.cities setObject:_arrayHotCity forKey:strHot];
    
    for (NSString *key in self.cities.allKeys) {
        [_citiesForSearch setObject:[self.cities valueForKey:key] forKey:key];
    }
    
    [_tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 20)];
    bgView.backgroundColor = RGBSAMECOLOR(234);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, 0, MAINSCREEN_WIDTH, 20)];
    titleLabel.backgroundColor = kClearColor;
    titleLabel.textColor = [YBGeneralColor themeColor];
    titleLabel.font = kFontSize(12);
    
    NSString *key = [_keys objectAtIndex:section];
    if ([key rangeOfString:@"常"].location != NSNotFound) {
        titleLabel.text = @"热门城市";
    }
    else
        titleLabel.text = key;
    
    [bgView addSubview:titleLabel];
    
    return bgView;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return _keys;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar.searchField resignFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [_keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSString *key = [_keys objectAtIndex:section];
    NSArray *citySection = [_cities objectForKey:key];
    return [citySection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    for(UIView *view in [tableView subviews])
    {
        if([[[view class] description] isEqualToString:@"UITableViewIndex"])
        {
            [view performSelector:@selector(setIndexColor:) withObject:[YBGeneralColor themeColor]];
        }
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        UIView *imgBg = [[UIView alloc] initWithFrame:cell.frame];
        [imgBg setBackgroundColor:[YBGeneralColor themeColor]];
        [cell setSelectedBackgroundView:imgBg];
        [cell.textLabel setHighlightedTextColor:[UIColor blackColor]];
        
    } else {
        for (UIView *view in cell.contentView.subviews) {
            if (view.tag == 1000) {
                [view removeFromSuperview];
            }
        }
    }
    [cell.textLabel setTextColor:RGBSAMECOLOR(3)];
    cell.textLabel.font = kFontSize(18);
    cell.textLabel.text = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    [cell.contentView bringSubviewToFront:cell.textLabel];
    
    //标识定位城市
    if (_currentLocationCity && [cell.textLabel.text rangeOfString:_currentLocationCity].location != NSNotFound) {
        UILabel *label_ = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 120, 42)];
        label_.tag = 1000;
        [label_ setText:@"定位城市"];
        [label_ setFont:[UIFont systemFontOfSize:14]];
        [label_ setTextColor:RGBCOLOR(244, 75, 135)];
        [label_ setBackgroundColor:kClearColor];
        [cell.textLabel setTextColor:RGBCOLOR(244, 75, 135)];
        [cell.contentView addSubview:label_];
    }
    
    return cell;
}

-(void)setIndexColor:(UIColor *)color
{
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *key = [_keys objectAtIndex:indexPath.section];
    NSString *city = [[_cities objectForKey:key] objectAtIndex:indexPath.row];
    

    
    ////标记已经成功定位当前位置
    SetUserBoolKeyWithObject(kIsGetCurrentCity, YES);
    SetUserDefaultKeyWithObject(kLocationCity, city);
    UserDefaultSynchronize;
    
    if (self.didSelectCity) {
        self.didSelectCity(city);
        //.clickSectionBlock = ^(NSInteger sec){
    }
    
    ////必须要选择完城市后，方可进入首页
    [self.navigationController popViewControllerAnimated:YES];

}

- (void)textFieldEditChanged:(UITextField *)textField
{
    NSString *searchText = textField.text;
    
    if (![NSString isValueNSStringWith:searchText]) {
        [self filterSearchByKey:searchText];
    }else
    {
        [self constructDataSource];
    }
    [_tableView reloadData];
    if (_keys.count>0) {
        [_tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSString *searchText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (![NSString isValueNSStringWith:searchText]) {
        [self filterSearchByKey:searchText];
    }else
    {
        [self constructDataSource];
    }
    [_tableView reloadData];
    
    return YES;
}

#pragma mark - 搜索城市
-(void)filterSearchByKey:(NSString *)searchKey;
{
    //构造数据源
    self.cities = [NSMutableDictionary dictionary];
    NSInteger count = [_arrayCitys count];
    for (int i=0; i < count; i++) {
        NSDictionary *dic = [_arrayCitys objectAtIndex:i];
        NSString *name = [dic objectForKey:@"name"];
        char key = pinyinFirstLetter([name characterAtIndex:0]);
        NSString *key_ = [[NSString stringWithFormat:@"%c",key] uppercaseString];
        NSMutableArray *arr = [self.cities objectForKey:key_];
        if (!arr) {
            arr = [NSMutableArray array];
            if (![arr containsObject:name] && ([name rangeOfString:searchKey].location != NSNotFound || [key_ isEqualToString:[searchKey uppercaseString]])) {
                [arr addObject:name];
                [self.cities setValue:arr forKey:key_];
            }
            
        }else
        {
            if (![arr containsObject:name] && ([name rangeOfString:searchKey].location != NSNotFound || [key_ isEqualToString:[searchKey uppercaseString]])) {
                [arr addObject:name];
                [self.cities setValue:arr forKey:key_];
            }
        }
    }
    self.keys = (NSMutableArray *)[[self.cities allKeys] sortedArrayUsingSelector:@selector(compare:)];
    [_tableView reloadData];
}
@end
