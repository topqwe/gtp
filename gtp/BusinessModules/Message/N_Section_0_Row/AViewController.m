//
//  AViewController.m
//  SegmentController
//
//  Created by mamawang on 14-6-6.
//  Copyright (c) 2014年 WIQ. All rights reserved.
//

#import "AViewController.h"
#import "ACell.h"
#import "KLSwitch.h"
@interface AViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UITableView* mTableView;
    NSMutableArray* treasureArr;
}

@end

@implementation AViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _isOpenNotification=YES;//⚠
        treasureArr =[NSMutableArray array];//⚠
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //获取推送设置:成功通过bool@"switch"|失败默认YES<---_isOpenNotification

    self.view.backgroundColor= kWhiteColor;
    
    mTableView=[[UITableView alloc]initWithFrame:self.view.frame];
//    mTableView.contentSize=CGSizeMake(320, self.view.frame.size.height+120);
    [self.view addSubview:mTableView];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin |UIViewAutoresizingFlexibleTopMargin;
    mTableView.backgroundView = nil;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = [UIColor clearColor];
    if ([mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [mTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    
    NSArray* arr;
    NSDictionary* mmKnow=@{@"icon": @"renwu6",@"name":@"A",@"type":@(MMKnow)};
    arr =[NSArray arrayWithObjects:mmKnow, nil];
    [treasureArr addObject:arr];
    
    NSDictionary* shoppingList=@{@"icon": @"renwu5",@"name":@"B",@"type":@(ShoppingList)};
    arr =[NSArray arrayWithObjects:shoppingList, nil];
    [treasureArr addObject:arr];
    
    NSDictionary* angleBox=@{@"icon": @"renwu4",@"name":@"C",@"type":@(AngleBox)};
    arr = [NSArray arrayWithObjects:angleBox, nil];
    [treasureArr addObject:arr];
    
    NSDictionary* genderMaker=@{@"icon": @"renwu3",@"name":@"D",@"type":@(GenderMaker)};
    arr = [NSArray arrayWithObjects:genderMaker, nil];
    [treasureArr addObject:arr];
    
    NSDictionary* pregnantWeightGuider=@{@"icon": @"renwu2",@"name":@"E",@"type":@(PregnantWeightGuider)};
    arr = [NSArray arrayWithObjects:pregnantWeightGuider, nil];
    [treasureArr addObject:arr];
    
    NSDictionary* bCListExplain=@{@"icon": @"renwu1",@"name":@"F",@"type":@(BCListExplain)};
    arr = [NSArray arrayWithObjects:bCListExplain, nil];
    [treasureArr addObject:arr];
    
    NSString *description = [NSString stringWithFormat:@"当前缓存:%@",[self folderSize]];
    NSDictionary* babyWeightCounter=@{@"icon": @"renwu0",@"name":@"G",@"description":description,@"type":@(BabyWeightCounter)};
    arr = [NSArray arrayWithObjects:babyWeightCounter, nil];
    [treasureArr addObject:arr];
    
    
}
#pragma mark - 获取推送设置



- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //self.keyBoard_Block();
    //不加这句会出错的 上划会消失
}

#pragma mark - tableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 15)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return treasureArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return ((NSArray*)[treasureArr objectAtIndex:section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString* CellIdentifier=@"ACell";
    ACell* cell=(ACell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        NSArray* arr=[[NSBundle mainBundle]loadNibNamed:@"ACell" owner:self options:nil];
        cell =arr[0];
//        UINib* nib=[UINib nibWithNibName:@"TreasureBoxCell" bundle:nil];
//        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
//         cell=(TreasureBoxCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        UIImageView *sep = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, MAINSCREEN_WIDTH, 1)];
        sep.image = [UIImage imageNamed:@"timeflow_sep"];
        [cell addSubview:sep];
        
        UIImageView *sept = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, MAINSCREEN_WIDTH, 1)];
        sept.image = [UIImage imageNamed:@"timeflow_sep"];
        [cell addSubview:sept];
        
        cell.switchView=[[KLSwitch alloc]initWithFrame:CGRectMake(246, 4, 53, 33)];
        [cell.switchView setOn:YES animated:NO];
        [cell.switchView setOnTintColor:RGBCOLOR(242, 111, 165)];
        [cell.switchView setContrastColor:RGBCOLOR(241, 237, 234)];
        cell.switchView.hidden = YES;
        [cell.contentView addSubview:cell.switchView];
    }
    NSArray* arr=treasureArr[indexPath.section];
    NSDictionary* dic=arr[indexPath.row];
    NSInteger type=[[dic objectForKey:@"type"]integerValue];

    cell.imgv_icon.image = [UIImage imageNamed:[dic objectForKey:@"icon"]];
    cell.lb_name.text = [dic objectForKey:@"name"];
    
    
    if (type==BabyWeightCounter) {
        cell.descriptionLabel.text=[dic objectForKey:@"description"];//
        cell.descriptionLabel.hidden=NO;
        //cell.imgv_accessory.hidden=YES;
    }else{
        cell.descriptionLabel.hidden=YES;
    }
    
    if (type==BCListExplain) {
        __weak KLSwitch* wswitch=cell.switchView;
        
        WS(weakSelf);
        [cell.switchView setDidChangeHandler:^(BOOL isOn){
            //通过post或get方法改变 开或关<----
            [weakSelf changeSwitch:wswitch];
        }];
        cell.switchView.hidden=NO;//
        cell.switchView.on=_isOpenNotification;
    }else{
        cell.switchView.hidden = YES;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray* arr = treasureArr[indexPath.section];
    NSDictionary* dic = arr[indexPath.row];
    NSInteger type = [[dic objectForKey:@"type"]integerValue];
    switch (type) {
        case MMKnow:{
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                          message:@"A"
                                                         delegate:self
                                                cancelButtonTitle:@"确定"
                                                otherButtonTitles:nil];
            [alert show];
            
        }
            break;
        case BabyWeightCounter:{
            UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:@"是否清除缓存？"
                                                          delegate:self
                                                 cancelButtonTitle:@"否"
                                                 otherButtonTitles:@"是",nil];

//            [self clearCacheEventWithIndex:indexPath];
            [alert show];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 清除缓存容量
-(void)clearCacheEventWithIndex:(NSIndexPath *)index
{
//    [restfulEngine emptyCache];
//    [[SDImageCache sharedImageCache] clearDisk];
//    [[SDImageCache sharedImageCache] clearMemory];
//    
//    PHSettingCell *cell=(PHSettingCell *)[_tableView cellForRowAtIndexPath:index];
//    cell.descriptionLabel.text = @"当前缓存:0MB";
    ACell* cell=(ACell*)[mTableView cellForRowAtIndexPath:index];
    cell.descriptionLabel.text=@"已清空";
}
#pragma mark - AlertViewDelegate
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
    }else{
        UIAlertView*alert = [[UIAlertView alloc]initWithTitle:@"清理中..."
                                                      message:nil
                                                     delegate:self
                                            cancelButtonTitle:nil
                                            otherButtonTitles:nil];
        [alert show];
        NSIndexPath* indexPath=[NSIndexPath indexPathForRow:0 inSection:6];//⚠
        [self clearCacheEventWithIndex:indexPath];
//        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//        // Adjust the indicator so it is up a few pixels from the bottom of the alert
//        indicator.center = CGPointMake(alert.bounds.size.width/2.0f, alert.bounds.size.height-40.0f);
//        indicator.hidesWhenStopped = NO;
//        [indicator startAnimating];
//        [alert addSubview:indicator];
        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                         target:self
                                       selector:@selector(dismissAlert:)
                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:alert, @"alert",nil]
                                        repeats:NO];

    }
}
-(void) dismissAlert:(NSTimer *)timer{
    UIAlertView *alert = [[timer userInfo]  objectForKey:@"alert"];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [timer invalidate];
}

