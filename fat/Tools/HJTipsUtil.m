//
//  HJTipsUtil.m
//  fat
//
//  Created by ydd on 2021/6/17.
//  Copyright © 2021 Marvoto. All rights reserved.
//

#import "HJTipsUtil.h"

@implementation HJTipsUtil

+ (NSString*)resultTips:(HJHTTPModel*)model type:(NSInteger)type{
    
    NSString * url = model.commandCode;
    
    NSString * message = model.errormessage;
    
    
    
    return message;
}

@end
