//
//  AppDelegate+JSPatch.h
//  thrallplus
//
//  Created by HeJia on 16/6/13.
//  Copyright © 2016年 HeJia. All rights reserved.
//

//#import "AppDelegate.h"

@interface AppDelegateJSPatch :NSObject

-(void) JPEngineStart;

-(void) JPEngineEvaluateScriptWithPath:(NSString *)scriptPath;

@end
