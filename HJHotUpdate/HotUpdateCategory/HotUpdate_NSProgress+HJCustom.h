//
//  NSProgress+HJCustom.h
//  thrallplus
//
//  Created by HeJia on 16/6/21.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSProgress (HJCustom)

@property (nonatomic,assign) double customFractionCompleted;

+(NSProgress *) hotUpdate_create:(int64_t) total completed:(int64_t) complete customFraction:(double) fraction description:(NSString *) desc;

@end