#pragma mark - 获取缓存容量
- (NSString *)folderSize{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *folderPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"/Caches/MKNetworkKitCache"];
    
    NSArray *filesArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:folderPath error:nil];
    NSEnumerator *filesEnumerator = [filesArray objectEnumerator];
    NSString *fileName;
    unsigned long long int fileSize = 0;
    
    while (fileName = [filesEnumerator nextObject]) {
        NSDictionary *fileDictionary = [[NSFileManager defaultManager] attributesOfItemAtPath:[folderPath stringByAppendingPathComponent:fileName] error:nil];
        fileSize += [fileDictionary fileSize];
    }
    
    NSString*sizeTypeW = @"bytes";
    
    if(fileSize<1){
        return @"0 MB";
    }else{
        if (fileSize > 1024)
        {
            //Kilobytes
            fileSize = fileSize / 1024;
            sizeTypeW = @" KB";
        }
        if (fileSize > 1024)
        {
            //Megabytes
            fileSize = fileSize / 1024;
            sizeTypeW = @" MB";
        }
        if (fileSize > 1024)
        {
            //Gigabytes
            fileSize = fileSize / 1024;
            sizeTypeW = @" GB";
        }
        return [NSString stringWithFormat:@"%lld%@",fileSize,sizeTypeW];
    }
}
#pragma mark - 修改推送设置
- (void)changeSwitch:(KLSwitch *)button
{
    
}
@end
