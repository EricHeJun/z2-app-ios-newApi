//
//  HJShareUtil.m
//  fat
//
//  Created by ydd on 2021/5/18.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJShareUtil.h"

@implementation HJShareUtil

+ (void)shareInit{
    
    NSString * callbackLink = @"https://www.sharesdk.cn";
    
    [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
        
        //QQ - 开放平台
        [platformsRegister setupQQWithAppId:@"1111848328" appkey:@"62WJxxMFfaJKt9nD" enableUniversalLink:YES universalLink:@"https://jjjgt.share2dlink.com/qq_conn/1111848328"]; //QQ42457588
        
        //QQ - 互联平台
        //[platformsRegister setupQQWithAppId:@"1110229211" appkey:@"5eZgqnpfiMIkkOzi" enableUniversalLink:YES universalLink:@"https://jjjgt.share2dlink.com/qq_conn/1110229211"]; //
        
        //微信初始化
        [platformsRegister setupWeChatWithAppId:@"wxb77736e53496d66f" appSecret:@"fbd11c1b9daa4104eab704d27ba67411" universalLink:@"https://jjjgt.share2dlink.com/"];
        
        
        //新浪
        [platformsRegister setupSinaWeiboWithAppkey:@"2278258193" appSecret:@"be7ba17bec41c287bce1b3b191f5b8c5" redirectUrl: callbackLink universalLink:callbackLink];
        
        
        //Facebook
        [platformsRegister setupFacebookWithAppkey:@"3061112297286839" appSecret:@"a804f4a562d659a2cf7a67dbb9e5c556" displayName:@"shareSDK"];
        
        //Twitter
        [platformsRegister setupTwitterWithKey:@"Hky8QMDPlBMd2KOE4EptkcUKb" secret:@"fa88feJfj1P07Z9qqm7dLwpzBx5g6Y35xJiv56s5kAy0nsfoJu" redirectUrl:callbackLink];
        
        //Instagram
        [platformsRegister setupInstagramWithClientId:@"3061112297286839" clientSecret:@"a804f4a562d659a2cf7a67dbb9e5c556" redirectUrl:callbackLink];
        
    
    }];
    
}

+ (void)shareImage:(UIImage*)image{
    
    //1.构造分享参数
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic SSDKSetupShareParamsByText:nil
                             images:image
                                url:nil
                              title:nil
                               type:SSDKContentTypeAuto];
    
    SSUIShareSheetConfiguration *config = [[SSUIShareSheetConfiguration alloc] init];
    
    //设置分享菜单为简洁样式
    config.style = SSUIActionSheetStyleSystem;
    
    //设置竖屏有多少个item平台图标显示
    config.columnPortraitCount = 4;
    
    //设置取消按钮标签文本颜色
    config.cancelButtonTitleColor = kkBgRedColor;
    
    //设置对齐方式（简约版菜单无居中对齐）
    config.itemAlignment = SSUIItemAlignmentLeft;
    
    //设置标题文本颜色
    config.itemTitleColor = kkTextBlackColor;
    
    //设置分享菜单栏的背景颜色
    config.menuBackgroundColor = kkBgGrayColor;
    
    //取消按钮是否隐藏，默认不隐藏
    config.cancelButtonHidden = NO;
    
    //设置直接分享的平台（不弹编辑界面）, 直接分享
//  config.directSharePlatforms = @[@(SSDKPlatformTypeSinaWeibo),@(SSDKPlatformTypeTwitter),@(SSDKPlatformTypeWechat),@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeFacebook),@(SSDKPlatformTypeInstagram),@(SSDKPlatformTypeWhatsApp)];
    
    //2.弹出分享菜单
    [ShareSDK showShareActionSheet:nil
                       customItems:@[@(SSDKPlatformSubTypeWechatSession),
                                     @(SSDKPlatformSubTypeWechatTimeline),
                                     @(SSDKPlatformSubTypeQQFriend),
                                     @(SSDKPlatformTypeSinaWeibo),
                                     @(SSDKPlatformTypeFacebook),
                                     @(SSDKPlatformTypeTwitter),
                                     @(SSDKPlatformTypeWhatsApp),
                                     @(SSDKPlatformTypeInstagram)]
     
                       shareParams:dic
                sheetConfiguration:config
                    onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        
        
        
    }];
}

+ (void)shareUI{
    
    SSUIPlatformItem *item_1 = [[SSUIPlatformItem alloc] init];
    item_1.iconNormal = [UIImage imageNamed:@"img_share_wechat"];//默认版显示的图标
    item_1.iconSimple = [UIImage imageNamed:@"img_share_wechat"];//简洁版显示的图标
    item_1.platformId = item_1.platformName = KKLanguage(@"lab_share_platformName_1");
    
    SSUIPlatformItem *item_2 = [[SSUIPlatformItem alloc] init];
    item_2.iconNormal = [UIImage imageNamed:@"img_share_pyq"];
    item_2.iconSimple = [UIImage imageNamed:@"img_share_pyq"];
    item_2.platformId = item_2.platformName = KKLanguage(@"lab_share_platformName_2");
  
    
    //添加点击事件
    [item_1 addTarget:self action:@selector(btnClick)];
   // [item_2 addTarget:self action:@selector(customPlatFormClick:)];
    
    [ShareSDK showShareActionSheet:nil
                       customItems:@[item_1,item_2]
                       shareParams:nil
                sheetConfiguration:nil
                    onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity,
                                     NSError *error, BOOL end){
        
        NSLog(@"hhhh");
        
    }
     ];
}

- (void)customPlatFormClick:(SSUIPlatformItem*)item{
    NSLog(@"%s,---->%@",__func__,item.platformId);
   // do ......
}

- (void)btnClick{
    
    
}


@end
