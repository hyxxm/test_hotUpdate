//
//  HotUpdateInterface.m
//  thrallplus
//
//  Created by HeJia on 16/6/8.
//  Copyright © 2016年 HeJia. All rights reserved.
//

#import "HotUpdateInterface.h"
#import "HotUpdateFacade.h"

inline static HotUpdateFacade *hufacde(){
    return [HotUpdateFacade sharedHotUpdateFacade];
}

UIView *createView(NSString *className , id parent){
    return [hufacde() createView:className parent:parent];
}

UIViewController *createViewController(NSString *className){
    return [hufacde() createViewController:className];
}
//
UIViewController *createViewControllerByAlias(NSString *classAlias, HotUpdateError error){
    return [hufacde() createViewControllerByAlias:classAlias error:error];
}


void checkUpdate(HotUpdateUpdating updateInfo , HotUpdateUpdated updated , HotUpdateError error){
    //! do nothing
    [hufacde() checkUpdate:updateInfo updated:updated error:error];
}

void end(){
    return [hufacde() end];
}

id hu_init(){
    HotUpdateFacade *facade = hufacde();
    return facade;
}

NSBundle *upgradeBundle(){
    return [hufacde() upgradeBundle];
}

NSString* hu_filePath(NSString *fileName , NSString *ex){
    return [hufacde() filePath:fileName Extension:ex];
}
