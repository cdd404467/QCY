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

@class FriendTopicModel;
@class ShareBeanModel;
NS_ASSUME_NONNULL_BEGIN

@interface FriendCricleModel : NSObject
@property (nonatomic, copy)NSString *postUserPhoto;             //发帖人头像，如果为null则设置默认头像
@property (nonatomic, copy)NSString *postUser;                  //发帖人
@property (nonatomic, copy)NSString *userId;                    //发帖人ID
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
@property (nonatomic, assign)NSInteger isFollow;                //是否已关注，0未关注，1已关注
@property (nonatomic, assign)NSInteger isCharger;               //是否本人发帖，0，不是；1是
@property (nonatomic, copy)NSString *isSelf;                    //是否本人(粉丝)，0，不是；1是
@property (nonatomic, copy)NSString *isCompanyType;             //是否企业
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
@property (nonatomic, copy)NSString *dyeFollowCount;            //粉丝数量
@property (nonatomic, copy)NSString *companyName;               //如果是企业的话，返回企业名字
@property (nonatomic, copy)NSString *dyeVName;                  //大V认证名称
@property (nonatomic, copy)NSString *locationTitle;             //定位地址title
@property (nonatomic, copy)NSString *locationAddress;           //定位地址subtitle
@property (nonatomic, assign)double longitude;                  //定位经度
@property (nonatomic, assign)double latitude;                   //定位纬度
@property (nonatomic, strong)FriendTopicModel *topic;           //话题
@property (nonatomic, strong)ShareBeanModel *shareBean;         //分享的咨询

// 显示'全文'/'收起'
@property (nonatomic, assign)BOOL isFullText;
//缓存cell的高度
@property (nonatomic, assign)CGFloat cellHeight;

@end


//点赞信息集合
@interface LikeListModel : NSObject
@property (nonatomic, copy)NSString *likeUserPhoto;             //点赞人的头像
@property (nonatomic, copy)NSString *likeUser;                  //点赞人名字
@property (nonatomic, copy)NSString *createdAtStamp;            //点赞时间
@property (nonatomic, copy)NSString *userId;                    //点赞人ID
@property (nonatomic, copy)NSString *isCharger;                 //是否是自己
@end

//评论信息集合
@interface CommentListModel : NSObject
@property (nonatomic, copy)NSString *content;                   //评论内容
@property (nonatomic, copy)NSString *commentUser;               //评论人
@property (nonatomic, copy)NSString *byCommentUser;             //被评论人
@property (nonatomic, copy)NSString *commentID;                 //评论的ID
@property (nonatomic, copy)NSString *isCharger;                 //是否是自己 - 点击评论人
@property (nonatomic, copy)NSString *byCommentIsCharger;        //是否是自己 - 点击被评论人
@property (nonatomic, copy)NSString *createdAtStamp;            //评论时间
@property (nonatomic, copy)NSString *commentPhoto;              //评论人头像
@property (nonatomic, copy)NSString *dyeId;                     //帖子id，跳转详情页
@property (nonatomic, copy)NSString *byUserId;                  //被评论人的ID
@property (nonatomic, copy)NSString *userId;                    //评论人的ID

//帖子详情->缓存cell的高度
@property (nonatomic, assign)CGFloat cellHeight;
@end


@interface FriendCricleInfoModel : NSObject
@property (nonatomic, copy)NSString *isFollow;                  //是否已关注
@property (nonatomic, copy)NSString *nickName;                  //用户昵称
@property (nonatomic, copy)NSString *communityPhoto;            //用户头像
@property (nonatomic, copy)NSString *isDyeV;                    //是否大V认证
@property (nonatomic, copy)NSString *dyeVName;                  //大V认证名称
@property (nonatomic, copy)NSString *companyName;               //没有大V就拿企业名称
@property (nonatomic, copy)NSString *dyeVCreatedAtStamp;        //大V认证时间戳
@property (nonatomic, copy)NSString *isCompanyType;             //是否企业
@property (nonatomic, copy)NSString *isCharger;                 //是否是自己
@property (nonatomic, copy)NSString *bossLevel;                 //大佬等级
@property (nonatomic, copy)NSString *notReadMessageCount;       //未读消息个数

//好友通讯录
@property (nonatomic, copy)NSString *userCommunityPhoto;        //用户头像
@property (nonatomic, copy)NSString *userNickName;              //用户名字
@property (nonatomic, copy)NSString *userId;                    //用户ID

//是否选中好友
@property (nonatomic, assign)BOOL isSelectFriend;
@end

@interface FriendTopicModel : NSObject
@property (nonatomic, copy)NSString *title;                     //话题标题
@property (nonatomic, copy)NSString *parentId;                  //一级话题id
@property (nonatomic, copy)NSString *secondTopicID;             //二级话题ID
@property (nonatomic, copy)NSString *communityNum;              //话题讨论次数
@property (nonatomic, copy)NSString *descriptionStr;            //话题描述
@property (nonatomic, copy)NSArray *topicList;                  //二级数组
@property (nonatomic, copy)NSString *banner;                    //banner

