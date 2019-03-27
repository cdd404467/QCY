//
//  VoteModel.h
//  QCY
//
//  Created by i7colors on 2019/2/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface VoteModel : NSObject
@property (nonatomic, copy)NSString *banner;                    //图片
@property (nonatomic, copy)NSString *name;                      //活动名字
@property (nonatomic, copy)NSString *applicationNum;            //参赛数量
@property (nonatomic, copy)NSString *joinNum;                   //投票数量
@property (nonatomic, copy)NSString *clickNum;                  //访问量
@property (nonatomic, copy)NSString *endCode;                   //活动状态码，0,：未开始；1,：进行中，2：已结束
@property (nonatomic, copy)NSString *detailID;                  //详情id
@property (nonatomic, assign)long long endTimeStamp;            //结束时间戳
@property (nonatomic, copy)NSArray *ruleList;                   //规则数组
@property (nonatomic, copy)NSArray<NSString *> *detailList;
@property (nonatomic, assign)CGFloat cellHeight;
@end

@interface RuleListModel : NSObject
@property (nonatomic, copy)NSString *key;                       //规则标题
@property (nonatomic, copy)NSString *value;                     //规则内容

@property (nonatomic, assign)CGFloat cellHeight;
@end

@interface VoteUserModel : NSObject
@property (nonatomic, copy)NSString *pic;                       //头像
@property (nonatomic, copy)NSString *name;                      //名称
@property (nonatomic, copy)NSString *descriptionStr;            //描述
@property (nonatomic, copy)NSString *ticketNum;                 //投票总数
@property (nonatomic, copy)NSString *number;                    //编号
@property (nonatomic, copy)NSString *sort;                      //排名
@property (nonatomic, copy)NSString *voteUserID;                //投票选手id
@property (nonatomic, copy)NSString *joinedTicketNum;           //已投票数，如果是0，显示投票按钮

@end

@interface ApplyJoinModel : NSObject
//记录参与者的名字
@property (nonatomic, copy)NSString *joinerTF_data;
//联系电话
@property (nonatomic, copy)NSString *phoneTF_data;
//区域
@property (nonatomic, copy)NSString *areaSelect_data;
//图片选择判断
@property (nonatomic, assign)BOOL isSelectPhoto;
//图片数据
@property (nonatomic, strong)UIImage *headerImage;

//简介
@property (nonatomic, copy)NSString *detail_data;



@end

NS_ASSUME_NONNULL_END
