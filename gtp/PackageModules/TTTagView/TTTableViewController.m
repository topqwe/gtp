//
//  TTTableViewController.m
//  TTTagView_Example
//
//  Created by 王家强 on 2020/6/30.
//  Copyright © 2020 icofans. All rights reserved.
//

#import "TTTableViewController.h"
#import "TTTableViewCell.h"

@interface TTTableViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation TTTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = UITableViewAutomaticDimension;
       _tableView.estimatedRowHeight = 80;
       [_tableView registerClass:[TTTableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    [self.view addSubview:_tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
//    [cell setCellInfo:@[@"林俊杰",@"张学友",@"刘德华",@"陶喆",@"王力宏",@"王菲",@"Taylor swift",@"周杰伦",@"owl city",@"汪苏泷",@"许嵩",@"李代沫",@"那英",@"羽泉",@"刀郎",@"田馥甄",@"庄心妍",@"林宥嘉",@"薛之谦",@"萧敬腾",@"王若琳"]];
    
    if (indexPath.row == 1) {
    [cell setCellInfo:@[@"林俊"]];
    }else if(indexPath.row == 2){
    [cell setCellInfo:@[@"林俊杰"]];
    }else{
    [cell setCellInfo:@[@"林俊杰",@"张学友",@"刘德华",@"陶喆",@"王力宏",@"王菲",@"Taylor swift",@"周杰伦",@"owl city",@"汪苏泷",@"许嵩",@"李代沫",@"那英",@"羽泉",@"刀郎",@"田馥甄",@"庄心妍",@"林宥嘉",@"薛之谦",@"萧敬腾",@"王若琳"]];
    }
    
    return cell;
}



- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    // UITableViewAutomaticDimension不会自动在外部frame变化时刷新，所以手动reload下
    [_tableView reloadData];
}


@end