//header height
@property (nonatomic, assign)CGFloat height;                   
@end

@interface ShareBeanModel : NSObject
@property (nonatomic, copy)NSString *title;                     //咨询标题
@property (nonatomic, copy)NSString *pic;                       //咨询图片
@property (nonatomic, copy)NSString *zixunID;                   //咨询ID
@end

@interface ZiMuModel : NSObject
@property (nonatomic, copy)NSArray *a;
@property (nonatomic, copy)NSArray *b;
@property (nonatomic, copy)NSArray *c;
@property (nonatomic, copy)NSArray *d;
@property (nonatomic, copy)NSArray *e;
@property (nonatomic, copy)NSArray *f;
@property (nonatomic, copy)NSArray *g;
@property (nonatomic, copy)NSArray *h;
@property (nonatomic, copy)NSArray *i;
@property (nonatomic, copy)NSArray *j;
@property (nonatomic, copy)NSArray *k;
@property (nonatomic, copy)NSArray *l;
@property (nonatomic, copy)NSArray *m;
@property (nonatomic, copy)NSArray *n;
@property (nonatomic, copy)NSArray *o;
@property (nonatomic, copy)NSArray *p;
@property (nonatomic, copy)NSArray *q;
@property (nonatomic, copy)NSArray *r;
@property (nonatomic, copy)NSArray *s;
@property (nonatomic, copy)NSArray *t;
@property (nonatomic, copy)NSArray *u;
@property (nonatomic, copy)NSArray *v;
@property (nonatomic, copy)NSArray *w;
@property (nonatomic, copy)NSArray *x;
@property (nonatomic, copy)NSArray *y;
@property (nonatomic, copy)NSArray *z;
@property (nonatomic, copy)NSArray *special;
@end


@interface FCMsgModel : NSObject
@property (nonatomic, copy)NSString *postUserPhoto;             //头像
@property (nonatomic, copy)NSString *postUserName;              //昵称
@property (nonatomic, copy)NSString *messageID;                 //消息ID
@property (nonatomic, copy)NSString *postUserIsDyeV;            //是否大V认证
@property (nonatomic, copy)NSString *postUserDyeVName;          //认证名
@property (nonatomic, copy)NSString *postUserIsCompany;         //是否是企业用户
@property (nonatomic, copy)NSString *postUserCompanyName;       //企业名称
@property (nonatomic, copy)NSString *communityId;               //帖子id
@property (nonatomic, copy)NSString *commentText;               //评论内容
@property (nonatomic, assign)NSInteger isRead;                  //是否已读 - 0未读 1已读
@property (nonatomic, copy)NSString *createdAtStamp;            //时间戳
@property (nonatomic, copy)NSString *bossLevel;                 //大佬等级
@property (nonatomic, copy)NSString *type;                      //消息类型 -是请求添加好友还是已经是好友
@property (nonatomic, assign)NSInteger isFollow;                //1 已关注 0 未关注
@property (nonatomic, copy)NSString *postUserId;                //请求的用户ID

@end


@interface MarketModel : NSObject
//店铺logo
@property (nonatomic, copy) NSString *logo;
//联系方式
@property (nonatomic, copy) NSString *phone;
//联系人
@property (nonatomic, copy) NSString *contact;
//描述
@property (nonatomic, copy) NSString *descriptionStr;
@end



@interface FCMapModel : NSObject
//公司名称
@property (nonatomic, copy) NSString *companyName;
//省
@property (nonatomic, copy) NSString *province;
//市
@property (nonatomic, copy) NSString *city;
//省市
@property (nonatomic, copy) NSString *shopArea;
//地址
@property (nonatomic, copy) NSString *address;
//店铺ID
@property (nonatomic, copy) NSString *marketId;
//地图推荐类型(market - 跳转详情，archive不能跳转)
@property (nonatomic, copy) NSString *from;
//目标经度
@property (nonatomic, assign) double longitude;
//目标纬度
@property (nonatomic, assign) double latitude;
//当前经度
@property (nonatomic, assign) double nowLongitude;
//当前纬度
@property (nonatomic, assign) double nowLatitude;


//market数据模型
@property (nonatomic, strong) MarketModel *market;
//距离我当前的位置
@property (nonatomic, copy) NSString *distance;

@end


@interface FCMapNavigationModel : NSObject
//当前经度
@property (nonatomic, assign) double nowLon;
//当前纬度
@property (nonatomic, assign) double nowLat;
//目标经度
@property (nonatomic, assign) double targetLon;
//目标纬度
@property (nonatomic, assign) double targetLat;
//起点位置名称
@property (nonatomic, copy) NSString *startLocationName;
//终点位置名称
@property (nonatomic, copy) NSString *endLocationName;

@end

NS_ASSUME_NONNULL_END

