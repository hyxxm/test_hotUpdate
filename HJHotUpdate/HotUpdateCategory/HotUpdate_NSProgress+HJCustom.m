//
//  NSProgress+HJCustom.m
//  thrallplus
//
//  Created by HeJia on 16/6/21.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HotUpdate_NSProgress+HJCustom.h"
#import <objc/runtime.h>

#define _CUSTOM_FRACTION_KEY_ @"_customFractionCompleted_"

@implementation NSProgress (HJCustom)
@dynamic customFractionCompleted;

-(void)setCustomFractionCompleted:(double)customFractionCompleted{
    objc_setAssociatedObject(self, _CUSTOM_FRACTION_KEY_, [NSNumber numberWithDouble:customFractionCompleted], OBJC_ASSOCIATION_COPY);
}

-(double)customFractionCompleted{
    NSNumber *number = objc_getAssociatedObject(self, _CUSTOM_FRACTION_KEY_);
    return number.doubleValue;
}

+(NSProgress *)hotUpdate_create:(int64_t)total completed:(int64_t)complete customFraction:(double)fraction description:(NSString *)desc{
    NSProgress *progress = [NSProgress new];
    progress.totalUnitCount = total;
    progress.completedUnitCount = complete;
    progress.customFractionCompleted = fraction;
    progress.localizedDescription = desc;
    
    return progress;
}

@end
