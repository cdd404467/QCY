//
//  UserInfoModel.h
//  QCY
//
//  Created by i7colors on 2019/10/19.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>


NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject
//审核状态：status=empty,未进行企业认证status= wait_audit,审核中；status=checked;已锁定；status=audit_fail,审核未通过；status=audit审核通过
@property (nonatomic, copy) NSString *status;

//是否是企业用户
@property (nonatomic, copy) NSString *isCompany_User;
//企业用户id
@property (nonatomic, copy) NSString *companyId;
//个人用户id
@property (nonatomic, copy) NSString *userId;
//企业信息id
@property (nonatomic, copy) NSString *compInfoID;
//认证名，不可修改
@property (nonatomic, copy) NSString *companyName;

@end

NS_ASSUME_NONNULL_END
