//
//  AppListVC.h
//  appList
//
//  Created by 007 on 2021/4/11.

#import "AppListVC.h"
@interface UIImage ()
+ (id)_iconForResourceProxy:(id)arg1 variant:(int)arg2 variantsScale:(float)arg3;
+ (id)_applicationIconImageForBundleIdentifier:(id)arg1 format:(int)arg2 scale:(double)arg3;
@end

@interface AppListVC ()

<UITableViewDelegate,UITableViewDataSource
>
@property (nonatomic , strong) UITableView *tableView;
@property (strong, nonatomic)NSMutableArray* arr;
@property (strong, nonatomic)id space;
@end

@implementation AppListVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    AppListVC *vc = [[AppListVC alloc] init];
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStyleGrouped)];
    self.tableView = tableView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 60;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.backgroundColor = [UIColor redColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, 50, 640,560);
 

    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AppCellID"];
    
    [self getAllApps];
}
- (void)getAllApps
{
    self.arr = [NSMutableArray array];
    
    NSMutableArray* system = [NSMutableArray array];
    NSMutableArray* nosystem = [NSMutableArray array];
    id space = [NSClassFromString(@"LSApplicationWorkspace") performSelector:@selector(defaultWorkspace)];
    self.space = space;
    
    
    NSArray *plugins = [space performSelector:@selector(installedPlugins)];
    NSMutableSet *list = [[NSMutableSet alloc] init];
    for (id plugin in plugins) {
        id bundle = [plugin performSelector:@selector(containingBundle)];
        if (bundle)
            [list addObject:bundle];
    }
    int a = 1;
    for (id plugin in list) {
        NSLog(@"🐒 %d--",a);
        a++;
        
//        NSMutableAttributedString *url = [NSMutableAttributedString new];
//        [url appendAttributedString:attrStr];
            
        NSMutableString *url = [NSMutableString string];
        
        //应用的类型是系统还是第三方
        NSLog(@"applicationType =%@", [plugin performSelector:@selector(applicationType)]);
       NSString * type = [plugin performSelector:@selector(applicationType)];
        [url appendString:[NSString stringWithFormat:@"类型:%@",type]];
        
        
        //应用的名称
        NSString *appName = [plugin performSelector:@selector(localizedName)];
        [url appendString:[NSString stringWithFormat:@",名称:%@",appName]];
        
        
        //应用的版本
        NSLog(@"shortVersionString =%@", [plugin performSelector:@selector(shortVersionString)]);
        NSString * shortVersionString = [plugin performSelector:@selector(shortVersionString)];
        [url appendString:[NSString stringWithFormat:@",版本:%@",shortVersionString]];
        
        
        
        //应用的bundleId
        NSLog(@"bundleIdentifier =%@", [plugin performSelector:@selector(bundleIdentifier)]);//bundleID
//            NSLog(@"applicationIdentifier =%@", [plugin performSelector:@selector(applicationIdentifier)]);
        NSString *bundleId = [plugin performSelector:@selector(bundleIdentifier)];
        
        [url appendString:[NSString stringWithFormat:@"\n应用BundleId:%@",bundleId]];
        
        
        if ([type isEqualToString:@"System"]) {
            [system addObject:@{url:bundleId}];
//            continue;
        }else{
            [nosystem addObject:@{url:bundleId}];
        }
        
        
        
//
//        NSLog(@"applicationDSID =%@", [plugin performSelector:@selector(applicationDSID)]);
//
//        NSLog(@"dynamicDiskUsage =%@", [plugin performSelector:@selector(dynamicDiskUsage)]);
//
//        NSLog(@"itemID =%@", [plugin performSelector:@selector(itemID)]);
//        NSLog(@"itemName =%@", [plugin performSelector:@selector(itemName)]);
//        NSLog(@"minimumSystemVersion =%@", [plugin performSelector:@selector(minimumSystemVersion)]);
//
//        NSLog(@"requiredDeviceCapabilities =%@", [plugin performSelector:@selector(requiredDeviceCapabilities)]);
//        NSLog(@"sdkVersion =%@", [plugin performSelector:@selector(sdkVersion)]);
//
//
//        NSLog(@"sourceAppIdentifier =%@", [plugin performSelector:@selector(sourceAppIdentifier)]);
//        NSLog(@"staticDiskUsage =%@", [plugin performSelector:@selector(staticDiskUsage)]);
//        NSLog(@"teamID =%@", [plugin performSelector:@selector(teamID)]);
//        NSLog(@"vendorName =%@", [plugin performSelector:@selector(vendorName)]);
    }
    
    [self.arr addObjectsFromArray:@[nosystem,system]];
    [self.tableView reloadData];
//    NSLog(@"appLists =%@", self.arr);
    return;
    
        
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [UIView new];
    view.backgroundColor = [UIColor greenColor];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSArray* rows = self.arr[section] ;
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppCellID" forIndexPath:indexPath];
    NSDictionary* dic =  self.arr[indexPath.section][indexPath.row];
//    LMApp *app = (LMApp *)self.apps[indexPath.row];
    
//    cell.imageView.image = [UIImage  _applicationIconImageForBundleIdentifier:dic.allValues[0] format:10 scale:2.0];
    
    cell.textLabel.text = dic.allKeys[0];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* dic =  self.arr[indexPath.section][indexPath.row];
    NSString* text = dic.allValues[0];
    if ([self.space respondsToSelector:@selector(openApplicationWithBundleID:)])
        {
            [self.space performSelector:@selector(openApplicationWithBundleID:) withObject:text];
        }
    
//    SEL selector=@selector(uninstallApplication:withOptions:);
//
//    if ([self.space respondsToSelector:selector])
//        {
//            [self.space performSelector:@selector(uninstallApplication:withOptions:) withObject:text withObject:nil];
//        }

}


@end
