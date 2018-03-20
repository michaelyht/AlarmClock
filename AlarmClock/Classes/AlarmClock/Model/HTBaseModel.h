//
//  HTBaseModel.h
//  DriverDream
//
//  Created by Day Ling on 16/7/10.
//  Copyright © 2016年 Lingday. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTBaseModel : NSObject

+ (id)instancefromJsonDic:(NSDictionary*)dic;
+ (NSArray *)instancesFromJsonArray:(NSArray *)array;

@end
