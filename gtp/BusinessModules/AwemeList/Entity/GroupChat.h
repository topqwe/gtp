//
//  GroupChat.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
#import "Visitor.h"
#import "PictureInfo.h"

@protocol GroupChat;

@interface GroupChat :BaseModel
@property (nonatomic, assign) BOOL  no_read;
@property (nonatomic, copy) NSString*  user_id;
@property (nonatomic, assign) NSInteger  to_user_id;
@property (nonatomic, copy) NSString* to_user_nickname;
@property(nonatomic,strong)NSString * avatar;//new用户头像

@property (nonatomic , copy) NSString              *id;
@property (nonatomic , copy) NSString              *type;
@property (nonatomic , copy) NSString              *msg_type;
@property (nonatomic , copy) NSString              *content;
@property (nonatomic , copy) NSString              *msg_content;
@property (nonatomic , strong) Visitor             *visitor;
@property (nonatomic , strong) PictureInfo         *pic_original;
@property (nonatomic , strong) PictureInfo         *pic_large;
@property (nonatomic , strong) PictureInfo         *pic_medium;
@property (nonatomic , strong) PictureInfo         *pic_thumbnail;
@property (nonatomic , copy) NSString*           created_at;
@property (nonatomic , assign) NSInteger           create_time;


//处理聊天所需数据
@property (nonatomic , assign) NSInteger                    taskId;
@property (nonatomic , assign) BOOL                         isTemp;
@property (nonatomic , assign) BOOL                         isFailed;
@property (nonatomic , assign) BOOL                         isCompleted;
@property (nonatomic , assign) CGFloat                      percent;
@property (nonatomic , strong) UIImage                      *picImage;
@property (nonatomic , assign) CGSize                       contentSize;
@property (nonatomic , assign) CGFloat                      cellHeight;
@property (nonatomic , strong) NSMutableAttributedString    *cellAttributedString;

-(instancetype)initImageChat:(UIImage *)image;

-(instancetype)initTextChat:(NSString *)text;

-(instancetype)updateTempImageChat:(GroupChat *)chat;

-(instancetype)updateTempTextChat:(GroupChat *)chat;

@end
