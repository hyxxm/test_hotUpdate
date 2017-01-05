//
//  NSTimer+block.m
//  thrallplus
//
//  Created by HeJia on 16/6/8.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HotUpdate_NSTimer+block.h"
#import <objc/runtime.h>

#define _BLOCK_TIMER_ @"_blocktimer_"

@implementation NSTimer (block)

+ (NSTimer *)hotUpdate_scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(timerblock) block userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    objc_setAssociatedObject(self, _BLOCK_TIMER_, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    return [self scheduledTimerWithTimeInterval:ti target:self selector:@selector(scheduled:) userInfo:userInfo repeats:yesOrNo];
}

+(void) scheduled:(id) userInfo
{
    timerblock block = objc_getAssociatedObject(self , _BLOCK_TIMER_);
    if(block){
        block(userInfo);
    }
}

@end
