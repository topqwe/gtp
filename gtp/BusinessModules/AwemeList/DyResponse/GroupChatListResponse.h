//
//  Header.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import "BaseResponse.h"
#import "GroupChat.h"
@interface GroupChatListModel:BaseResponse

@property (nonatomic, copy) NSArray<GroupChat>   *list;

@end
@interface GroupChatListResponse:BaseResponse
@property (nonatomic, assign) BOOL  hasMorePages;
//@property (nonatomic, copy) NSArray<GroupChat>   *data;
@property (nonatomic, strong) GroupChatListModel   *data;
@end
