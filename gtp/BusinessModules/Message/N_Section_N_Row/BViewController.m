//
//  BViewController.m
//  SegmentController
//
//  Created by mamawang on 14-6-6.
//  Copyright (c) 2014年 WIQ. All rights reserved.
//

#import "BViewController.h"

@interface BViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSMutableArray* dataArray;
    UITableView *mTableView;
}

@end

@implementation BViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = kWhiteColor;
    
    NSArray *a1 = [NSArray arrayWithObjects:@"Inviting", nil];
    NSArray *a2 = [NSArray arrayWithObjects:@"QR code",@"Favorite", nil];
    NSArray *a3 = [NSArray arrayWithObjects:@"About",@"Feedback",@"Update", nil];
    dataArray = [NSMutableArray arrayWithObjects:a1,a2,a3, nil];
    
    mTableView = [[UITableView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:mTableView];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    mTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    mTableView.backgroundView = nil;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = [UIColor clearColor];
    if ([mTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [mTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [mTableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
    v.backgroundColor = [UIColor clearColor];
    return v;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *a =[dataArray objectAtIndex:section];
    return a.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        cell = [[BCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        
        
        //cell.backgroundColor=[UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        [cell.textLabel setHighlighted:NO];
        
        UIImageView *accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(MAINSCREEN_WIDTH-24, 13, 24, 24)];
        accessoryView.image = [UIImage imageNamed:@"accessory"];
        [cell.contentView addSubview:accessoryView];
        
        
        UIImageView *sep = [[UIImageView alloc] initWithFrame:CGRectMake(0, 49, MAINSCREEN_WIDTH, 1)];
        sep.image = [UIImage imageNamed:@"timeflow_sep"];
        [cell addSubview:sep];
        
        UIImageView *sept = [[UIImageView alloc] initWithFrame:CGRectMake(0, -1, MAINSCREEN_WIDTH, 1)];
        sept.image = [UIImage imageNamed:@"timeflow_sep"];
         [cell addSubview:sept];
        
    }
    
    NSArray *a =[dataArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [a objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"more_small_icon_%ld_%ld",(long)indexPath.section, (long)indexPath.row]];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [mTableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
        {
            NSLog(@"0_0");
        }
            break;
        case 1:
        {
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"1.0");
                }
                    break;
                case 1:
                {
                    NSLog(@"1.1");
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (indexPath.row) {
                case 0:
                {
                    NSLog(@"2.0");
                }
                    break;
                case 1:
                {
                    NSLog(@"2.1");
                }
                    break;
                case 2:
                {
                    NSLog(@"2.2");
                }
                    break;
                default:
                    break;
            }
        }
        default:
            break;
    }
}
@end
