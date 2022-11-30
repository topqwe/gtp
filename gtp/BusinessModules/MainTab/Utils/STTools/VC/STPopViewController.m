//
//  STPopViewController.m
//  STTools
//
//  Created by apple on 16/5/17.
//  Copyright © 2016年 stoneobs. All rights reserved.
//

#import "STPopViewController.h"
@interface STPopViewController()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>
@property(nonatomic,strong)UITableView              *tableView;
@property(nonatomic,strong)NSArray<NSString*>       *titleAry;
@property(nonatomic,assign)CGFloat                  cellHeight;
@end
@implementation STPopViewController
-(instancetype)initWithArray:(NSArray<NSString *> *)titleAry size:(CGSize)size view:(UIView *)view
{
    if (self=[super init]) {
        
        self.titleAry = titleAry;
        self.tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = self.canScroll;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        //UIPopoverPresentationController
        self.modalPresentationStyle = UIModalPresentationPopover;
        self.preferredContentSize =  CGSizeMake(size.width,self.titleAry.count * 44);
        self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        //设置pop基于控件的位置，因为如果箭头在上面那么默认位置就是控件下边的中线，所以这里用bounds就好
        
        self.popoverPresentationController.backgroundColor = [UIColor clearColor];
        self.popoverPresentationController.delegate = self;
        self.popoverPresentationController.sourceRect = view.bounds;
        self.popoverPresentationController.sourceView = view;
        
        self.cellHeight = 44;
        
        
      
        

    }
    return self;

}
-(void)loadView
{
    [super loadView];
    [self.view addSubview:self.tableView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    CGSize size = self.preferredContentSize;
//    self.preferredContentSize = CGSizeMake(size.width,self.titleAry.count * 44);
    
}
#pragma mark --Geter And Setter
-(void)setDirection:(UIPopoverArrowDirection)direction
{
    if (direction) {
        _direction=direction;
        self.popoverPresentationController.permittedArrowDirections=direction;
    }
}
-(void)setCellColor:(UIColor *)cellColor
{
    if (cellColor) {
        _cellColor=cellColor;
    }
}
-(void)setCanScroll:(BOOL)canScroll
{
    _canScroll=canScroll;
}
#pragma mark ---tableview datasouse and delegate start
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.titleAry.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.PopTableViewdatasouce&&[self.PopTableViewdatasouce respondsToSelector:@selector(popViewController:heightForRowAtIndexPath:)]) {
        self.cellHeight =[self.PopTableViewdatasouce popViewController:self heightForRowAtIndexPath:indexPath];
        return [self.PopTableViewdatasouce popViewController:self heightForRowAtIndexPath:indexPath];

    }
    else{
       
        return self.cellHeight;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01 ;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.PopTableViewdatasouce&&[self.PopTableViewdatasouce respondsToSelector:@selector(popViewController:cellForRowAtIndexPath:)]) {
        return [self.PopTableViewdatasouce popViewController:self cellForRowAtIndexPath:indexPath];
    }
    else{
    
        UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
        cell.textLabel.text=self.titleAry[indexPath.section];
        cell.textLabel.font=[UIFont systemFontOfSize:13];
       
        if (self.imageAry&&self.imageAry.count>0) {
            cell.imageView.image=[UIImage imageNamed:self.imageAry[indexPath.row]];
        }
        if (self.textlabelColor) {
            cell.textLabel.textColor = self.textlabelColor;
        }
        return cell;
    }

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.PopTableViewdelegate&&[self.PopTableViewdelegate respondsToSelector:@selector(popViewController:didSelectRowAtIndexPath:)]) {
        [self.PopTableViewdelegate popViewController:self didSelectRowAtIndexPath:indexPath];
    }
   

    
}
#pragma mark ----UIPopoverPresentationControllerDelegate
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController*)controller{
    //返回UIModalPresentationNone就不是全屏
    return UIModalPresentationNone;
}

@end
