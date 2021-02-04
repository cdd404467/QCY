//
//  ZhuJiDiyModel.h
//  QCY
//
//  Created by i7colors on 2019/7/31.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhuJiDiyModel : NSObject
//助剂订制id
@property (nonatomic, copy) NSString *zhujiDiyID;
//分类名称
@property (nonatomic, copy) NSString *className;
//助剂名称
@property (nonatomic, copy) NSString *zhujiName;
//获取分类时的助剂名称字段
@property (nonatomic, copy) NSString *name;
//是否是自己发布的，1是自己发布，0不是自己发布
@property (nonatomic, copy) NSString *isCharger;
//发布类型
@property (nonatomic, copy) NSString *publishType;
//企业名称，自己看自己的发布才会显示，否则返回空字符串
@property (nonatomic, copy) NSString *companyName;
//结束时间戳
@property (nonatomic, assign) long long endTimeStamp;
//状态，diying:试样中；accept已采纳；close已关闭；time_out已超时；注：这些状态用于我的页面筛选使用，定制首页列表只需判断‘’进行中‘’和‘’已完成‘’两个状态
@property (nonatomic, copy) NSString *status;
//已有解决方案个数
@property (nonatomic, assign) NSInteger solution_num;
//助剂性能说明
@property (nonatomic, copy) NSString *descriptionStr;

//解决方案数组
@property (nonatomic, strong) NSMutableArray *solutionList;
@property (nonatomic, assign) CGFloat cellHeight;
@end

@interface ZhuJiDiySpecialModel : NSObject
//图片
@property (nonatomic, strong) NSString *logo;
//专场名称
@property (nonatomic, strong) NSString *name;
//介绍
@property (nonatomic, strong) NSString *descriptionStr;
//专场ID
@property (nonatomic, strong) NSString *specialID;
//移动端banner
@property (nonatomic, strong) NSString *mobileBanner;

@end


@interface ZhuJiDiyDetailInfoModel : NSObject
//左边描述文本
@property (nonatomic, copy)NSString *leftText;
//右边信息文本
@property (nonatomic, copy)NSString *rightText;

@property (nonatomic, assign)CGFloat cellHeight;

@end

@interface ZhuJiDiySolutionModel : NSObject
//公司名称
@property (nonatomic, copy)NSString *companyName;
//产品名称
@property (nonatomic, copy)NSString *productName;
//数量
@property (nonatomic, copy)NSString *num;
//数量单位
@property (nonatomic, copy)NSString *numUnit;
//描述
@property (nonatomic, copy) NSString *descriptionStr;
//提交时间
@property (nonatomic, copy) NSString *createdAt;
//解决方案状态，diying试样中，accept已采纳，not_accept未采纳
@property (nonatomic, copy) NSString *status;
//解决方案id
@property (nonatomic, copy) NSString *solutionID;

@property (nonatomic, assign)CGFloat cellHeight;
@end

NS_ASSUME_NONNULL_END
