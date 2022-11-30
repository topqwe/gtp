//
//  RichTextAdjustTableVC.m
//  TextTest
//
//  Created by ren on 15/10/21.
//  Copyright © 2015年 ren. All rights reserved.
//

#import "RichTextAdjustTableVC.h"
#import "RichTextAdjustTableViewCell.h"

@interface RichTextAdjustTableVC ()
@property(strong,nonatomic) NSArray *tableData;
@end

@implementation RichTextAdjustTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"RichTextAdjustTableViewCell" bundle:nil] forCellReuseIdentifier:@"RichTextAdjustTableViewCell"];
    //去掉多余cell
    self.tableView.tableFooterView = [[UIView alloc]init];
    //去掉返回文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60)
                                                         forBarMetrics:UIBarMetricsDefault];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    RichTextAdjustTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RichTextAdjustTableViewCell" forIndexPath:indexPath];
    [cell presentItem];
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath {
    static RichTextAdjustTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:@"RichTextAdjustTableViewCell"];
    });
    
    [sizingCell presentItem];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

@end
