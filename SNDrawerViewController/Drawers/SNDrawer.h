//
//  SNDrawer.h
//  SNDrawerViewController
//
//  Created by sunDong on 16/5/20.
//  Copyright © 2016年 snloveydus. All rights reserved.
//

#import "SNDrawerViewController.h"
#import <Foundation/Foundation.h>

@interface SNDrawer : NSObject

@property (nonatomic) SNDrawerViewController * drawerViewController;

//管理初始化的抽屉
+ (instancetype)sharedManager;

//共享的抽屉
+ (SNDrawerViewController *)sharedDrawer;

@end
