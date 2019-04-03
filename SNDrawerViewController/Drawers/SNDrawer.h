//
//  SNDrawer.h
//  SNDrawerViewController
//
//  Created by sunDong on 16/5/20.
//  Copyright © 2016年 snloveydus. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SNDrawerViewController.h"

@interface SNDrawer : NSObject

@property (nonatomic) SNDrawerViewController * drawerViewController;

/**
 单例初始化
 */
+ (instancetype)sharedManager;

/**
 全局的 SNDrawerViewController
 */
+ (SNDrawerViewController *)sharedDrawer;

@end
