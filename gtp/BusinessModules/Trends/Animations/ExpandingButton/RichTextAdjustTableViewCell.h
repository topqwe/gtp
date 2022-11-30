//
//  TableViewCell.h
//  TextTest
//
//  Created by ren on 15/10/21.
//  Copyright © 2015年 ren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RichTextAdjustTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTest;
-(void)presentItem;
@end
