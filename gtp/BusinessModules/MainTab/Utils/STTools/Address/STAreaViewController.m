//
//  STAreaViewController.m
//  SportHome
//
//  Created by stoneobs on 16/11/11.
//  Copyright © 2016年 zhaowei. All rights reserved.
//

#import "STAreaViewController.h"
#import "STAreaHeaderView.h"
@interface STAreaViewController ()
<UISearchBarDelegate,
UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic,strong)UISearchBar              *sercbar;
@property(nonatomic,strong)NSMutableArray           *dataSouce;
@property(nonatomic,strong)NSMutableArray           *testArray;
@property(nonatomic,strong)UITableView              *tableView;
@property(nonatomic,assign)bool isBengSerch;//查询状态
@property(nonatomic,strong)NSMutableArray           *serCharray;
@property(nonatomic,strong)STAreaHeaderView         *header;
@property(nonatomic,strong)NSMutableArray           *noSpaceArray;//删除空格数组
@end

@implementation STAreaViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakSelf = self;
    self.tableView = [[UITableView alloc] initWithFrame:SCREEN_FRAME style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.tableView.backgroundColor = BACKROUND_COLOR;
    self.tableView.sectionIndexColor = TM_ThemeBackGroundColor;
    self.tableView.sectionIndexBackgroundColor = BACKROUND_COLOR;
    self.header = [[STAreaHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 300)];
    self.header.hotNameArray = @[@"北京",@"上海",@"成都",@"武汉",@"广州",@"深圳",@"杭州",@"南宁",@"长沙",@"辽宁",@"拉萨",@"南京",@"天津"];
    [self.header setBlock:^(NSString *chosedTitle) {
        NSLog(@"%@",chosedTitle);
        if (weakSelf.block) {
            weakSelf.block(chosedTitle);
        }
        
        [weakSelf.sercbar endEditing:YES];
         [weakSelf dismiss];
    }];
    self.tableView.tableHeaderView = self.header;
    [self.view addSubview:self.tableView];
    
    
    
    _sercbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-110, 40)];
    _sercbar.placeholder = @"输入城市名称";
    _sercbar.searchBarStyle = UISearchBarStyleMinimal;
    _sercbar.delegate = self;
    self.navigationItem.titleView = _sercbar;
    
    [self configRightBar];
    
    self.dataSouce = [NSMutableArray new];
    self.testArray = [NSMutableArray new];
    NSURL * url = [[NSBundle mainBundle] URLForResource:@"STTools.bundle/STFiles/noSpace" withExtension:@".plist"];
    NSArray * array = [NSArray arrayWithContentsOfURL:url];
    self.dataSouce = [NSMutableArray arrayWithArray:array];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = nil;
}
- (void)configRightBar{
    
    STButton * buyButton = [[STButton alloc] initWithFrame:CGRectMake(0, 0, 40, _sercbar.height)
                                                     title:@"取消"
                                                titleColor:FlatOrange
                                                 titleFont:19
                                              cornerRadius:0
                                           backgroundColor:nil
                                           backgroundImage:nil
                                                     image:nil];
    buyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    buyButton.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
    [self st_setRightItemWithView:buyButton];
}
- (void)setLocationCityStr:(NSString *)locationCityStr{
    _locationCityStr = locationCityStr;
    self.header.currenrLocationAddress = locationCityStr;
}
#pragma mark --Action Method
- (void)st_rightBarAction:(id)sender{
   [self dismiss];
}
#pragma mark --Private Method
//去掉空格生成文件
-(void)deleteSpace
{
    self.noSpaceArray = [NSMutableArray new];
    for (int i =0; i<self.dataSouce.count; i++) {
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray * cityarray = [NSMutableArray new];
        NSArray * citys = [self.dataSouce[i] valueForKey:@"city"];
        for (NSDictionary * city in citys) {
            NSArray * pingyingArray = [[city valueForKey:@"pingying"] componentsSeparatedByString:@" "];
            NSString * pingying = pingyingArray.firstObject;
            for (int k = 1; k<pingyingArray.count; k++) {
                pingying = [NSString stringWithFormat:@"%@%@",pingying,pingyingArray[k]];
            }
            NSDictionary * myareadic = @{@"area":[city valueForKey:@"area"],@"pingying":pingying};
            
            [cityarray addObject:myareadic];
        }
        NSDictionary * dic = @{@"begin":[self.dataSouce[i] valueForKey:@"begin"],@"city":cityarray};
        [self.noSpaceArray addObject:dic];
        // NSLog(@"第%d个----------已经成功删除",i);
        //        });
    }
    
}
-(void)serchWith:(NSString*)title
{
    self.serCharray = [NSMutableArray new];
    NSInteger  index;
    if (title.length==0) {
        return;//如果搜索为空退出
    }
    title = [title uppercaseString];
    
    NSString * pingyingTitle = [self transform:title];
    int count = self.dataSouce.count;
    for (int i = 0; i < count ; i++) {
        NSDictionary * dic = self.dataSouce[i];
        NSString * begin = [dic valueForKey:@"begin"];
        if ([begin isEqualToString:[title substringToIndex:1]]||[begin isEqualToString:[pingyingTitle substringToIndex:1]]) {
            index = i;
            break ;
        }
        
    }
    if (index>self.dataSouce.count) {
        return;
    }
    NSDictionary * arrdic = self.dataSouce[index];
    NSArray * cityArray = [arrdic valueForKey:@"city"];
    for (NSDictionary * dic in cityArray) {
        NSString * pingying = [dic valueForKey:@"pingying"];
        NSString * area = [dic valueForKey:@"area"];
        // NSLog(@"%@---%@",pingying,area);
        if ([self charaisInsting:pingying title:title]||[self charaisInsting:area title:title]) {
            [self.serCharray addObject:dic];
        }
    }
    
    [self.tableView reloadData];
    
    
}
- (BOOL)charaisInsting:(NSString*)pingyin title:(NSString*)title
{
    
    if (pingyin.length<title.length) {
        return NO;
    }
    NSString * substing = [pingyin substringToIndex:title.length];
    if ([substing isEqualToString:title]) {
        return YES  ;
    }
    return NO;
    
}
- (void)sortArray
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL * url = [[NSBundle mainBundle] URLForResource:@"myarea" withExtension:@".plist"];
        NSArray * array = [NSArray arrayWithContentsOfURL:url];
        self.dataSouce = [NSMutableArray arrayWithArray:array];
        [self asnyFrom:@"A"];
        [self asnyFrom:@"B"];
        [self asnyFrom:@"C"];
        [self asnyFrom:@"D"];
        [self asnyFrom:@"E"];
        [self asnyFrom:@"F"];
        [self asnyFrom:@"G"];
        [self asnyFrom:@"H"];
        [self asnyFrom:@"I"];
        [self asnyFrom:@"J"];
        [self asnyFrom:@"K"];
        [self asnyFrom:@"L"];
        [self asnyFrom:@"M"];
        [self asnyFrom:@"N"];
        [self asnyFrom:@"O"];
        [self asnyFrom:@"P"];
        [self asnyFrom:@"Q"];
        [self asnyFrom:@"R"];
        [self asnyFrom:@"S"];
        [self asnyFrom:@"T"];
        [self asnyFrom:@"U"];
        [self asnyFrom:@"V"];
        [self asnyFrom:@"W"];
        [self asnyFrom:@"X"];
        [self asnyFrom:@"Y"];
        [self asnyFrom:@"Z"];
    });
}
-(void)asnyFrom:(NSString*)str
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray * strarray = [NSMutableArray new];
        for (NSDictionary * dic in self.dataSouce) {
            NSString * pingying = [dic valueForKey:@"pingying"];
            NSString * begin = [pingying substringToIndex:1];
            if ([begin isEqualToString:str]) {
                
                [strarray addObject:dic];
            }
        }
        NSMutableDictionary *  dic  = [NSMutableDictionary new];
        [dic setValue:str forKey:@"begin"];
        [dic setValue:strarray forKey:@"city"];
        [self.testArray addObject:dic];
        NSLog(@"%@已经排序完毕",str);
    });
    
}
- (NSString *)transform:(NSString *)chinese
{
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSLog(@"%@", pinyin);
    return [pinyin uppercaseString];
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSLog(@"%@",searchText);
    self.isBengSerch = YES;
    [self serchWith:searchText];
    if (searchText.length == 0) {
        self.isBengSerch = NO;
        [self.tableView reloadData];
    }
}


