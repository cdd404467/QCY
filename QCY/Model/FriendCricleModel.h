//
//  FriendCricleModel.h
//  QCY
//
//  Created by i7colors on 2018/11/25.
//  Copyright © 2018 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendCricleModel : NSObject
@property (nonatomic, copy)NSString *postUserPhoto;             //发帖人头像，如果为null则设置默认头像
@property (nonatomic, copy)NSString *postUser;                  //发帖人
@property (nonatomic, copy)NSString *userId;                  //发帖人ID
@property (nonatomic, copy)NSString *content;                   //正文
@property (nonatomic, copy)NSString *pic1;                      //图片
@property (nonatomic, copy)NSString *pic2;
@property (nonatomic, copy)NSString *pic3;
@property (nonatomic, copy)NSString *pic4;
@property (nonatomic, copy)NSString *pic5;
@property (nonatomic, copy)NSString *pic6;
@property (nonatomic, copy)NSString *pic7;
@property (nonatomic, copy)NSString *pic8;
@property (nonatomic, copy)NSString *pic9;
@property (nonatomic, assign)CGFloat pic1Width;                 //第一张图片的宽
@property (nonatomic, assign)CGFloat pic1High;                  //第一张图片的高
@property (nonatomic, copy)NSString *createdAtStamp;            //发帖时间戳
@property (nonatomic, copy)NSString *isDyeV;                    //是否已经是大V认证，0没有，1已认证
@property (nonatomic, copy)NSString *isLike;                    //是否已点赞，0,未点赞，1 已点赞
@property (nonatomic, copy)NSString *isFollow;                  //是否已关注，0未关注，1已关注
@property (nonatomic, copy)NSString *isCharger;                 //是否本人发帖，0，不是；1是
@property (nonatomic, copy)NSMutableArray *likeList;            //点赞人的信息数组
@property (nonatomic, copy)NSMutableArray *commentList;         //评论人的数组
@property (nonatomic, copy)NSString *tieziID;                   //发布每条帖子的ID
@property (nonatomic, copy)NSString *type;                      //帖子类型：video视频，photo图片
@property (nonatomic, copy)NSString *videoPicUrl;               //视频第一帧图片地址
@property (nonatomic, assign)CGFloat videoPicWidth;             //视频第一帧图片的宽
@property (nonatomic, assign)CGFloat videoPicHigh;              //视频第一帧图片的高
@property (nonatomic, copy)NSString *url;                       //视频地址
@property (nonatomic, copy)NSString *bossLevel;                 //大佬等级
@property (nonatomic, copy)NSString *userNickName;              //昵称
@property (nonatomic, copy)NSString *userCommunityPhoto;        //粉丝头像

// 显示'全文'/'收起'
@property (nonatomic, assign)BOOL isFullText;
//缓存cell的高度
@property (nonatomic, assign)CGFloat cellHeight;


@end

//点赞信息集合
@interface LikeListModel : NSObject

@property (nonatomic, copy)NSString *likeUserPhoto;             //点赞人的头像
@end

//评论信息集合
@interface CommentListModel : NSObject
@property (nonatomic, copy)NSString *content;                   //评论内容
@property (nonatomic, copy)NSString *commentUser;               //评论人
@property (nonatomic, copy)NSString *byCommentUser;             //被评论人
@property (nonatomic, copy)NSString *commentID;                 //评论的ID
@end


@interface FriendCricleInfoModel : NSObject
@property (nonatomic, copy)NSString *isFollow;                  //是否已关注
@property (nonatomic, copy)NSString *nickName;                  //用户昵称
@property (nonatomic, copy)NSString *communityPhoto;            //用户头像
@property (nonatomic, copy)NSString *isDyeV;                    //是否大V认证
@end

NS_ASSUME_NONNULL_END

