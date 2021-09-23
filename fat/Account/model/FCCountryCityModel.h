//
//  CityModel.h
//  Meitong
//
//  Created by cts on 17/4/13.
//  Copyright © 2017年 cts. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FCCountryCityModel : JSONModel

@property (nonatomic,copy)NSString *city;
@property (nonatomic,copy)NSString *areaNumber;

@end
