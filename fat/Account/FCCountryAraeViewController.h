//
//  CityViewController.h
//  Meitong
//
//  Created by cts on 17/4/13.
//  Copyright © 2017年 cts. All rights reserved.
//

#import "HJBaseViewController.h"

typedef void(^ReturnBlock)(NSString *areaNum);

@interface FCCountryAraeViewController : HJBaseViewController

@property (nonatomic,strong)ReturnBlock delegate;

@end