#pragma --mark tableview datasouce
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isBengSerch) {
        return 1;
    }
    return self.dataSouce.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isBengSerch) {
        return self.serCharray.count;
    }
    return [[self.dataSouce[section] valueForKey:@"city"] count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (self.isBengSerch) {
        return @"搜索结果";
    }
    return   [self.dataSouce[section] valueForKey:@"begin"];
    
}
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (self.isBengSerch) {
        return nil;
    }
    return @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * reuseIdentifier =  @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    
    if (self.isBengSerch) {
        cell.textLabel.text = [self.serCharray[indexPath.row] valueForKey:@"area"];
    }
    else if ([self.dataSouce.firstObject isKindOfClass:[NSDictionary class]]) {
        NSArray * sectionArray = [self.dataSouce[indexPath.section] valueForKey:@"city"];
        cell.textLabel.text = [sectionArray[indexPath.row] valueForKey:@"area"];
    }
    cell.textLabel.textColor = FirstTextColor;
    cell.backgroundColor = BACKROUND_COLOR;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}
#pragma --mark tableview delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.sercbar endEditing:YES];
    UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (self.block) {
        self.block(cell.textLabel.text);
    }
    [self dismiss];
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)dismiss{
    if (self.navigationController.presentationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
       [self.navigationController popViewControllerAnimated:YES];
    }
}
@end

