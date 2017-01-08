//
//  NSTimer+block.h
//  thrallplus
//
//  Created by HeJia on 16/6/8.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^timerblock)(_Nullable id userinfo);

@interface NSTimer (block)

+ (NSTimer * _Nonnull )hotUpdate_scheduledTimerWithTimeInterval:(NSTimeInterval)ti block:(_Nonnull timerblock) block userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

@end
