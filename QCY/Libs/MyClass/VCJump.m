//
//  VCJump.m
//  QCY
//
//  Created by i7colors on 2019/4/25.
//  Copyright © 2019 Shanghai i7colors Ecommerce Co., Ltd. All rights reserved.
//

#import "VCJump.h"
#import "TabbarVC.h"
#import "AskToBuyDetailsVC.h"
#import "GroupBuyingDetailVC.h"
#import "ShopMainPageVC.h"
#import "ProductDetailsVC.h"
#import "InfomationDetailVC.h"
#import "FriendCircleDetailVC.h"
#import "VoteDetailVC.h"
#import "RankDetailVC.h"
#import "AuctionDetailVC.h"
#import "HelpFriendBargainVC.h"
#import "ZhuJiDiyDetailVC.h"
#import "MessageVC.h"
#import "MessageModel.h"
#import "BannerModel.h"
#import "AuctionDetailVC.h"
#import "ProxySaleDetailVC.h"
#import "LiveOnlineDetailVC.h"
#import "WebViewVC.h"

//列表
#import "AskToBuyVC.h"
#import "GroupBuyingVC.h"
#import "OpenMallClassifyVC.h"
#import "ProductMallVC.h"
#import "IndustryInformationVC.h"
#import "AuctionVC.h"
#import "ZhuJiDiySpecialVC.h"
#import "PrchaseLeagueVC.h"
#import "AuctionVC.h"
#import "ProxySaleMarketVC.h"
#import "LiveOnlineVC.h"

@implementation VCJump

//求购  m.i7colors.enquiry/enquiry/enquiryDetail      参数 enquiryId
//产品详情 m.i7colors.product/product/productDetail   参数  id;//商品ID
//资讯详情  m.i7colors.information/information/informationDetail       参数  id
//朋友圈详情  m.i7colors.friendcircle/friendcircle/friendcircleDetail   参数 id
//投票详情 m.i7colors.vote/vote/detail   参数 id
//投票选手  m.i7colors.vote.player/vote/player/detail   参数 id 选手的Id    mainId 投票活动的ID

#pragma mark - 消息跳转
#pragma mark 系统消息点击通知栏跳转
+ (void)jumpToWithModel_Apns:(BannerModel *)model {
//    return;
    UITabBarController *rootVC = (UITabBarController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    BaseNavigationController *nav = rootVC.viewControllers[rootVC.selectedIndex];
//    MessageVC *navRootVC = (MessageVC *)nav.viewControllers.firstObject;
//    navRootVC.index = 2;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"msgtab_item_selected" object:nil];
    
    
    [self judgeWhereToJumpWithType:model.directType jumpID:model.directTypeId nav:nav];
}

//系统消息页面点击跳转
+ (void)jumpToWithModel_SysMsgs:(MessageModel *)model {
    UITabBarController *rootVC = (UITabBarController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    BaseNavigationController *nav = rootVC.viewControllers[rootVC.selectedIndex];
    [self judgeWhereToJumpWithType:model.directType jumpID:model.directTypeId nav:nav];
}

#pragma mark 买家或者卖家消息
+ (void)jumpToVCWithModel:(MessageModel *)model {
    TabbarVC *tbController = (TabbarVC *)[UIApplication sharedApplication].delegate.window.rootViewController;
    tbController.selectedIndex = 2;
    BaseNavigationController *nav = tbController.viewControllers[2];
    MessageVC *navRootVC = (MessageVC *)nav.viewControllers.firstObject;
    
    //判断定位到哪个消息类型下面
    if ([model.type isEqualToString:@"buyer"]) {
        navRootVC.index = 0;
    }
    //卖家
    else if ([model.type isEqualToString:@"seller"]) {
        navRootVC.index = 1;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"msgtab_item_selected" object:nil];
    //求购相关
    if ([model.directType isEqualToString:@"enquiry"]) {
        AskToBuyDetailsVC *vc = [[AskToBuyDetailsVC alloc] init];
        vc.buyID = model.directTypeId;
        [nav pushViewController:vc animated:YES];
    }
    //助剂定制相关
    else if ([model.directType isEqualToString:@"zhujiDiy"]) {
        ZhuJiDiyDetailVC *vc = [[ZhuJiDiyDetailVC alloc] init];
        //买家
        if ([model.type isEqualToString:@"buyer"]) {
            vc.jumpFrom = @"myZhuJiDiy";
        }
        //卖家
        else if ([model.type isEqualToString:@"seller"]) {
            vc.jumpFrom = @"myZhuJiSolution";
        }
        vc.zhuJiDiyID = model.directTypeId;
        [nav pushViewController:vc animated:YES];
    }
}


#pragma mark - 消息跳转判断
//判断要跳转到哪个页面
+ (void)judgeWhereToJumpWithType:(NSString *)vctype jumpID:(NSString *)jumpID nav:(BaseNavigationController *)nav {
    //跳转到求购
    if ([vctype isEqualToString:@"enquiry"]) {
        if (isRightData(jumpID)) {
            AskToBuyDetailsVC *vc = [[AskToBuyDetailsVC alloc] init];
            vc.buyID = jumpID;
            [nav pushViewController:vc animated:YES];
        } else {
            AskToBuyVC *vc = [[AskToBuyVC alloc] init];
            [nav pushViewController:vc animated:YES];
        }
    }
    //跳转到团购
    else if ([vctype isEqualToString:@"groupBuy"]) {
        if (isRightData(jumpID)) {
            GroupBuyingDetailVC *vc = [[GroupBuyingDetailVC alloc] init];
            vc.groupID = jumpID;
            [nav pushViewController:vc animated:YES];
        } else {
            GroupBuyingVC *vc = [[GroupBuyingVC alloc] init];
            [nav pushViewController:vc animated:YES];
        }
    }
    //跳转到店铺
    else if ([vctype isEqualToString:@"market"]) {
        if (isRightData(jumpID)) {
            ShopMainPageVC *vc = [[ShopMainPageVC alloc] init];
            vc.storeID = jumpID;
            [nav pushViewController:vc animated:YES];
        } else {
            OpenMallClassifyVC *vc = [[OpenMallClassifyVC alloc] init];
            [nav pushViewController:vc animated:YES];
        }
    }
    //跳转到产品
    else if ([vctype isEqualToString:@"product"]) {
        if (isRightData(jumpID)) {
            ProductDetailsVC *vc = [[ProductDetailsVC alloc] init];
            vc.productID = jumpID;
            [nav pushViewController:vc animated:YES];
        } else {
            ProductMallVC *vc = [[ProductMallVC alloc] init];
            [nav pushViewController:vc animated:YES];
        }
    }
    //跳转到资讯
    else if ([vctype isEqualToString:@"information"]) {
        if (isRightData(jumpID)) {
            InfomationDetailVC *vc = [[InfomationDetailVC alloc] init];
            vc.infoID = jumpID;
            [nav pushViewController:vc animated:YES];
        } else {
            IndustryInformationVC *vc = [[IndustryInformationVC alloc] init];
            [nav pushViewController:vc animated:YES];
        }
    }
    //跳转到抢购
    else if ([vctype isEqualToString:@"auction"]) {
        if (isRightData(jumpID)) {
            AuctionDetailVC *vc = [[AuctionDetailVC alloc] init];
            vc.jpID = jumpID;
            [nav pushViewController:vc animated:YES];
        } else {
            AuctionVC *vc = [[AuctionVC alloc] init];
            [nav pushViewController:vc animated:YES];
        }
    }
    //跳转到助剂定制
    else if ([vctype isEqualToString:@"zhuji"]) {
        if (isRightData(jumpID)) {
            ZhuJiDiyDetailVC *vc = [[ZhuJiDiyDetailVC alloc] init];
            vc.zhuJiDiyID = jumpID;
            [nav pushViewController:vc animated:YES];
        } else {
            ZhuJiDiySpecialVC *vc = [[ZhuJiDiySpecialVC alloc] init];
            [nav pushViewController:vc animated:YES];
        }
    }
    
    //采购联盟
    else if ([vctype isEqualToString:@"meeting"]) {
        PrchaseLeagueVC *vc = [[PrchaseLeagueVC alloc] init];
        [nav pushViewController:vc animated:YES];
        
    }
    //代销市场
    else if ([vctype isEqualToString:@"proxyMarket"]) {
        if (isRightData(jumpID)) {
            ProxySaleDetailVC *vc = [[ProxySaleDetailVC alloc] init];
            vc.proxyID = jumpID;
            [nav pushViewController:vc animated:YES];
        } else {
            ProxySaleMarketVC *vc = [[ProxySaleMarketVC alloc] init];
            [nav pushViewController:vc animated:YES];
        }
    }
    //课程直播
    else if ([vctype isEqualToString:@"schoolLiveClass"]) {
        if (isRightData(jumpID)) {
            LiveOnlineDetailVC *vc = [[LiveOnlineDetailVC alloc] init];
            vc.courseID = jumpID;
            [nav pushViewController:vc animated:YES];
        } else {
            LiveOnlineVC *vc = [[LiveOnlineVC alloc] init];
            [nav pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - 分享跳转
//分享打开app跳转 - host(m.i7colors.cut)  query(mainId=45&buyerId=383)
+ (void)openShareURLWithHost:(NSString *)host query:(NSString *)query nav:(BaseNavigationController *)nav {
    //求购详情
    if ([host containsString:@"enquiry"]) {
        AskToBuyDetailsVC *vc = [[AskToBuyDetailsVC alloc] init];
        NSArray *uIDs = [query componentsSeparatedByString:@"="];
        vc.buyID = uIDs[1];
        [nav pushViewController:vc animated:YES];
    }
    //产品详情
    else if ([host containsString:@"product"]) {
        ProductDetailsVC *vc = [[ProductDetailsVC alloc] init];
        NSArray *uIDs = [query componentsSeparatedByString:@"="];
        vc.productID = uIDs[1];
        [nav pushViewController:vc animated:YES];
    }
    //资讯详情
    else if ([host containsString:@"information"]) {
        InfomationDetailVC *vc = [[InfomationDetailVC alloc] init];
        NSArray *uIDs = [query componentsSeparatedByString:@"="];
        vc.infoID = uIDs[1];
        [nav pushViewController:vc animated:YES];
    }
    //朋友圈详情
    else if ([host containsString:@"friendcircle"]) {
        FriendCircleDetailVC *vc = [[FriendCircleDetailVC alloc] init];
        NSArray *uIDs = [query componentsSeparatedByString:@"="];
        vc.tieziID = uIDs[1];
        [nav pushViewController:vc animated:YES];
    }
    //详情投票
    else if ([host containsString:@"vote"] && ![host containsString:@"player"]) {
        VoteDetailVC *vc = [[VoteDetailVC alloc] init];
        NSArray *uIDs = [query componentsSeparatedByString:@"="];
        vc.detailID = uIDs[1];
        [nav pushViewController:vc animated:YES];
    }
    //投票选手
    else if ([host containsString:@"vote"] && [host containsString:@"player"]) {
        RankDetailVC *vc = [[RankDetailVC alloc] init];
        NSArray *csIDs = [query componentsSeparatedByString:@"&"];
        NSArray *id_1 = [csIDs[0] componentsSeparatedByString:@"="];
        NSArray *id_2 = [csIDs[1] componentsSeparatedByString:@"="];
        vc.joinerID = id_1[1];
        vc.voteID = id_2[1];
        [nav pushViewController:vc animated:YES];
    }
    //团购砍价
    else if ([host containsString:@"cut"]) {
        HelpFriendBargainVC *vc = [[HelpFriendBargainVC alloc] init];
        NSArray *csIDs = [query componentsSeparatedByString:@"&"];
        NSArray *id_1 = [csIDs[0] componentsSeparatedByString:@"="];
        NSArray *id_2 = [csIDs[1] componentsSeparatedByString:@"="];
        vc.groupID = id_1[1];
        vc.barganID = id_2[1];
        [nav pushViewController:vc animated:YES];
    }
    //代销详情
    else if ([host containsString:@"proxymarket"]) {
        ProxySaleDetailVC *vc = [[ProxySaleDetailVC alloc] init];
        NSArray *uIDs = [query componentsSeparatedByString:@"="];
        vc.proxyID = uIDs[1];
        [nav pushViewController:vc animated:YES];
    }
}

#pragma mark - 广告跳转
+ (void)jumpToWithModel_Ad:(BannerModel *)model {
    UITabBarController *rootVC = (UITabBarController *)UIApplication.sharedApplication.delegate.window.rootViewController;
    BaseNavigationController *nav = rootVC.viewControllers[rootVC.selectedIndex];
    if (isRightData(model.type)) {
        //内部跳转
        if ([model.type isEqualToString:@"inner"]) {
            [self judgeWhereToJumpWithType:model.directType jumpID:model.directTypeId nav:nav];
        } else if ([model.type isEqualToString:@"html"] && isRightData(model.ad_url)) {
            model.ad_url = [model.ad_url stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (model.ad_url.length > 5 && [[model.ad_url substringToIndex:4] isEqualToString:@"http"]) {
                WebViewVC *vc = [[WebViewVC alloc] init];
                vc.webUrl = model.ad_url;
                [nav pushViewController:vc animated:YES];
            } else {
            }
        }
    } else {
        if (isRightData(model.ad_url)) {
            model.ad_url = [model.ad_url stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (model.ad_url.length > 5 && [[model.ad_url substringToIndex:4] isEqualToString:@"http"]) {
                WebViewVC *vc = [[WebViewVC alloc] init];
                vc.webUrl = model.ad_url;
                [nav pushViewController:vc animated:YES];
            }
        } else {
        }
    }
}


@end
